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

#import "MDCAccessoryCollectionViewCell.h"
#import "MDCAccessoryCollectionViewCellLayout.h"
#import <MDFInternationalization/MDFInternationalization.h>

#import "MaterialInk.h"
#import "MaterialMath.h"
#import "MaterialTypography.h"

static const CGFloat kTitleColorOpacity = 0.87f;
static const CGFloat kDetailColorOpacity = 0.6f;

@interface MDCAccessoryCollectionViewCell ()

@property(nonatomic, strong) UIView *textContainer;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *detailLabel;

@property(nonatomic, strong)
    NSMutableDictionary<NSNumber *, MDCAccessoryCollectionViewCellLayout *> *cachedLayouts;

@end

@implementation MDCAccessoryCollectionViewCell

@synthesize mdc_adjustsFontForContentSizeCategory = _mdc_adjustsFontForContentSizeCategory;

- (instancetype)init {
  self = [super init];
  if (self) {
    [self commonMDCAccessoryViewCellInit];
    return self;
  }
  return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self commonMDCAccessoryViewCellInit];
    return self;
  }
  return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonMDCAccessoryViewCellInit];
    return self;
  }
  return nil;
}

- (void)commonMDCAccessoryViewCellInit {
  [self createSubviews];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Setup

- (void)createSubviews {
  self.textContainer = [[UIView alloc] init];
  [self.contentView addSubview:self.textContainer];

  self.titleLabel = [[UILabel alloc] init];
  self.titleLabel.font = self.defaultTitleLabelFont;
  self.titleLabel.numberOfLines = 0;
  [self.textContainer addSubview:self.titleLabel];

  self.detailLabel = [[UILabel alloc] init];
  self.detailLabel.font = self.defaultDetailLabelFont;
  self.detailLabel.numberOfLines = 0;
  [self.textContainer addSubview:self.detailLabel];
}

#pragma mark UIView Overrides

- (void)layoutSubviews {
  [super layoutSubviews];

  MDCAccessoryCollectionViewCellLayout *layout = [self layoutForCellWidth:self.frame.size.width];
  self.textContainer.frame = layout.textContainerFrame;
  self.titleLabel.frame = layout.titleLabelFrame;
  self.detailLabel.frame = layout.detailLabelFrame;
  self.leadingAccessoryView.frame = layout.leadingAccessoryViewFrame;
  self.trailingAccessoryView.frame = layout.trailingAccessoryViewFrame;
  if (self.mdf_effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.leadingAccessoryView.frame =
    MDFRectFlippedHorizontally(self.leadingAccessoryView.frame, layout.cellWidth);
    self.trailingAccessoryView.frame =
    MDFRectFlippedHorizontally(self.trailingAccessoryView.frame, layout.cellWidth);
    self.textContainer.frame =
    MDFRectFlippedHorizontally(self.textContainer.frame, layout.cellWidth);
    self.titleLabel.frame =
    MDFRectFlippedHorizontally(self.titleLabel.frame, self.textContainer.frame.size.width);
    self.detailLabel.frame =
    MDFRectFlippedHorizontally(self.detailLabel.frame, self.textContainer.frame.size.width);
  } else {
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
  }
}

- (void)setNeedsLayout {
  [self invalidateCachedLayouts];
  [super setNeedsLayout];
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize {
  MDCAccessoryCollectionViewCellLayout *layout = [self layoutForCellWidth:targetSize.width];
  return CGSizeMake(targetSize.width, layout.calculatedHeight);
}

#pragma mark UICollectionViewCell Overrides

- (void)prepareForReuse {
  [super prepareForReuse];

  [self invalidateCachedLayouts];
  self.titleLabel.text = nil;
  self.titleLabel.font = self.defaultTitleLabelFont;
  self.detailLabel.text = nil;
  self.detailLabel.font = self.defaultDetailLabelFont;
}

#pragma mark Accessors

-(void)setTrailingAccessoryView:(UIView *)trailingAccessoryView {
  if (trailingAccessoryView == _trailingAccessoryView) {
    return;
  }
  if (_trailingAccessoryView) {
    [_trailingAccessoryView removeFromSuperview];
  }
  if (trailingAccessoryView) {
    [self.contentView addSubview:trailingAccessoryView];
  }
  _trailingAccessoryView = trailingAccessoryView;
}

-(void)setLeadingAccessoryView:(UIView *)leadingAccessoryView {
  if (leadingAccessoryView == _leadingAccessoryView) {
    return;
  }
  if (_leadingAccessoryView) {
    [_leadingAccessoryView removeFromSuperview];
  }
  if (leadingAccessoryView) {
    [self.contentView addSubview:leadingAccessoryView];
  }
  _leadingAccessoryView = leadingAccessoryView;
}

#pragma mark Layout

- (MDCAccessoryCollectionViewCellLayout *)layoutForCellWidth:(CGFloat)cellWidth {
  CGFloat flooredCellWidth = MDCFloor(cellWidth);
  MDCAccessoryCollectionViewCellLayout *layout = self.cachedLayouts[@(flooredCellWidth)];
  if (!layout) {
    layout = [[MDCAccessoryCollectionViewCellLayout alloc] initWithLeadingAccessoryView:self.leadingAccessoryView
                                                        trailingAccessoryView:self.trailingAccessoryView
                                                                textContainer:self.textContainer
                                                                   titleLabel:self.titleLabel
                                                                  detailLabel:self.detailLabel
                                                                    cellWidth:flooredCellWidth];
    self.cachedLayouts[@(flooredCellWidth)] = layout;
  }
  return layout;
}

- (void)invalidateCachedLayouts {
  [self.cachedLayouts removeAllObjects];
}

#pragma mark Dynamic Type

- (BOOL)mdc_adjustsFontForContentSizeCategory {
  return _mdc_adjustsFontForContentSizeCategory;
}

- (void)mdc_setAdjustsFontForContentSizeCategory:(BOOL)adjusts {
  _mdc_adjustsFontForContentSizeCategory = adjusts;

  if (_mdc_adjustsFontForContentSizeCategory) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryDidChange:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
  } else {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
  }

  [self adjustFontsForContentSizeCategory];
}

// Handles UIContentSizeCategoryDidChangeNotifications
- (void)contentSizeCategoryDidChange:(__unused NSNotification *)notification {
  [self adjustFontsForContentSizeCategory];
}

- (void)adjustFontsForContentSizeCategory {
  UIFont *titleFont = self.titleLabel.font ?: self.defaultTitleLabelFont;
  UIFont *detailFont = self.detailLabel.font ?: self.defaultDetailLabelFont;
  if (_mdc_adjustsFontForContentSizeCategory) {
    titleFont =
    [titleFont mdc_fontSizedForMaterialTextStyle:MDCFontTextStyleTitle
                            scaledForDynamicType:_mdc_adjustsFontForContentSizeCategory];
    detailFont =
    [detailFont mdc_fontSizedForMaterialTextStyle:MDCFontTextStyleCaption
                             scaledForDynamicType:_mdc_adjustsFontForContentSizeCategory];
  }
  self.titleLabel.font = titleFont;
  self.detailLabel.font = detailFont;
  [self setNeedsLayout];
}

#pragma mark Font Defaults

- (UIFont *)defaultTitleLabelFont {
  return [UIFont mdc_standardFontForMaterialTextStyle:MDCFontTextStyleBody2];
}

- (UIFont *)defaultDetailLabelFont {
  return [UIFont mdc_standardFontForMaterialTextStyle:MDCFontTextStyleBody1];
}

- (UIColor *)defaultTitleLabelTextColor {
  return [UIColor colorWithWhite:0 alpha:kTitleColorOpacity];
}

- (UIColor *)defaultDetailLabelTextColor {
  return [UIColor colorWithWhite:0 alpha:kDetailColorOpacity];
}

@end
