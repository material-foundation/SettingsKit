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

#import "NICollectionViewModelSection+SectionObject.h"
#import <objc/runtime.h>

@implementation NICollectionViewModelSection (SectionObject)

- (id)sectionObject {
  return objc_getAssociatedObject(self, @selector(sectionObject));
}

- (void)setSectionObject:(id)sectionObject {
  objc_setAssociatedObject(self, @selector(sectionObject), sectionObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
