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

#import "FZMLevelButton.h"
#import "FZMLabelNode.h"
#import "FZMLevel.h"

@interface FZMLevelButton ()

@end

@implementation FZMLevelButton

- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size levelIndex:(NSInteger)levelIndex
{
  self = [super init];
  if (self) {
    _levelIndex = levelIndex;
    
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithColor:color size:size];
    [self addChild:background];
    
    SKLabelNode *label = [[FZMLabelNode alloc] initWithDefaultFont];
    label.fontSize = 48.0f;
    label.text = [NSString stringWithFormat:@"%ld", (long)self.levelIndex];
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [background addChild:label];
  }
  return self;
}

@end
