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

#import "ViewController.h"
#import <Nimbus/NimbusCollections.h>
#import "SettingsKitHeaderView.h"
#import "SettingsKitCell.h"
#import "SettingsKitCellWithTrailingSwitch.h"

static CGFloat const kArbitraryCellHeight = 50;

@interface ViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NICollectionViewModel* model;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _model = [[CollectionViewModel alloc] initWithSectionedArray:[self populateSettingsData]
                                                      delegate:(id)[CollectionViewCellFactory class]];
  [self createCollectionView];
  [self populateSettingsData];
}

- (void)createCollectionView {
  self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
  self.collectionViewLayout.minimumInteritemSpacing = 1;
  self.collectionViewLayout.minimumLineSpacing = 0;
  self.collectionViewLayout.estimatedItemSize =
      CGSizeMake(self.view.bounds.size.width, kArbitraryCellHeight);
  self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                           collectionViewLayout:self.collectionViewLayout];
  self.collectionView.dataSource = self.model;
  self.collectionView.backgroundColor = UIColor.whiteColor;
  self.collectionView.delegate = self;
  [self.view addSubview:self.collectionView];
}

- (NSArray *)populateSettingsData {
  NSMutableArray *settingsData = [[NSMutableArray alloc] init];
  [settingsData addObject:[self configureHeaderModelWithTitle:@"Settings"]];
  [settingsData addObject:[self configureCellModelWithTitle:@"Title 1" andDetail:@"This is a detail"]];
  [settingsData addObject:[self configureCellModelWithTitle:@"Title 2" andDetail:@"This is a detail"]];
  [settingsData addObject:[self configureCellModelWithTitle:@"Sharing more information" andDetail:@"I have a lot of information to convey here that will have to make the cell expand."]];
  [settingsData addObject:[self configureSwitchCellModelWithTitle:@"Title 4" andDetail:@"This is a detail"]];
  [settingsData addObject:[self configureCellModelWithTitle:@"Title 5" andDetail:@"This is a detail"]];
  [settingsData addObject:[self configureHeaderModelWithTitle:@"More Settings"]];
  [settingsData addObject:[self configureCellModelWithTitle:@"Help" andDetail:@"This is a detail"]];
  [settingsData addObject:[self configureCellModelWithTitle:@"Configure" andDetail:@"This is a detail"]];
  [settingsData addObject:[self configureSwitchCellModelWithTitle:@"Share" andDetail:@"This is a detail"]];
  [settingsData addObject:[self configureCellModelWithTitle:@"Edit" andDetail:@"This is a detail"]];
  [settingsData addObject:[self configureCellModelWithTitle:@"Explore" andDetail:@"This is a detail"]];
  [settingsData addObject:[self configureCellModelWithTitle:@"Append" andDetail:@"This is a detail"]];
  [settingsData addObject:[self configureCellModelWithTitle:@"Logout" andDetail:@"This is a detail"]];
  [settingsData addObject:[self configureSwitchCellModelWithTitle:@"Delete" andDetail:@"This is a detail"]];
  [settingsData addObject:[self configureCellModelWithTitle:@"Cancel" andDetail:@"This is a detail"]];
  return settingsData;
}

- (SettingsKitHeaderModel *)configureHeaderModelWithTitle:(NSString *)title {
  SettingsKitHeaderModel *model = [[SettingsKitHeaderModel alloc] init];
  model.title = title;
  return model;
}

- (SettingsKitCellModel *)configureCellModelWithTitle:(NSString *)title andDetail:(NSString *)detail {
  SettingsKitCellModel *model = [[SettingsKitCellModel alloc] init];
  model.title = title;
  model.detail = detail;
  return model;
}

- (SettingsKitCellModel *)configureSwitchCellModelWithTitle:(NSString *)title andDetail:(NSString *)detail {
  SettingsKitCellModelWithTrailingSwitch *model = [[SettingsKitCellModelWithTrailingSwitch alloc] init];
  model.title = title;
  model.detail = detail;
  return model;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self positionCollectionView];
}

- (void)positionCollectionView {
  CGFloat originX = self.view.bounds.origin.x;
  CGFloat originY = self.view.bounds.origin.y;
  CGFloat width = self.view.bounds.size.width;
  CGFloat height = self.view.bounds.size.height;
  if (@available(iOS 11.0, *)) {
    originX += self.view.safeAreaInsets.left;
    originY += self.view.safeAreaInsets.top;
    width -= (self.view.safeAreaInsets.left + self.view.safeAreaInsets.right);
    height -= (self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom);
  }
  CGRect frame = CGRectMake(originX, originY, width, height);
  self.collectionView.frame = frame;
  self.collectionViewLayout.estimatedItemSize =
      CGSizeMake(self.collectionView.bounds.size.width, kArbitraryCellHeight);
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return CGSizeMake(0, 0);
  } else {
    return CGSizeMake(collectionView.bounds.size.width, 50);
  }
}


@end
