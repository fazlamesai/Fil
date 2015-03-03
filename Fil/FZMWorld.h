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

#import <Foundation/Foundation.h>

@class FZMLevel;

@interface FZMWorld : NSObject

@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (readonly, nonatomic) BOOL isImplemented;
@property (readonly, nonatomic) NSArray *levels;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (FZMLevel *)levelAfterLevel:(FZMLevel *)level;

@end