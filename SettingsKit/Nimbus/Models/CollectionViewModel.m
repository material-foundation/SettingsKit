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

#import "CollectionViewModel.h"
#import "CollectionViewCellFactory.h"

@implementation CollectionViewModel

@dynamic delegate;

- (void)_compileDataWithSectionedArray:(NSArray *)sectionedArray {
  [self _resetCompiledData];

  NSMutableArray* sections = [NSMutableArray array];

  id<CollectionViewSupplementaryViewObjectProtocol> currentSectionHeaderObject = nil;
  NSString* currentSectionFooterTitle = nil;
  NSMutableArray* currentSectionRows = nil;

  for (id object in sectionedArray) {
    BOOL isSection = [object conformsToProtocol:@protocol(CollectionViewSupplementaryViewObjectProtocol)];

    id<CollectionViewSupplementaryViewObjectProtocol> nextSectionHeaderObject = nil;

    if (isSection) {
      nextSectionHeaderObject = object;
    } else {
      if (nil == currentSectionRows) {
        currentSectionRows = [[NSMutableArray alloc] init];
      }
      [currentSectionRows addObject:object];
    }

    // A section footer or title has been encountered,
    if (nil != nextSectionHeaderObject || nil != currentSectionFooterTitle) {
      if (nil != currentSectionHeaderObject
          || nil != currentSectionFooterTitle
          || nil != currentSectionRows) {
        NICollectionViewModelSection* section = [NICollectionViewModelSection section];
        section.sectionObject = currentSectionHeaderObject;
        section.footerTitle = currentSectionFooterTitle;
        section.rows = currentSectionRows;
        [sections addObject:section];
      }

      currentSectionRows = nil;
      currentSectionHeaderObject = nextSectionHeaderObject;
      currentSectionFooterTitle = nil;
    }
  }

  // Commit any unfinished sections.
  if ([currentSectionRows count] > 0 || nil != currentSectionHeaderObject) {
    NICollectionViewModelSection* section = [NICollectionViewModelSection section];
    section.sectionObject = currentSectionHeaderObject;
    section.footerTitle = currentSectionFooterTitle;
    section.rows = currentSectionRows;
    [sections addObject:section];
  }
  currentSectionRows = nil;

  // Update the compiled information for this data source.
  [self _setSectionsWithArray:sections];
}

- (void)_setSectionsWithArray:(NSArray *)sectionsArray {
  self.sections = sectionsArray;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  id object = [self sectionObjectAtIndexPath:indexPath];
  if ([self.delegate respondsToSelector:
       @selector(collectionViewModel:collectionView:viewForSupplementaryElementOfKind:atIndexPath:withObject:)]) {
    return [self.delegate collectionViewModel:self
                               collectionView:collectionView
            viewForSupplementaryElementOfKind:kind
                                  atIndexPath:indexPath
                                   withObject:object];
  }
  return nil;
}

- (id)sectionObjectAtIndexPath:(NSIndexPath *)indexPath {
  if (nil == indexPath) {
    return nil;
  }
  NSInteger section = [indexPath section];
  NSInteger row = [indexPath row];
  if ((NSUInteger)row != 0) {
    // this isn't a section indexPath.
    return nil;
  }

  id object = nil;

  if ((NSUInteger)section < self.sections.count) {
    id collectionViewModelSection = [self.sections objectAtIndex:section];
    if ([collectionViewModelSection isKindOfClass:[NICollectionViewModelSection class]]) {
      object = ((NICollectionViewModelSection *)collectionViewModelSection).sectionObject;
    }
  }

  return object;
}

@end
