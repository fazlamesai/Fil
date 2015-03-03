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

#import "FZMLevelSelectionScene.h"

#import "FZMWorld.h"
#import "FZMLevel.h"
#import "FZMLabelNode.h"
#import "UIColor+FZMColors.h"
#import "FZMLevelButton.h"
#import "FZMUserData.h"
#import "FZMBackButton.h"
#import "FZMCardGameScene.h"
#import "FZMWorldSelectionScene.h"

@interface FZMLevelSelectionScene () <FZMButtonDelegate>

@property (strong, nonatomic) FZMBackButton *backButton;
@property (strong, nonatomic) SKLabelNode *titleLabel;
@property (readwrite, strong, nonatomic) FZMWorld *world;

@end

@implementation FZMLevelSelectionScene

- (instancetype)initWithSize:(CGSize)size world:(FZMWorld *)world
{
  self = [super initWithSize:size];
  if (self) {
    _world = world;
    
    self.titleLabel.position = CGPointMake(CGRectGetMidX(self.playRect), CGRectGetMaxY(self.playRect));
    self.titleLabel.text = world.title;
    [self addChild:self.titleLabel];
    
    [self createLevelButtons];
    
    self.backButton = [[FZMBackButton alloc] init];
    self.backButton.position = CGPointMake(CGRectGetMinX(self.playRect) + 20.0f, CGRectGetMinY(self.playRect));
    self.backButton.delegate = self;
    [self addChild:self.backButton];
  }
  return self;
}

- (SKLabelNode *)titleLabel
{
  if (!_titleLabel) {
    _titleLabel = [[FZMLabelNode alloc] initWithDefaultFont];
    _titleLabel.fontSize = kFZMCaptionLabelFontSize;
    _titleLabel.fontColor = [UIColor fzm_skyBlue];
    _titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
  }
  return _titleLabel;
}

- (void)createLevelButtons
{
  CGSize buttonSize = CGSizeMake(86, 86);
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    buttonSize = CGSizeMake(120, 120);
  }
  
  const CGFloat innerButtonPadding = 2;
  const NSUInteger numberOfColumns = 6;
  const CGFloat totalWidth = (numberOfColumns * buttonSize.width) + ((numberOfColumns - 1) * innerButtonPadding);
  const CGPoint topLeft = CGPointMake(CGRectGetMidX(self.playRect) - totalWidth / 2.0,
                                      CGRectGetMaxY(self.playRect) - buttonSize.height / 2.0);

  [self.world.levels enumerateObjectsUsingBlock:^(FZMLevel *level, NSUInteger index, BOOL *stop) {
    NSUInteger row = index / numberOfColumns;
    NSUInteger col = index % numberOfColumns;
    CGFloat x = topLeft.x + ((col + 0.5) * buttonSize.width) + (innerButtonPadding * col);
    CGFloat y = topLeft.y - ((row + 0.5) * buttonSize.height) - (innerButtonPadding * row);
    
    BOOL isLevelAvailable = [[FZMUserData sharedUserData] isLevelAvailable:level forWorld:self.world];
    UIColor *buttonColor = isLevelAvailable ? [UIColor fzm_skyBlue] : [UIColor lightGrayColor];
    
    FZMLevelButton *button = [[FZMLevelButton alloc] initWithColor:buttonColor size:buttonSize levelIndex:level.index];
    button.delegate = self;
    button.position = CGPointMake(x, y);
    [self addChild:button];
  }];
}

- (void)buttonTapped:(FZMButton *)button
{
  if (button == self.backButton) {
    SKScene *worldSelectionScene = [[FZMWorldSelectionScene alloc] initWithSize:self.size];
    [self.view presentScene:worldSelectionScene
                 transition:[SKTransition pushWithDirection:SKTransitionDirectionRight
                                                   duration:kFZMDefaultScreenTransitionDuration]];
  } else if ([button isKindOfClass:[FZMLevelButton class]]) {
    FZMLevelButton *levelButton = (FZMLevelButton *)button;
    FZMLevel *level = self.world.levels[levelButton.levelIndex - 1];
    
    if ([[FZMUserData sharedUserData] isLevelAvailable:level forWorld:self.world]) {
      FZMCardGameScene *scene = [[FZMCardGameScene alloc] initWithSize:self.size
                                                                 level:level
                                                                 world:self.world];
      [button runAction:[SKAction scaleBy:0.9 duration:0.15] completion:^{
        [self.view presentScene:scene
                     transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft
                                                       duration:kFZMDefaultScreenTransitionDuration]];
      }];
    }
  }
}

@end
