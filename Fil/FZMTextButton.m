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

#import "FZMTextButton.h"
#import "FZMLabelNode.h"

@implementation FZMTextButton

- (instancetype)initWithText:(NSString *)text fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor
{
  self = [super init];
  if (self) {
    FZMLabelNode *label = [[FZMLabelNode alloc] initWithDefaultFont];
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    label.text = text;
    label.fontSize = fontSize;
    label.fontColor = fontColor;
    [self addChild:label];
  }
  return self;
}

@end
