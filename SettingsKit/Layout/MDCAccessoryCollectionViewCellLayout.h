// Copyright 2019 the SettingsKit authors. All Rights Reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// https://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MDCAccessoryCollectionViewCellLayout : NSObject

@property(nonatomic, assign, readonly) CGFloat cellWidth;
@property(nonatomic, assign, readonly) CGFloat calculatedHeight;
@property(nonatomic, assign, readonly) CGRect textContainerFrame;
@property(nonatomic, assign, readonly) CGRect titleLabelFrame;
@property(nonatomic, assign, readonly) CGRect detailLabelFrame;
@property(nonatomic, assign, readonly) CGRect leadingAccessoryViewFrame;
@property(nonatomic, assign, readonly) CGRect trailingAccessoryViewFrame;

- (instancetype)initWithLeadingAccessoryView:(UIView *)leadingAccessoryView
                       trailingAccessoryView:(UIView *)trailingAccessoryView
                               textContainer:(UIView *)textContainer
                                  titleLabel:(UILabel *)titleLabel
                                 detailLabel:(UILabel *)detailLabel
                                   cellWidth:(CGFloat)cellWidth;

@end

