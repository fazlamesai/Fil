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

#import "FZMPlayingCard.h"
#import "UIColor+FZMColors.h"

NSString * const kFZMPlayingCardNodeName = @"fzm_PlayingCard";

@interface FZMPlayingCard ()

@property (readwrite, assign, nonatomic) int identifier;
@property (strong, nonatomic) SKTexture *front;
@property (readwrite, assign, nonatomic) BOOL flipped;

@end

@implementation FZMPlayingCard

- (instancetype)initWithIdentifier:(int)identifier
{
  NSString *imageName = [NSString stringWithFormat:@"%d", identifier];
  self = [super initWithImageNamed:imageName];
  if (self) {
    _identifier = identifier;
    _front = self.texture;
    _back = [SKTexture textureWithImageNamed:@"card_back"];
    self.name = kFZMPlayingCardNodeName;
    self.texture = _back;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      self.size = CGSizeMake(160.0, 160.0);
    } else {
      self.size = CGSizeMake(66.0, 66.0);
    }

    self.color = [UIColor fzm_skyBlue];
    self.colorBlendFactor = 1.0f;
  }
  return self;
}

- (void)setTappable:(BOOL)tappable
{
  _tappable = tappable;
  self.userInteractionEnabled = tappable;
}

- (void)setBack:(SKTexture *)back
{
  if (_back != back) {
    _back = back;
    self.texture = _back;
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.delegate cardDidStartFlip:self];
  [self flipWithDuration:0.15 completion:^{
    [self.delegate cardDidEndFlip:self];
  }];
}

- (void)flipWithDuration:(NSTimeInterval)duration after:(NSTimeInterval)after
{
  [self flipWithDuration:duration after:after completion:nil];
}

- (void)flipWithDuration:(NSTimeInterval)duration
{
  [self flipWithDuration:duration completion:nil];
}

- (void)flipWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion
{
  [self flipWithDuration:duration after:0.0 completion:completion];
}

- (void)flipWithDuration:(NSTimeInterval)duration after:(NSTimeInterval)after completion:(void (^)(void))completion;
{
  [self runAction:[SKAction sequence:@[[SKAction waitForDuration:after],
                                       [SKAction scaleXTo:0.0 duration:duration],
                                       [SKAction runBlock:^{
                                          [self flipTextures];
                                        }],
                                       [SKAction scaleXTo:1.0 duration:duration]]]
       completion:^{
         if (completion) {
           completion();
         }
       }];
}

- (void)flipTextures
{
  if (self.flipped) {
    self.texture = self.back;
  } else {
    self.texture = self.front;
  }
  self.flipped = !self.flipped;
}

- (void)teaseWithFlipDuration:(NSTimeInterval)flipDuration showFor:(NSTimeInterval)showFor after:(NSTimeInterval)after
{
  [self teaseWithFlipDuration:flipDuration showFor:showFor after:after completion:nil];
}

- (void)teaseWithFlipDuration:(NSTimeInterval)flipDuration
                      showFor:(NSTimeInterval)showFor
                        after:(NSTimeInterval)after
                   completion:(void (^)(void))completion
{
  [self runAction:[SKAction sequence:@[[SKAction waitForDuration:after],
                                       [SKAction scaleXTo:0.0 duration:flipDuration / 2.0],
                                       [SKAction runBlock:^{
                                          [self flipTextures];
                                       }],
                                       [SKAction scaleXTo:1.0 duration:flipDuration / 2.0],
                                       [SKAction waitForDuration:showFor],
                                       [SKAction scaleXTo:0.0 duration:flipDuration / 2.0],
                                       [SKAction runBlock:^{
                                          [self flipTextures];
                                       }],
                                       [SKAction scaleXTo:1.0 duration:flipDuration / 2.0],
                                       ]]
       completion:^{
         if (completion) {
           completion();
         }
       }];
}

- (NSUInteger)hash
{
  return self.identifier;
}

- (BOOL)isEqualToPlayingCard:(FZMPlayingCard *)card
{
  if (self == card) {
    return YES;
  }

  if (self.identifier != card.identifier) {
    return NO;
  }

  return YES;
}

- (BOOL)isEqual:(id)object
{
  if ([self class] == [object class]) {
    return [self isEqualToPlayingCard:(FZMPlayingCard *)object];
  }
  return [super isEqual:object];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<%@:%p, %@>", [self class], self, @{@"identifier": @(self.identifier),
                                                                          @"flipped" : @(self.flipped)}];
}

@end
