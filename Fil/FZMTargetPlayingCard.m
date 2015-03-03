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

#import "FZMTargetPlayingCard.h"
#import "UIColor+FZMColors.h"

@implementation FZMTargetPlayingCard

- (instancetype)initWithIdentifier:(int)identifier
{
  self = [super initWithIdentifier:identifier];
  if (self) {
    self.back = [SKTexture textureWithImageNamed:@"card_back_question"];
    self.size = CGSizeMake(134.0f, 134.0f);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      self.size = CGSizeMake(225.0f, 225.0f);
    }
  }
  return self;
}

@end
