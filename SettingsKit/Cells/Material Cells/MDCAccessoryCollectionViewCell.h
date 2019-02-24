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

#import "MDCBaseCell.h"

@interface MDCAccessoryCollectionViewCell : MDCBaseCell

/**
 A UIView laid out along the leading edge of the view.
 */
@property(nonatomic, strong) UIView *leadingAccessoryView;

/**
 A UIView laid out along the trailing edge of the view.
 */
@property(nonatomic, strong) UIView *trailingAccessoryView;

/**
 The desired size of the leadingAccessoryView.
 */
@property(nonatomic, assign) CGSize *leadingAccessoryViewSize;

/**
 The desired size of the trailingAccessoryView.
 */
@property(nonatomic, assign) CGSize *trailingAccessoryViewSize;

/**
 The UILabel responsible for displaying the title text. By default, `numberOfLines` is set to 0 so
 the label wraps and the self-sizing capabilities of the cell are best utilized.
 */
@property(nonatomic, strong, readonly) UILabel *titleLabel;

/**
 The UILabel responsible for displaying the detail text. By default, `numberOfLines` is set to 0 so
 the label wraps and the self-sizing capabilities of the cell are best utilized.
 */
@property(nonatomic, strong, readonly) UILabel *detailLabel;

/**
 Indicates whether the view's contents should automatically update their font when the device’s
 UIContentSizeCategory changes.
 This property is modeled after the adjustsFontForContentSizeCategory property in the
 UIContentSizeCategoryAdjusting protocol added by Apple in iOS 10.0.
 Default value is NO.
 */
@property(nonatomic, readwrite, setter=mdc_setAdjustsFontForContentSizeCategory:)
BOOL mdc_adjustsFontForContentSizeCategory;

@end
