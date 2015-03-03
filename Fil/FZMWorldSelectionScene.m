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

#import "FZMWorldSelectionScene.h"

#import "FZMWorldRepository.h"
#import "FZMWorld.h"
#import "FZMWorldSelectionButton.h"
#import "FZMBackButton.h"
#import "FZMSplashScene.h"
#import "FZMLevelSelectionScene.h"

#import "UIColor+FZMColors.h"

@interface FZMWorldSelectionScene () <FZMButtonDelegate>

@property (strong, nonatomic) FZMBackButton *backButton;

@end

@implementation FZMWorldSelectionScene

- (instancetype)initWithSize:(CGSize)size
{
  self = [super initWithSize:size];
  if (self) {
    self.backButton = [[FZMBackButton alloc] init];
    self.backButton.position = CGPointMake(CGRectGetMinX(self.playRect) + 20.0f, CGRectGetMinY(self.playRect));
    self.backButton.delegate = self;
    [self addChild:self.backButton];
    
    CGSize buttonSize = CGSizeMake(180.0f, 180.0f);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      buttonSize = CGSizeMake(190, 190);
    }
    
    const CGFloat innerButtonPadding = 10.0f;
    const NSUInteger numberOfColumns = 2;
    const CGFloat totalWidth = (numberOfColumns * buttonSize.width) + ((numberOfColumns - 1) * innerButtonPadding);
    const CGPoint topLeft = CGPointMake(CGRectGetMidX(self.playRect) - totalWidth / 2.0,
                                        CGRectGetMidY(self.playRect));
    
    [[FZMWorldRepository sharedRepository].worlds enumerateObjectsUsingBlock:
     ^(FZMWorld *world, NSUInteger index, BOOL *stop) {
       //    NSUInteger row = index / numberOfColumns;
       NSUInteger col = index % numberOfColumns;
       CGFloat x = topLeft.x + ((col + 0.5) * buttonSize.width) + (innerButtonPadding * col);
       CGFloat y = topLeft.y; // this is wrong, but i am tired.
       
       UIColor *buttonColor = world.isImplemented ? [UIColor fzm_skyBlue] : [UIColor lightGrayColor];
       
       FZMWorldSelectionButton *button = [[FZMWorldSelectionButton alloc] initWithSize:buttonSize
                                                                                 color:buttonColor
                                                                                 world:world];
       button.delegate = self;
       button.position = CGPointMake(x, y);
       [self addChild:button];
     }];

  }
  return self;
}

- (void)buttonTapped:(FZMButton *)button
{
  if (button == self.backButton) {
    [self.view presentScene:[[FZMSplashScene alloc] initWithSize:self.size]
                 transition:[SKTransition pushWithDirection:SKTransitionDirectionRight
                                                   duration:kFZMDefaultScreenTransitionDuration]];
    
  } else if ([button isKindOfClass:[FZMWorldSelectionButton class]]) {
    FZMWorldSelectionButton *worldSelectionButton = (FZMWorldSelectionButton *)button;
    if (worldSelectionButton.world.isImplemented) {
      [button runAction:[SKAction scaleBy:0.9 duration:0.15] completion:^{
        [self.view presentScene:[[FZMLevelSelectionScene alloc] initWithSize:self.size world:worldSelectionButton.world]
                     transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft
                                                       duration:kFZMDefaultScreenTransitionDuration]];
      }];
    }
  }
}

@end
