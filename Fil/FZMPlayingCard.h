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

#import <SpriteKit/SpriteKit.h>

extern NSString * const kFZMPlayingCardNodeName;

@class FZMPlayingCard;

@protocol FZMPlayingCardDelegate <NSObject>

- (void)cardDidStartFlip:(FZMPlayingCard *)card;
- (void)cardDidEndFlip:(FZMPlayingCard *)card;

@end

@interface FZMPlayingCard : SKSpriteNode

@property (readonly, nonatomic) int identifier;
@property (readonly, nonatomic) BOOL flipped;
@property (assign, nonatomic) BOOL tappable;
@property (strong, nonatomic) SKTexture *back;
@property (weak, nonatomic) id<FZMPlayingCardDelegate> delegate;

- (instancetype)initWithIdentifier:(int)identifier;
- (void)flipWithDuration:(NSTimeInterval)duration;
- (void)flipWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;
- (void)flipWithDuration:(NSTimeInterval)duration after:(NSTimeInterval)after;
- (void)flipWithDuration:(NSTimeInterval)duration after:(NSTimeInterval)after completion:(void (^)(void))completion;
- (void)teaseWithFlipDuration:(NSTimeInterval)flipDuration showFor:(NSTimeInterval)showFor after:(NSTimeInterval)after;
- (void)teaseWithFlipDuration:(NSTimeInterval)flipDuration showFor:(NSTimeInterval)showFor after:(NSTimeInterval)after
                   completion:(void (^)(void))completion;

- (BOOL)isEqualToPlayingCard:(FZMPlayingCard *)card;

@end
