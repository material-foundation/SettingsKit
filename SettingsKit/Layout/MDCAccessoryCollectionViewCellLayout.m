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

#import "MDCAccessoryCollectionViewCellLayout.h"

static const CGFloat kVerticalMarginMin = 8.0;
static const CGFloat kVerticalMarginMax = 16.0;
static const CGFloat kHorizontalMargin = 16.0;

static const CGFloat kImageSideLengthMedium = 40.0;
static const CGFloat kImageSideLengthMax = 56.0;

@interface MDCAccessoryCollectionViewCellLayout ()

@property(nonatomic, assign) CGFloat cellWidth;
@property(nonatomic, assign) CGFloat calculatedHeight;
@property(nonatomic, assign) CGRect textContainerFrame;
@property(nonatomic, assign) CGRect titleLabelFrame;
@property(nonatomic, assign) CGRect detailLabelFrame;
@property(nonatomic, assign) CGRect leadingAccessoryViewFrame;
@property(nonatomic, assign) CGRect trailingAccessoryViewFrame;

@end

@implementation MDCAccessoryCollectionViewCellLayout

- (instancetype)initWithLeadingAccessoryView:(UIView *)leadingAccessoryView
trailingAccessoryView:(UIView *)trailingAccessoryView
                               textContainer:(UIView *)textContainer
                                  titleLabel:(UILabel *)titleLabel
                                 detailLabel:(UILabel *)detailLabel
                                   cellWidth:(CGFloat)cellWidth {
  self = [super init];
  if (self) {
    self.cellWidth = cellWidth;
    [self assignFrameForLeadingAccessoryView:leadingAccessoryView];
    [self assignFrameForTrailingAccessoryView:trailingAccessoryView];
    [self assignFramesForTextContainer:textContainer titleLabel:titleLabel detailLabel:detailLabel];
    self.calculatedHeight = [self calculateHeight];
  }
  return self;
}

- (void)assignFrameForLeadingAccessoryView:(UIView *)leadingAccessoryView {
  CGSize size = leadingAccessoryView.frame.size;
  CGFloat leadingPadding = 0;
  CGFloat topPadding = 0;
  if (!CGSizeEqualToSize(size, CGSizeZero)) {
    leadingPadding = kHorizontalMargin;
    topPadding = [self verticalMarginForAccessoryViewOfSize:size];
  }
  CGRect rect = CGRectZero;
  rect.origin = CGPointMake(leadingPadding, topPadding);
  rect.size = size;
  self.leadingAccessoryViewFrame = rect;
}

- (void)assignFrameForTrailingAccessoryView:(UIView *)trailingAccessoryView {
  CGSize size = trailingAccessoryView.frame.size;
  CGFloat trailingPadding = 0;
  CGFloat topPadding = 0;
  if (!CGSizeEqualToSize(size, CGSizeZero)) {
    trailingPadding = kHorizontalMargin;
    topPadding = [self verticalMarginForAccessoryViewOfSize:size];
  }
  CGFloat originX = self.cellWidth - trailingPadding - size.width;
  CGRect rect = CGRectZero;
  rect.origin = CGPointMake(originX, topPadding);
  rect.size = size;
  self.trailingAccessoryViewFrame = rect;
}

- (void)assignFramesForTextContainer:(UIView *)textContainer
                          titleLabel:(UILabel *)titleLabel
                         detailLabel:(UILabel *)detailLabel {
  BOOL containsTitleText = titleLabel.text.length > 0;
  BOOL containsDetailText = detailLabel.text.length > 0;
  if (!containsTitleText && !containsDetailText) {
    self.titleLabelFrame = CGRectZero;
    self.detailLabelFrame = CGRectZero;
    self.textContainerFrame = CGRectZero;
    return;
  }

  BOOL hasLeadingImage = !CGRectEqualToRect(self.leadingAccessoryViewFrame, CGRectZero);
  BOOL hasTrailingImage = !CGRectEqualToRect(self.trailingAccessoryViewFrame, CGRectZero);
  CGFloat leadingAccessoryViewMaxX = (hasLeadingImage ? CGRectGetMaxX(self.leadingAccessoryViewFrame) : 0);
  CGFloat textContainerMinX = leadingAccessoryViewMaxX + kHorizontalMargin;
  CGFloat trailingAccessoryViewMinX =
  (hasTrailingImage ? CGRectGetMinX(self.trailingAccessoryViewFrame) : self.cellWidth);
  CGFloat textContainerMaxX = trailingAccessoryViewMinX - kHorizontalMargin;
  CGFloat textContainerMinY = kVerticalMarginMax;
  CGFloat textContainerWidth = textContainerMaxX - textContainerMinX;
  CGFloat textContainerHeight = 0;

  const CGSize fittingSize = CGSizeMake(textContainerWidth, CGFLOAT_MAX);

  CGSize titleSize = [titleLabel sizeThatFits:fittingSize];
  if (titleLabel.numberOfLines != 0 && titleSize.width > textContainerWidth) {
    titleSize.width = textContainerWidth;
  }
  const CGFloat titleLabelMinX = 0;
  CGFloat titleLabelMinY = 0;
  CGPoint titleOrigin = CGPointMake(titleLabelMinX, titleLabelMinY);
  CGRect titleFrame = CGRectZero;
  titleFrame.origin = titleOrigin;
  titleFrame.size = titleSize;
  self.titleLabelFrame = titleFrame;

  CGSize detailSize = [detailLabel sizeThatFits:fittingSize];
  if (detailLabel.numberOfLines != 0 && detailSize.width > textContainerWidth) {
    detailSize.width = textContainerWidth;
  }
  const CGFloat detailLabelMinX = 0;
  CGFloat detailLabelMinY = CGRectGetMaxY(titleFrame);
  if (titleLabel.text.length > 0 && detailLabel.text.length > 0) {
    detailLabelMinY += [self dynamicInterLabelVerticalPaddingWithTitleLabel:titleLabel
                                                                detailLabel:detailLabel];
  }
  CGPoint detailOrigin = CGPointMake(detailLabelMinX, detailLabelMinY);
  CGRect detailFrame = CGRectZero;
  detailFrame.origin = detailOrigin;
  detailFrame.size = detailSize;
  self.detailLabelFrame = detailFrame;

  textContainerHeight = CGRectGetMaxY(self.detailLabelFrame);

  CGRect textContainerFrame = CGRectZero;
  CGPoint textContainerOrigin = CGPointMake(textContainerMinX, textContainerMinY);
  CGSize textContainerSize = CGSizeMake(textContainerWidth, textContainerHeight);
  textContainerFrame.origin = textContainerOrigin;
  textContainerFrame.size = textContainerSize;
  self.textContainerFrame = textContainerFrame;

  BOOL hasOnlyTitleText = containsTitleText && !containsDetailText;
  BOOL shouldVerticallyCenterTitleText = hasOnlyTitleText && hasLeadingImage;
  if (shouldVerticallyCenterTitleText) {
    CGFloat leadingAccessoryViewCenterY = CGRectGetMidY(self.leadingAccessoryViewFrame);
    CGFloat textContainerCenterY = CGRectGetMidY(self.textContainerFrame);
    CGFloat difference = textContainerCenterY - leadingAccessoryViewCenterY;
    CGRect offsetTextContainerRect = CGRectOffset(self.textContainerFrame, 0, -difference);
    BOOL willExtendPastMargin = offsetTextContainerRect.origin.y < kVerticalMarginMax;
    if (!willExtendPastMargin) {
      self.textContainerFrame = offsetTextContainerRect;
    }
  }
}

- (CGFloat)calculateHeight {
  CGFloat maxHeight = 0;
  CGFloat leadingAccessoryViewRequiredVerticalSpace = 0;
  CGFloat trailingAccessoryViewRequiredVerticalSpace = 0;
  CGFloat textContainerRequiredVerticalSpace = 0;
  if (!CGRectEqualToRect(self.leadingAccessoryViewFrame, CGRectZero)) {
    leadingAccessoryViewRequiredVerticalSpace =
    CGRectGetMaxY(self.leadingAccessoryViewFrame) +
    [self verticalMarginForAccessoryViewOfSize:self.leadingAccessoryViewFrame.size];
    if (leadingAccessoryViewRequiredVerticalSpace > maxHeight) {
      maxHeight = leadingAccessoryViewRequiredVerticalSpace;
    }
  }
  if (!CGRectEqualToRect(self.trailingAccessoryViewFrame, CGRectZero)) {
    trailingAccessoryViewRequiredVerticalSpace =
    CGRectGetMaxY(self.trailingAccessoryViewFrame) +
    [self verticalMarginForAccessoryViewOfSize:self.trailingAccessoryViewFrame.size];
    if (trailingAccessoryViewRequiredVerticalSpace > maxHeight) {
      maxHeight = trailingAccessoryViewRequiredVerticalSpace;
    }
  }
  if (!CGRectEqualToRect(self.textContainerFrame, CGRectZero)) {
    textContainerRequiredVerticalSpace =
    CGRectGetMaxY(self.textContainerFrame) + kVerticalMarginMax;
    if (textContainerRequiredVerticalSpace > maxHeight) {
      maxHeight = textContainerRequiredVerticalSpace;
    }
  }
  CGFloat calculatedHeight = (CGFloat)ceil((double)maxHeight);
  return calculatedHeight;
}

- (CGSize)sizeForImage:(UIImage *)image {
  CGSize maxSize = CGSizeMake(kImageSideLengthMax, kImageSideLengthMax);
  if (!image || image.size.width <= 0 || image.size.height <= 0) {
    return CGSizeZero;
  } else if (image.size.width > maxSize.width || image.size.height > maxSize.height) {
    CGFloat aspectWidth = maxSize.width / image.size.width;
    CGFloat aspectHeight = maxSize.height / image.size.height;
    CGFloat aspectRatio = MIN(aspectWidth, aspectHeight);
    return CGSizeMake(image.size.width * aspectRatio, image.size.height * aspectRatio);
  } else {
    return image.size;
  }
}

- (CGFloat)verticalMarginForAccessoryViewOfSize:(CGSize)size {
  CGFloat leadingImageHeight = size.height;
  if (leadingImageHeight > 0 && leadingImageHeight <= kImageSideLengthMedium) {
    return kVerticalMarginMax;
  } else {
    return kVerticalMarginMin;
  }
}

- (CGFloat)dynamicInterLabelVerticalPaddingWithTitleLabel:(UILabel *)titleLabel
                                              detailLabel:(UILabel *)detailLabel {
  CGFloat titleLineHeight = titleLabel.font.lineHeight;
  CGFloat detailLineHeight = detailLabel.font.lineHeight;
  CGFloat lineHeightDifference = titleLineHeight - detailLineHeight;
  CGFloat interLabelPadding = (CGFloat)round((double)(detailLineHeight - lineHeightDifference));
  return 0;
}

@end
