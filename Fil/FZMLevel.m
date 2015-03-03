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

#import "FZMLevel.h"

static NSString *kFZMLevelAttributeKeyIndex = @"index";
static NSString *kFZMLevelAttributeKeyPattern = @"pattern";
static NSString *kFZMLevelAttributeKeyMaximumNumberOfMistakesAllowed = @"maximumNumberOfMistakedAllowed";
static NSString *kFZMLevelAttributeKeyWaitBetweenCardsDuration = @"waitBetweenCardsDuration";
static NSString *kFZMLevelAttributeKeyTeaseCardDuration = @"teaseCardDuration";

@implementation FZMLevel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  self = [super init];
  if (self) {
    _index = [dictionary[kFZMLevelAttributeKeyIndex] intValue];
    _maximumNumberOfMistakesAllowed = [dictionary[kFZMLevelAttributeKeyMaximumNumberOfMistakesAllowed] intValue];
    _pattern = [self patternFromSpaceDelimitedString:dictionary[kFZMLevelAttributeKeyPattern]];
    _waitBetweenCardsDuration = [dictionary[kFZMLevelAttributeKeyWaitBetweenCardsDuration] floatValue];
    _teaseCardDuration = [dictionary[kFZMLevelAttributeKeyTeaseCardDuration] floatValue];
  }
  return self;
}

- (NSArray *)patternFromSpaceDelimitedString:(NSString *)string
{
  NSArray *array = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                    filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
  NSMutableArray *pattern = [[NSMutableArray alloc] init];
  for (NSString *word in array) {
    [pattern addObject:@([word intValue])];
  }
  return pattern;
}

@end
