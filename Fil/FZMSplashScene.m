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

#import "FZMSplashScene.h"
#import "FZMLabelNode.h"
#import "FZMSoundRepository.h"
#import "FZMWorldSelectionScene.h"

#import "UIColor+FZMColors.h"

@implementation FZMSplashScene

- (instancetype)initWithSize:(CGSize)size
{
  self = [super initWithSize:size];
  if (self) {
    SKLabelNode *title = [[FZMLabelNode alloc] initWithDefaultFont];
    title.text = @"fil";
    title.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    title.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    title.fontColor = [UIColor fzm_skyBlue];
    title.fontSize = kFZMLogoLabelFontSize;
    title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 20.0);
    [self addChild:title];

    SKLabelNode *subtitle = [[FZMLabelNode alloc] initWithDefaultFont];
    subtitle.text = NSLocalizedString(@"TAP TO PLAY", nil);
    subtitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    subtitle.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    subtitle.fontColor = [UIColor fzm_skyBlue];
    subtitle.fontSize = kFZMCaptionLabelFontSize;
    subtitle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + 80.0);
    [self addChild:subtitle];
    
    SKLabelNode *footer = [[FZMLabelNode alloc] initWithDefaultFont];
    footer.text = NSLocalizedString(@"© 2015 fazlamesai", nil);
    footer.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    footer.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    footer.fontColor = [UIColor fzm_skyBlue];
    footer.fontSize = kFZMFooterLabelFontSize;
    footer.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + 20.0);
    [self addChild:footer];
  }
  return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.view presentScene:[[FZMWorldSelectionScene alloc] initWithSize:self.size]
               transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft
                                                 duration:kFZMDefaultScreenTransitionDuration]];
}

@end
