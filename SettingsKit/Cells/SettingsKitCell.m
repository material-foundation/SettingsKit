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

#import "SettingsKitCell.h"
#import "MaterialTypography.h"

@implementation SettingsKitCellModel

+ (instancetype)settingsKitCellWithData:(NSDictionary *)data {
  SettingsKitCellModel *instance = [[SettingsKitCellModel alloc] init];
  if ([data objectForKey:@"title"]) {
    instance.title = data[@"title"];
  }
  if ([data objectForKey:@"detail"]) {
    instance.detail = data[@"detail"];
  }
  if ([data objectForKey:@"trailingImage"]) {
    instance.trailingImage = data[@"trailingImage"];
  }
  return instance;
}

- (Class)collectionViewCellClass {
  return [SettingsKitCell class];
}

@end

@interface SettingsKitCell ()

@property (nonatomic, strong) UIView* lineSeperator;
@end

@implementation SettingsKitCell

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.titleLabel.font = [MDCTypography body2Font];
    self.titleLabel.textColor = [UIColor darkTextColor];
    self.detailLabel.font = [MDCTypography body1Font];
    self.detailLabel.textColor = [UIColor lightGrayColor];
    self.lineSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
    self.lineSeperator.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    self.lineSeperator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.lineSeperator];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect seperatorFrame = self.lineSeperator.frame;
  seperatorFrame.origin = CGPointMake(0, self.bounds.size.height - 1);
  self.lineSeperator.frame = seperatorFrame;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.titleLabel.font = [MDCTypography body2Font];
  self.titleLabel.textColor = [UIColor darkTextColor];
  self.detailLabel.font = [MDCTypography body1Font];
  self.detailLabel.textColor = [UIColor lightGrayColor];
  [self setNeedsLayout];
}

- (BOOL)shouldUpdateCellWithObject:(SettingsKitCellModel *)object {
  self.titleLabel.text = object.title;
  self.detailLabel.text = object.detail;
  self.trailingAccessoryView = [[UIImageView alloc] initWithImage:object.trailingImage];
  return YES;
}

@end
