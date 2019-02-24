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

#import "SettingsKitHeaderView.h"
#import "MaterialTypography.h"

@implementation SettingsKitHeaderModel

+ (instancetype)settingsKitSupplementaryViewWithData:(NSDictionary *)data {
  SettingsKitHeaderModel *instance = [[SettingsKitHeaderModel alloc] init];
  if ([data objectForKey:@"title"]) {
    instance.title = data[@"title"];
  }
  return instance;
}

- (Class)collectionViewSupplementaryViewClass {
  return [SettingsKitHeaderView class];
}

@end

@implementation SettingsKitHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.font = [MDCTypography buttonFont];
    [self addSubview:self.titleLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.titleLabel sizeToFit];
  self.titleLabel.center = [self convertPoint:self.center fromView:self.superview];
  CGRect titleFrame = self.titleLabel.frame;
  titleFrame.origin.x = 16.f;
  self.titleLabel.frame = titleFrame;
}

- (BOOL)shouldUpdateSupplementaryViewWithObject:(SettingsKitHeaderModel *)object {
  self.titleLabel.text = object.title;
  return YES;
}

@end
