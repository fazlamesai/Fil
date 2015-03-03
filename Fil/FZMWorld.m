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

#import "FZMWorld.h"
#import "FZMLevel.h"

static NSString *kFZMWorldAttributeKeyIdentifier = @"identifier";
static NSString *kFZMWorldAttributeKeyTitle = @"title";
static NSString *kFZMWorldAttributeKeySubtitle = @"subtitle";
static NSString *kFZMWorldAttributeKeyIsImplemented = @"isImplemented";
static NSString *kFZMWorldAttributeKeyLevels = @"levels";

@implementation FZMWorld

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  self = [super init];
  if (self) {
    _identifier = [dictionary[kFZMWorldAttributeKeyIdentifier] copy];
    _title = NSLocalizedString([dictionary[kFZMWorldAttributeKeyTitle] copy], nil);
    _subtitle = NSLocalizedString([dictionary[kFZMWorldAttributeKeySubtitle] copy], nil);
    _isImplemented = [dictionary[kFZMWorldAttributeKeyIsImplemented] boolValue];
    
    NSMutableArray *levels = [[NSMutableArray alloc] init];
    for (NSDictionary *levelProperties in dictionary[kFZMWorldAttributeKeyLevels]) {
      [levels addObject:[[FZMLevel alloc] initWithDictionary:levelProperties]];
    }
    
    _levels = [levels sortedArrayUsingComparator:^NSComparisonResult(FZMLevel *first, FZMLevel *second) {
      if (first.index > second.index) {
        return NSOrderedDescending;
      } else if (first.index < second.index) {
        return NSOrderedAscending;
      } else {
        return NSOrderedSame;
      }
    }];
  }
  return self;
}

- (FZMLevel *)levelAfterLevel:(FZMLevel *)level
{
  NSUInteger nextLevelIndex = [self.levels indexOfObject:level] + 1;
  if (nextLevelIndex < [self.levels count]) {
    return self.levels[nextLevelIndex];
  }
  return nil;
}

@end
