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

#import "FZMSoundRepository.h"

@implementation FZMSoundRepository

+ (instancetype)sharedRepository
{
  static FZMSoundRepository *soundRepository = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    soundRepository = [[FZMSoundRepository alloc] init];
  });
  return soundRepository;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _splashSoundAction = [SKAction playSoundFileNamed:@"click.wav" waitForCompletion:NO];
    _clickSoundAction = [SKAction playSoundFileNamed:@"click.wav" waitForCompletion:NO];
    _backSoundAction = [SKAction playSoundFileNamed:@"click.wav" waitForCompletion:NO];
    _cardsMatchedSoundAction = [SKAction playSoundFileNamed:@"cards_matched.wav" waitForCompletion:NO];
    _cardsMismatchedSoundAction = [SKAction playSoundFileNamed:@"cards_mismatched.wav" waitForCompletion:NO];
  }
  return self;
}

@end
