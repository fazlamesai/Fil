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

#import "FZMWorldSelectionButton.h"
#import "FZMWorld.h"
#import "FZMLabelNode.h"
#import "FZMUserData.h"

@implementation FZMWorldSelectionButton

- (instancetype)initWithSize:(CGSize)size color:(UIColor *)color world:(FZMWorld *)world
{
  self = [super init];
  if (self) {
    _world = world;
    
    SKSpriteNode *buttonBackground = [[SKSpriteNode alloc] initWithColor:color size:size];
    buttonBackground.colorBlendFactor = 1.0;
    
    SKLabelNode *buttonTitleLabel = [[FZMLabelNode alloc] initWithDefaultFont];
    buttonTitleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    buttonTitleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    buttonTitleLabel.text = world.title;
    buttonTitleLabel.fontSize = kFZMSubsubtitleLabelFontSize;
    buttonTitleLabel.fontColor = [UIColor whiteColor];
    buttonTitleLabel.position = CGPointMake(0.0f, 20.0f);
    [buttonBackground addChild:buttonTitleLabel];
    
    SKLabelNode *buttonSubtitleLabel = [[FZMLabelNode alloc] initWithDefaultFont];
    buttonSubtitleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    buttonSubtitleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    buttonSubtitleLabel.text = world.subtitle;
    buttonSubtitleLabel.fontSize = kFZMCaptionLabelFontSize;
    buttonSubtitleLabel.fontColor = [UIColor whiteColor];
    buttonSubtitleLabel.position = CGPointMake(0.0f, -20.0f);
    
    if (world.isImplemented) {
      NSUInteger numberOfFinishedLevels = [[FZMUserData sharedUserData] availableLevelIndexForWorld:world] - 1;
      NSString *subtitle = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)numberOfFinishedLevels,
                            (unsigned long)[world.levels count]];
      buttonSubtitleLabel.text = subtitle;
    }
    
    [buttonBackground addChild:buttonSubtitleLabel];
    [self addChild:buttonBackground];
  }
  return self;
}

@end
