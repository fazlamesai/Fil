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

#import "FZMBackButton.h"
#import "FZMLabelNode.h"
#import "FZMSoundRepository.h"

#import "UIColor+FZMColors.h"

@implementation FZMBackButton

- (instancetype)init
{
  self = [super init];
  if (self) {
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeZero];
    SKSpriteNode *chevron = [[SKSpriteNode alloc] initWithImageNamed:@"chevron"];
    chevron.color = [UIColor fzm_skyBlue];
    chevron.colorBlendFactor = 1.0;
    chevron.size = CGSizeMake(20.0, 30.0);
    chevron.anchorPoint = CGPointMake(1.0f, 0.5f);
    [background addChild:chevron];
    background.size = CGSizeMake(chevron.size.width * 2.5f, chevron.size.height * 1.5f);
    [self addChild:background];
  }
  return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self runAction:[[FZMSoundRepository sharedRepository] backSoundAction]];
  [super touchesEnded:touches withEvent:event];
}

@end
