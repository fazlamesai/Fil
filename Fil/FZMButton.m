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

#import "FZMButton.h"
#import "FZMSoundRepository.h"

@implementation FZMButton

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.userInteractionEnabled = YES;
  }
  return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self runAction:[[FZMSoundRepository sharedRepository] clickSoundAction]];
  if ([self.delegate respondsToSelector:@selector(buttonTapped:)]) {
    [self.delegate buttonTapped:self];
  }
}

@end
