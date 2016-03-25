//
// Created by Bruno Wernimont on 2012
// Copyright 2012 BWLongTextViewController
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <UIKit/UIKit.h>

@class BWSelectViewController;
@class BWSelectView;

typedef void(^BWSelectViewControllerDidSelectBlock)(NSArray *selectedIndexPaths, BWSelectViewController *controller);

typedef NSString *(^BWSelectViewControllerTextForObjectBlock)(id object);
typedef NSAttributedString *(^BWSelectViewControllerAttributedTextForObjectBlock)(id object);
typedef void(^BWSelectViewControllerWillDisplayCellBlock)(BWSelectViewController *vc, UITableViewCell *cell, id object);
typedef BOOL(^BWSelectViewControllerSelectedObject)(id object);
typedef void(^BWSelectViewControllerObjectSelectionDidChange)(BWSelectViewController *vc, id object, BOOL selected);

@interface BWSelectViewController : UITableViewController <
UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSDictionary *sections;
@property (nonatomic, strong) BWSelectViewControllerDidSelectBlock selectBlock;
@property (nonatomic, readonly) NSMutableArray *selectedIndexPaths;
@property (nonatomic, assign) BOOL multiSelection;
@property (nonatomic, assign) Class cellClass;
@property (nonatomic, assign) BOOL allowEmpty;
@property (nonatomic, strong) NSArray *sectionOrders;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL dropDownSection;
@property (nonatomic, assign) NSUInteger textLabelNumberOfLines;
@property (nonatomic, copy) BWSelectViewControllerTextForObjectBlock textForObjectBlock;
@property (nonatomic, copy) BWSelectViewControllerAttributedTextForObjectBlock attributedTextForObjectBlock;
@property (nonatomic, assign) UITableViewScrollPosition scrollToRowScrollPositionOnSelect;
@property (nonatomic, assign) BOOL allowSearch;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSString *searchPropertyName;
@property (nonatomic, copy) BWSelectViewControllerSelectedObject selectedObjectBlock;
@property (nonatomic, copy) BWSelectViewControllerObjectSelectionDidChange objectSelectionDidChange;
@property (nonatomic, strong) BWSelectView *selectView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, assign, getter=shouldScrollToLastSelectedRowAtReload) BOOL scrollToLastSelectedRowAtReload;
@property (nonatomic, copy) BWSelectViewControllerWillDisplayCellBlock willDisplayCellBlock;

- (id)initWithItems:(NSArray *)items
     multiselection:(BOOL)multiSelection
         allowEmpty:(BOOL)allowEmpty
      selectedItems:(NSArray *)selectedItems
        selectBlock:(BWSelectViewControllerDidSelectBlock)selectBlock;

- (id)initWithSections:(NSDictionary *)sections
                orders:(NSArray *)orders
        multiselection:(BOOL)multiSelection
            allowEmpty:(BOOL)allowEmpty
         selectedItems:(NSArray *)selectedItems
           selectBlock:(BWSelectViewControllerDidSelectBlock)selectBlock;

- (void)setDidSelectBlock:(BWSelectViewControllerDidSelectBlock)didSelectBlock;

- (void)setSelectedObjectBlock:(BWSelectViewControllerSelectedObject)selectedObjectBlock;

- (void)setSlectedIndexPaths:(NSArray *)selectedIndexPaths;

- (void)setSections:(NSDictionary *)sections orders:(NSArray *)orders;

- (void)setTextForObjectBlock:(BWSelectViewControllerTextForObjectBlock)textForObjectBlock;

- (void)setWillDisplayCellBlock:(BWSelectViewControllerWillDisplayCellBlock)willDisplayCellBlock;

- (id)objectWithIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)selectedObjects;

- (void)setSelectedIndexPathsWithObject:(id)object;

- (void)setSelectedIndexPathsWithObjects:(NSArray *)objects;

- (void)setObjectSelectionDidChange:(BWSelectViewControllerObjectSelectionDidChange)objectSelectionDidChange;

@end
