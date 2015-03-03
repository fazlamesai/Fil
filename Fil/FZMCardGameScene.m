// Copyright 2015 Fazlamesai
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "FZMCardGameScene.h"

#import "FZMBackButton.h"
#import "FZMLabelNode.h"
#import "FZMLevel.h"
#import "FZMLevelSelectionScene.h"
#import "FZMPlayingCard.h"
#import "FZMSoundRepository.h"
#import "FZMSplashScene.h"
#import "FZMTargetPlayingCard.h"
#import "FZMTextButton.h"
#import "FZMUserData.h"
#import "NSArray+FZMRandom.h"
#import "NSMutableArray+Shuffle.h"
#import "FZMWorld.h"
#import "UIColor+FZMColors.h"

typedef NS_ENUM(int, FZMCardGameSceneState) {
  FZMCardGameSceneStateInitial,
  FZMCardGameSceneStateShowingCards,
  FZMCardGameSceneStateStarted,
  FZMCardGameSceneStateCardAnimating,
  FZMCardGameSceneStateSuccess,
  FZMCardGameSceneStateFailure
};

NSString *NSStringFromCardGameSceneState(FZMCardGameSceneState state) {
  switch (state) {
    case FZMCardGameSceneStateInitial: return @"initial";
    case FZMCardGameSceneStateShowingCards: return @"showing cards";
    case FZMCardGameSceneStateStarted: return @"started";
    case FZMCardGameSceneStateCardAnimating: return @"card animating";
    case FZMCardGameSceneStateSuccess: return @"success";
    case FZMCardGameSceneStateFailure: return @"failure";
  }
}

@interface FZMCardGameScene () <FZMButtonDelegate, FZMPlayingCardDelegate>

@property (assign, nonatomic) NSInteger numberOfMistakes;
@property (strong, nonatomic) FZMPlayingCard *targetCard;
@property (strong, nonatomic) NSDictionary *locationMap; // location in grid x card
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *matchedCards;
@property (strong, nonatomic) NSMutableArray *remainingTargetCards;
@property (assign, nonatomic) NSInteger remainingLives;

@property (strong, nonatomic) FZMBackButton *backButton;

// game states
@property (assign, nonatomic) FZMCardGameSceneState state;

@property (strong, nonatomic) SKNode *cardsLayer;
@property (strong, nonatomic) SKNode *initialLayer;
@property (strong, nonatomic) SKNode *hudLayer;
@property (strong, nonatomic) SKSpriteNode *failureLayer;
@property (strong, nonatomic) SKSpriteNode *successLayer;

@property (strong, nonatomic) FZMTextButton *retryButton;
@property (strong, nonatomic) FZMTextButton *nextLevelButton;

@end

@implementation FZMCardGameScene

- (instancetype)initWithSize:(CGSize)size level:(FZMLevel *)level world:(FZMWorld *)world
{
  self = [super initWithSize:size];
  if (self) {
    _level = level;
    _world = world;
    _remainingTargetCards = [[NSMutableArray alloc] init];
    _matchedCards = [[NSMutableArray alloc] init];
    _numberOfMistakes = 0;
    
    self.hudLayer.position = CGPointMake(CGRectGetMinX(self.playRect), CGRectGetMaxY(self.playRect));
    [self addChild:self.hudLayer];
    self.remainingLives = level.maximumNumberOfMistakesAllowed;
    
    _cardsLayer = [[SKNode alloc] init];
    _cardsLayer.position = CGPointMake(CGRectGetMidX(self.playRect), CGRectGetMidY(self.playRect));
    [self addChild:_cardsLayer];
    [self startGame];
    
    self.initialLayer.position = CGPointMake(CGRectGetMidX(self.playRect), CGRectGetMidY(self.playRect));
    [self addChild:self.initialLayer];
    self.state = FZMCardGameSceneStateInitial;
    
    self.failureLayer = [[SKSpriteNode alloc] initWithColor:[UIColor colorWithWhite:0.000 alpha:0.520]
                                                       size:CGRectInset(self.frame, 60.0f, 60.0f).size];
    self.failureLayer.position = CGPointMake(CGRectGetMidX(self.playRect), CGRectGetMidY(self.playRect));
    
    self.successLayer = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:self.playRect.size];
    self.successLayer.position = CGPointMake(CGRectGetMidX(self.playRect), CGRectGetMidY(self.playRect));
  }
  return self;
}

- (SKNode *)initialLayer
{
  if (!_initialLayer) {
    _initialLayer = [[SKNode alloc] init];
    
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithColor:[UIColor colorWithWhite:0.000 alpha:0.780] size:self.size];
    
    SKLabelNode *levelTitle = [[FZMLabelNode alloc] initWithDefaultFont];
    levelTitle.text = [NSString stringWithFormat:@"%ld", (long)self.level.index];
    levelTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    levelTitle.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    levelTitle.fontSize = 64.0f;
    levelTitle.fontColor = [UIColor fzm_skyBlue];
    levelTitle.position = CGPointMake(0, 30.0);
    [background addChild:levelTitle];
    
    SKLabelNode *tapToStartLabelNode = [[FZMLabelNode alloc] initWithDefaultFont];
    tapToStartLabelNode.fontColor = [UIColor fzm_skyBlue];
    tapToStartLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    tapToStartLabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    tapToStartLabelNode.fontSize = 32.0;
    tapToStartLabelNode.position = CGPointMake(0, -30.0);
    tapToStartLabelNode.text = NSLocalizedString(@"Tap to start", nil);
    [background addChild:tapToStartLabelNode];
    
    [_initialLayer addChild:background];
  }
  return _initialLayer;
}

- (FZMTextButton *)retryButton
{
  if (!_retryButton) {
    _retryButton = [[FZMTextButton alloc] initWithText:@"Retry" fontSize:24.0f fontColor:[UIColor fzm_skyBlue]];
    _retryButton.delegate = self;
  }
  return _retryButton;
}

- (FZMTextButton *)nextLevelButton
{
  if (!_nextLevelButton) {
    _nextLevelButton = [[FZMTextButton alloc] initWithText:@"Next Level" fontSize:24.0f fontColor:[UIColor fzm_skyBlue]];
    _nextLevelButton.delegate = self;
  }
  return _nextLevelButton;
}

- (void)createBackButton
{
  self.backButton = [[FZMBackButton alloc] init];
  self.backButton.position = CGPointMake(CGRectGetMinX(self.frame) + 40.0f, CGRectGetMinY(self.frame) + 30.0f);
  self.backButton.delegate = self;
  [self addChild:self.backButton];
}

- (void)setNumberOfMistakes:(NSInteger)numberOfMistakes
{
  _numberOfMistakes = numberOfMistakes;
  self.remainingLives = self.level.maximumNumberOfMistakesAllowed - numberOfMistakes;
}

- (SKNode *)hudLayer
{
  if (!_hudLayer) {
    _hudLayer = [[SKNode alloc] init];
  }
  return _hudLayer;
}

- (void)setRemainingLives:(NSInteger)remainingLives
{
  _remainingLives = remainingLives;
  [self.hudLayer removeAllChildren];
  
  if (_remainingLives < 0) {
    self.state = FZMCardGameSceneStateFailure;
  }
  
  for (NSInteger i = 0; i < self.level.maximumNumberOfMistakesAllowed; ++i) {
    SKSpriteNode *fil = [[SKSpriteNode alloc] initWithImageNamed:@"fil"];
    fil.colorBlendFactor = 1.0f;
    
    if (i < _remainingLives) {
      fil.color = [UIColor fzm_skyBlue];
    } else {
      fil.color = [UIColor colorWithWhite:0.800 alpha:1.000];
    }
    
    fil.size = CGSizeMake(32.0, 20.0f);
    fil.position = CGPointMake(i * fil.size.width + 10.0f, 0);
    [self.hudLayer addChild:fil];
  }
}

- (void)enableCards
{
  for (FZMPlayingCard *card in self.cards) {
    if ([self.matchedCards containsObject:card]) {
      continue;
    }
    card.tappable = YES;
  }
}

- (void)disableCards
{
  for (FZMPlayingCard *card in self.cards) {
    card.tappable = NO;
  }
}

- (void)setState:(FZMCardGameSceneState)state
{
  BLog(@"%@ to %@", NSStringFromCardGameSceneState(_state), NSStringFromCardGameSceneState(state));
  _state = state;
  
  switch (state) {
    case FZMCardGameSceneStateInitial: {
      break;
    }
      
    case FZMCardGameSceneStateShowingCards: {
      [self.initialLayer runAction:[SKAction fadeAlphaTo:0.0 duration:0.35] completion:^{
        [self.initialLayer removeFromParent];
        [self flipCards];
      }];
      break;
    }
      
    case FZMCardGameSceneStateStarted: {
      [self enableCards];
      break;
    }
      
    case FZMCardGameSceneStateCardAnimating: {
      [self disableCards];
      break;
    }
      
    case FZMCardGameSceneStateSuccess: {
      [self disableCards];
      [self levelFinished];
      break;
    }
      
    case FZMCardGameSceneStateFailure: {
      [self disableCards];
      [self showGameOverLayer];
      break;
    }
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (self.state == FZMCardGameSceneStateInitial) {
    self.state = FZMCardGameSceneStateShowingCards;
  }
}

- (void)cardDidStartFlip:(FZMPlayingCard *)card
{
  BLog(@"card start flip: %@", card);
  self.state = FZMCardGameSceneStateCardAnimating;
}

- (void)cardDidEndFlip:(FZMPlayingCard *)card
{
  if ([card isEqualToPlayingCard:self.targetCard]) {
    [self runAction:[[FZMSoundRepository sharedRepository] cardsMatchedSoundAction]];
    card.tappable = NO;
    [self.matchedCards addObject:card];
    SKAction *scaleAction = [SKAction scaleBy:1.1 duration:0.10];
    [card runAction:scaleAction completion:^{
      [card runAction:[scaleAction reversedAction]];
    }];
    [self.targetCard runAction:scaleAction completion:^{
      [self.targetCard runAction:[SKAction sequence:@[[scaleAction reversedAction], [SKAction waitForDuration:0.75]]]
                      completion:^{
                        self.state = FZMCardGameSceneStateStarted;
                        FZMPlayingCard *randomCard = [self pickTargetCard];
                       
                        if (!randomCard) {
                          self.state = FZMCardGameSceneStateSuccess;
                        } else {
                          CGPoint targetCardPosition = self.targetCard.position;
                          [self.targetCard removeFromParent];
                          self.targetCard = [[FZMTargetPlayingCard alloc] initWithIdentifier:randomCard.identifier];
                          self.targetCard.position = targetCardPosition;
                          [self.targetCard flipWithDuration:0.15];
                          [self.cardsLayer addChild:self.targetCard];
                        }
                      }];
    }];
  } else {
    [self runAction:[[FZMSoundRepository sharedRepository] cardsMismatchedSoundAction]];
    [card flipWithDuration:0.15 completion:^{
      self.state = FZMCardGameSceneStateStarted;
      ++self.numberOfMistakes;
    }];
  }
}

- (void)levelFinished
{
  [[FZMUserData sharedUserData] saveLevelCompleted:self.level forWorld:self.world];
  FZMLevel *nextLevel = [self.world levelAfterLevel:self.level];
  
  if (nextLevel) {
    FZMCardGameScene *nextScene = [[FZMCardGameScene alloc] initWithSize:self.size
                                                                    level:nextLevel
                                                                    world:self.world];
    [self.view presentScene:nextScene
                 transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft
                                                   duration:kFZMDefaultScreenTransitionDuration]];
  } else {
    FZMLevelSelectionScene *nextScene = [[FZMLevelSelectionScene alloc] initWithSize:self.size world:self.world];
    [self.view presentScene:nextScene
                 transition:[SKTransition pushWithDirection:SKTransitionDirectionRight
                                                   duration:kFZMDefaultScreenTransitionDuration]];
  }
}

- (void)showGameOverLayer
{
  // NOTE: Interestingly the following code does not work. self.children is less than the total number of cards.
//  [self enumerateChildNodesWithName:kFZMPlayingCardNodeName usingBlock:^(SKNode *node, BOOL *stop) {
//    [node removeFromParent];
//  }];
  NSTimeInterval delay = 0.0f;
  
  for (FZMPlayingCard *card in self.cards) {
    if (!card.flipped) {
      [self runAction:[SKAction sequence:@[[SKAction waitForDuration:delay], [SKAction runBlock:^{
        [card flipWithDuration:0.15];
      }]]]];
      delay += 0.10f;
    }
  }
  
  SKLabelNode *gameOverLabel = [[FZMLabelNode alloc] initWithDefaultFont];
  gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
  gameOverLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  gameOverLabel.fontColor = [UIColor whiteColor];
  gameOverLabel.fontSize = 36;
  gameOverLabel.text = NSLocalizedString(@"Game Over", nil);
  
  SKSpriteNode *labelContainer = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(200, 80)];
  [labelContainer addChild:gameOverLabel];
  [self.failureLayer addChild:labelContainer];
  
  FZMLevel *nextLevel = [self.world levelAfterLevel:self.level];
  
  [self runAction:[SKAction sequence:@[
                                       [SKAction waitForDuration:delay],
                                       [SKAction runBlock:^{
    [self addChild:self.failureLayer];

    self.retryButton.position = CGPointMake(-self.failureLayer.size.width / 2.0f + 40.0f,
                                            -self.failureLayer.size.height / 2.0f + 20.0f);
    [self.failureLayer addChild:self.retryButton];
    
    if (nextLevel && [[FZMUserData sharedUserData] isLevelAvailable:nextLevel forWorld:self.world]) {
      self.nextLevelButton.position = CGPointMake(self.failureLayer.size.width / 2.0f - 60.0f,
                                                  -self.failureLayer.size.height / 2.0f + 20.0f);
      [self.failureLayer addChild:self.nextLevelButton];
    }
  }]]]];
}

- (void)removeAllCards
{
  [self.cards enumerateObjectsUsingBlock:^(FZMPlayingCard *card, NSUInteger idx, BOOL *stop) {
    [card removeFromParent];
  }];
  [self.targetCard removeFromParent];
}

- (void)startGame
{
  [self createBackButton];
  [self.cards fzm_shuffle];

  // Select a random card as the target
  FZMPlayingCard *randomCard = [self pickTargetCard];
  self.targetCard = [[FZMTargetPlayingCard alloc] initWithIdentifier:randomCard.identifier];

  [self layoutCards];
}

- (FZMPlayingCard *)pickTargetCard
{
  return [[self availableCards] fzm_randomElement];
}

- (NSArray *)availableCards
{
  NSMutableArray *availableCards = [[NSMutableArray alloc] init];
  
  for (FZMPlayingCard *card in self.cards) {
    if (self.targetCard && [card isEqualToPlayingCard:self.targetCard]) {
      continue;
    }
    
    if (![self.matchedCards containsObject:card]) {
      [availableCards addObject:card];
    }
  }
  
  return availableCards;
}

- (void)layoutCards
{
  // Use first card to get the card size
  FZMPlayingCard *firstCard = [self.cards firstObject];
  CGSize cardSize = firstCard.size;
  
  // layout settings
  const int numberOfColumns = 4;
  const int numberOfRows = 4;
  
  const CGFloat innerPadding = 1.0f;
  const CGFloat totalWidth = (numberOfColumns * cardSize.width) + (numberOfColumns - 1) * innerPadding;
  const CGFloat totalHeight = (numberOfRows * cardSize.height) + (numberOfRows - 1) * innerPadding;
  const CGFloat minX = -totalWidth / 2.0;
  const CGFloat maxY = totalHeight / 2.0;
  const CGFloat yMargin = (self.size.height - ((numberOfRows * cardSize.height) + ((numberOfRows - 1) * innerPadding))) / 2.0;
  const CGFloat availableRightWidth = (self.size.width - totalWidth) / 2.0f;
  const CGFloat rightMargin = availableRightWidth - yMargin;

  [self.locationMap enumerateKeysAndObjectsUsingBlock:^(NSNumber *index, SKSpriteNode *card, BOOL *stop) {
    int row = [index intValue] / numberOfColumns;
    int col = [index intValue] % numberOfColumns;
    const CGPoint topLeft = CGPointMake(minX, maxY);
    CGFloat x = topLeft.x + ((col + 0.5) * cardSize.width) + (innerPadding * col) + rightMargin;
    CGFloat y = topLeft.y - ((row + 0.5) * cardSize.height) - (innerPadding * row);
    CGPoint point = CGPointMake(x, y);
    card.position = point;
    [self.cardsLayer addChild:card];
  }];
  
  // Put the target card
  self.targetCard.position = CGPointMake(-self.size.width / 2.0 + yMargin + self.targetCard.size.width / 2.0f, 0.0f);  
  [self.cardsLayer addChild:self.targetCard];
}

- (void)flipCards
{
  CGFloat waitBetweenCardsDuration = self.level.waitBetweenCardsDuration / 1000.0;
  CGFloat teaseCardDuration = self.level.teaseCardDuration / 1000.0;
  CGFloat flipDuration = 0.15f;
  __block CGFloat after = 0.0;
  
  // DEBUG
//  waitBetweenCardsDuration = 0.1;
//  teaseCardDuration = 0.01;

  [self.cards enumerateObjectsUsingBlock:^(FZMPlayingCard *card, NSUInteger index, BOOL *stop) {
    [card teaseWithFlipDuration:flipDuration showFor:teaseCardDuration after:after];
    after += waitBetweenCardsDuration + teaseCardDuration + 2 * flipDuration;
  }];

  [self runAction:[SKAction sequence:@[[SKAction waitForDuration:after - waitBetweenCardsDuration],
                                       [SKAction runBlock:^{
    [self.targetCard flipWithDuration:flipDuration after:0.0 completion:^{
      self.state = FZMCardGameSceneStateStarted;
    }];
  }]]]];
}

- (NSDictionary *)locationMap
{
  if (!_locationMap) {
    NSArray *cards = self.cards;
    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [self.level.pattern count]; ++i) {
      map[self.level.pattern[i]] = cards[i];
    }
    _locationMap = [map copy];
  }
  return _locationMap;
}

- (NSMutableArray *)cards
{
  if (!_cards) {
    NSMutableArray *allCardNumbers = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 22; ++i) {
      [allCardNumbers addObject:@(i)];
    }
    [allCardNumbers fzm_shuffle];

    _cards = [[NSMutableArray alloc] init];

    for (int i = 0; i < [self.level.pattern count]; ++i) {
      FZMPlayingCard *card = [[FZMPlayingCard alloc] initWithIdentifier:[allCardNumbers[i] intValue]];
      card.delegate = self;
      [_cards addObject:card];
    }
  }
  return _cards;
}

- (void)buttonTapped:(FZMButton *)button
{
  if (button == self.backButton) {
    [self.view presentScene:[[FZMLevelSelectionScene alloc] initWithSize:self.size world:self.world]
                 transition:[SKTransition pushWithDirection:SKTransitionDirectionRight
                                                   duration:kFZMDefaultScreenTransitionDuration]];
  } else if (button == self.retryButton) {
    [self.view presentScene:[[FZMCardGameScene alloc] initWithSize:self.size level:self.level world:self.world]
                 transition:[SKTransition doorsOpenHorizontalWithDuration:kFZMDefaultScreenTransitionDuration]];
  } else if (button == self.nextLevelButton) {
    FZMLevel *nextLevel = [self.world levelAfterLevel:self.level];
    FZMCardGameScene *nextScene = [[FZMCardGameScene alloc] initWithSize:self.size
                                                                   level:nextLevel
                                                                   world:self.world];
    [self.view presentScene:nextScene
                 transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft
                                                   duration:kFZMDefaultScreenTransitionDuration]];
  }
}

@end
