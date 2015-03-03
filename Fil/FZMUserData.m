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

#import "FZMUserData.h"
#import "FZMLevel.h"
#import "FZMWorld.h"
#import "FZMWorldRepository.h"

@implementation FZMUserData

+ (instancetype)sharedUserData
{
  static FZMUserData *userData = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    userData = [[FZMUserData alloc] init];
  });
  return userData;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    [self registerDefaults];
  }
  return self;
}

- (void)registerDefaults
{
  NSDictionary *currentData = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"worlds"];
  NSMutableDictionary *worldsData = [[NSMutableDictionary alloc] init];
  
  for (FZMWorld *world in [[FZMWorldRepository sharedRepository] worlds]) {
    if (currentData[world.identifier]) {
      worldsData[world.identifier] = currentData[world.identifier];
    } else {
      worldsData[world.identifier] = @(1);
    }
  }
  
  [[NSUserDefaults standardUserDefaults] setObject:[worldsData copy] forKey:@"worlds"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLevelAvailable:(FZMLevel *)level forWorld:(FZMWorld *)world
{
  return [self availableLevelIndexForWorld:world] >= level.index;
}

- (void)saveLevelCompleted:(FZMLevel *)level forWorld:(FZMWorld *)world
{
  NSInteger currentMaxIndex = [self availableLevelIndexForWorld:world];
  if (level.index + 1 > currentMaxIndex) {
    NSMutableDictionary *currentData = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"worlds"] mutableCopy];
    currentData[world.identifier] = @([currentData[world.identifier] integerValue] + 1);
    [[NSUserDefaults standardUserDefaults] setObject:[currentData copy] forKey:@"worlds"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}

- (NSInteger)availableLevelIndexForWorld:(FZMWorld *)world
{
  return [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"worlds"][world.identifier] integerValue];
}

@end
