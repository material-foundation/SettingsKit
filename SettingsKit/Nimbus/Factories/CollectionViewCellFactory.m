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

#import "CollectionViewCellFactory.h"

@implementation CollectionViewCellFactory

+ (UICollectionReusableView *)
    supplementaryViewWithClass:(Class)collectionViewSupplementaryViewClass
                collectionView:(UICollectionView *)collectionView
                     indexPath:(NSIndexPath *)indexPath
                        object:(id)object {
  UICollectionReusableView *view = nil;

  NSString* identifier = NSStringFromClass(collectionViewSupplementaryViewClass);

  [collectionView registerClass:collectionViewSupplementaryViewClass
     forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
            withReuseIdentifier:identifier];

  view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];

  if ([view respondsToSelector:@selector(shouldUpdateSupplementaryViewWithObject:)]) {
    [(id<CollectionViewSupplementaryView>)view shouldUpdateSupplementaryViewWithObject:object];
  }

  return view;
}

+ (UICollectionReusableView *)supplementaryViewWithNib:(UINib *)collectionViewSupplementaryViewNib
                                        collectionView:(UICollectionView *)collectionView
                                             indexPath:(NSIndexPath *)indexPath
                                                object:(id)object {
  UICollectionReusableView *view = nil;

  NSString* identifier = NSStringFromClass([object class]);
  [collectionView registerNib:collectionViewSupplementaryViewNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];

  view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];

  if ([view respondsToSelector:@selector(shouldUpdateSupplementaryViewWithObject:)]) {
    [(id<CollectionViewSupplementaryView>)view shouldUpdateSupplementaryViewWithObject:object];
  }

  return view;
}

- (UICollectionReusableView *)collectionViewModel:(CollectionViewModel *)collectionViewModel collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {

  UICollectionReusableView* view = nil;

  Class collectionViewSupplementaryViewClass = [object collectionViewSupplementaryViewClass];

  if (nil != collectionViewSupplementaryViewClass) {
    view = [[self class] supplementaryViewWithClass:collectionViewSupplementaryViewClass collectionView:collectionView indexPath:indexPath object:object];
  } else if ([object respondsToSelector:@selector(collectionViewSupplementaryViewNib)]) {
    UINib* nib = [object collectionViewSupplementaryViewNib];
    view = [[self class] supplementaryViewWithNib:nib collectionView:collectionView indexPath:indexPath object:object];
  }

  // If this assertion fires then your app is about to crash. You need to either add an explicit
  // binding in a NICollectionViewCellFactory object or implement either
  // NICollectionViewCellObject or NICollectionViewNibCellObject on this object and return a cell
  // class.
  NIDASSERT(nil != view);

  return view;
}

+ (UICollectionReusableView *)collectionViewModel:(CollectionViewModel *)collectionViewModel
                                   collectionView:(UICollectionView *)collectionView
                viewForSupplementaryElementOfKind:(NSString *)kind
                                      atIndexPath:(NSIndexPath *)indexPath
                                       withObject:(id)object {

  UICollectionReusableView* view = nil;

  // Only CollectionViewCellObject-conformant objects may pass.
  if ([object respondsToSelector:@selector(collectionViewSupplementaryViewClass)]) {
    Class collectionViewSupplementaryViewClass = [object collectionViewSupplementaryViewClass];
    view = [self supplementaryViewWithClass:collectionViewSupplementaryViewClass collectionView:collectionView indexPath:indexPath object:object];
  } else if ([object respondsToSelector:@selector(collectionViewSupplementaryViewNib)]) {
    UINib* nib = [object collectionViewSupplementaryViewNib];
    view = [self supplementaryViewWithNib:nib collectionView:collectionView indexPath:indexPath object:object];
  }

  // If this assertion fires then your app is about to crash. You need to either add an explicit
  // binding in a NICollectionViewCellFactory object or implement either
  // NICollectionViewCellObject or NICollectionViewNibCellObject on this object and return a cell
  // class.
  NIDASSERT(nil != view);

  return view;
}


@end
