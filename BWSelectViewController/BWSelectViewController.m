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

#import "BWSelectViewController.h"

static NSString *CellIdentifier = @"Cell";

#define TITLE_KEY @"title"
#define ITEMS_KEY @"items"


// Thanks to Peter Steinberger
// https://gist.githubusercontent.com/steipete/6829002/raw/e1e285991b30b4881d2c9c83a7b52642ebca7b32/FixUISearchDisplayController.m
static UIView *PSPDFViewWithSuffix(UIView *view, NSString *classNameSuffix) {
    if (!view || classNameSuffix.length == 0) return nil;
    
    UIView *theView = nil;
    for (__unsafe_unretained UIView *subview in view.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:classNameSuffix]) {
            return subview;
        }else {
            if ((theView = PSPDFViewWithSuffix(subview, classNameSuffix))) break;
        }
    }
    return theView;
}


@interface BWSelectView : UIView

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL allowSearch;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWSelectViewController ()

@property (nonatomic, strong) NSArray *searchItems;

- (NSArray *)itemsFromSection:(NSInteger)section;

- (BOOL)isSectionSelected:(NSInteger)section;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWSelectViewController

@synthesize sections = _sections;
@synthesize selectedIndexPaths = _selectedIndexPaths;
@synthesize multiSelection = _multiSelection;
@synthesize cellClass = _cellClass;
@synthesize allowEmpty = _allowEmpty;
@synthesize selectBlock = _selectBlock;
@synthesize sectionOrders = _sectionOrders;
@synthesize dropDownSection = _dropDownSection;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithItems:(NSArray *)items
     multiselection:(BOOL)multiSelection
         allowEmpty:(BOOL)allowEmpty
      selectedItems:(NSArray *)selectedItems
        selectBlock:(BWSelectViewControllerDidSelectBlock)selectBlock {
    
    self = [self initWithSections:nil
                           orders:nil
                   multiselection:multiSelection
                       allowEmpty:allowEmpty
                    selectedItems:selectedItems
                      selectBlock:selectBlock];
    
    if (self) {
        [self setItems:items];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSections:(NSDictionary *)sections
                orders:(NSArray *)orders
        multiselection:(BOOL)multiSelection
            allowEmpty:(BOOL)allowEmpty
         selectedItems:(NSArray *)selectedItems
           selectBlock:(BWSelectViewControllerDidSelectBlock)selectBlock {
    
    self = [self init];
    if (self) {
        self.multiSelection = multiSelection;
        self.allowEmpty = allowEmpty;
        [self.selectedIndexPaths addObjectsFromArray:selectedItems];
        self.selectBlock = selectBlock;
        [self setSections:sections orders:orders];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.selectView = [[BWSelectView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.multiSelection = NO;
        self.cellClass = [UITableViewCell class];
        self.allowEmpty = NO;
        _selectedIndexPaths = [[NSMutableArray alloc] init];
        self.dropDownSection = NO;
        self.scrollToRowScrollPositionOnSelect = UITableViewScrollPositionNone;
        self.allowSearch = NO;
        self.textLabelNumberOfLines = 1;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setAllowSearch:(BOOL)allowSearch {
    _allowSearch = allowSearch;
    self.selectView.allowSearch = allowSearch;
    
    if (allowSearch) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.searchBar.delegate = self;
        self.tableView.tableHeaderView = self.searchBar;
        
        self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        self.searchController.searchResultsDataSource = self;
        self.searchController.searchResultsDelegate = self;
        self.searchController.delegate = self;
        
    } else {
        self.searchController = nil;
        [self.searchBar removeFromSuperview];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view addSubview:self.tableView];
    
//    if (self.allowSearch) {
//        [self.view addSubview:self.searchBar];
//    }
    
    [self loadItems];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadItems {
    [self.tableView reloadData];
    
    [self showEmptyView:![self hasAnyItems]];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
//- (UIView *)view {
//    return self.selectView;
//}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = self.tableFooterView;
    
    if (self.selectedIndexPaths.count > 0) {
        NSIndexPath *selectedIndexPath = [self.selectedIndexPaths lastObject];
        
        [self.tableView scrollToRowAtIndexPath:selectedIndexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setDidSelectBlock:(BWSelectViewControllerDidSelectBlock)didSelectBlock {
    self.selectBlock = didSelectBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSlectedIndexPaths:(NSArray *)indexPaths {
    [self.selectedIndexPaths removeAllObjects];
    [self.selectedIndexPaths addObjectsFromArray:indexPaths];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)sectionOrders {
    return (nil == _sectionOrders) ?
    [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] :
    _sectionOrders;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setItems:(NSArray *)items {
    self.sections = [NSDictionary dictionaryWithObject:items forKey:@""];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)items {
    return [[self.sections allValues] objectAtIndex:0];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSections:(NSDictionary *)sections orders:(NSArray *)orders {
    self.sections = sections;
    self.sectionOrders = orders;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)searchItems {
    if (nil == _searchItems) {
        NSString *column = self.searchPropertyName ? self.searchPropertyName : @"SELF";
        NSString *stringPredicate = [NSString stringWithFormat:@"%@ CONTAINS[cd] \"%@\"", column, self.searchBar.text];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:stringPredicate];
        _searchItems = [self.items filteredArrayUsingPredicate:predicate];
    }
    
    return _searchItems;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectWithIndexPath:(NSIndexPath *)indexPath {
    if (self.searchController.active) {
        if ([self.searchItems count] == 0) {
            return nil;
        }
        
        return [self.searchItems objectAtIndex:indexPath.row];
    }
    
    return [[self itemsFromSection:indexPath.section] objectAtIndex:indexPath.row];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)selectedObjects {
    NSMutableArray *objects = [NSMutableArray array];
    
    [self.selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [objects addObject:[self objectWithIndexPath:indexPath]];
    }];
    
    return objects;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSelectedIndexPathsWithObject:(id)object {
    if (object) {
        [self setSelectedIndexPathsWithObjects:[NSArray arrayWithObject:object]];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSelectedIndexPathsWithObjects:(NSArray *)objects {
    if (objects.count == 0) {
        return;
    }
    
    [objects enumerateObjectsUsingBlock:^(id objectWeSearch, NSUInteger idx, BOOL *stopObjectFinding) {
        [self.sections enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *sectionItems, BOOL *stopSectionEnumerating) {
            [sectionItems enumerateObjectsUsingBlock:^(id possibleObject, NSUInteger itemsIdx, BOOL *stopItemsEnumerating) {
                if (objectWeSearch == possibleObject || [objectWeSearch isEqual:possibleObject]) {
                    NSIndexPath *objectIndexPath = [NSIndexPath indexPathForRow:itemsIdx
                                                                      inSection:[self.sectionOrders indexOfObject:key]];
                    
                    [self.selectedIndexPaths addObject:objectIndexPath];
                    
                    *stopItemsEnumerating = YES;
                    *stopSectionEnumerating = YES;
                }
            }];
        }];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showEmptyView:(BOOL)show {
    BOOL isAddedToTableView = self.emptyView.superview;
    
    if ((show && isAddedToTableView) || (!show && !isAddedToTableView)) {
        return;
    }
    
    if (show) {
        [self.tableView addSubview:self.emptyView];
        CGRect frame = self.emptyView.frame;
        frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2;
        frame.origin.y = (self.view.frame.size.height - frame.size.height) / 2;
        self.emptyView.frame = frame;
        
    } else {
        [self.emptyView removeFromSuperview];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setEmptyView:(UIView *)emptyView {
    if (emptyView != _emptyView) {
        _emptyView = emptyView;
        [self loadItems];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchDisplayController.active) {
        return 1;
    }
    
    return [self.sections count];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchDisplayController.active) {
        return [self.searchItems count];
    }
    
    return [[self itemsFromSection:section] count];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionOrders objectAtIndex:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = self.textLabelNumberOfLines;
    }
    
    id object = [self objectWithIndexPath:indexPath];
    
    if (nil != self.textForObjectBlock) {
        object = self.textForObjectBlock(object);
        
    } else if (nil != self.attributedTextForObjectBlock) {
        object = self.attributedTextForObjectBlock(object);
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        cell.textLabel.text = object;
        
    } else if ([object isKindOfClass:[NSAttributedString class]]) {
        cell.textLabel.attributedText = object;
    }
    
    cell.accessoryType = [self.selectedIndexPaths containsObject:indexPath] ?
    UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma Table view delegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *indexPathsToReload = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.searchController.active) {
        id object = [self objectWithIndexPath:indexPath];
        NSUInteger objectIndex = [self.items indexOfObject:object];
        indexPath = [NSIndexPath indexPathForRow:objectIndex inSection:0];
        [self.searchController setActive:NO animated:YES];
    }
    
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        if (YES == self.allowEmpty || (self.selectedIndexPaths.count > 1 && NO == self.allowEmpty) ) {
            [self.selectedIndexPaths removeObject:indexPath];
        }
        
    } else {
        if (NO == self.multiSelection) {
            [indexPathsToReload addObjectsFromArray:self.selectedIndexPaths];
            [self.selectedIndexPaths removeAllObjects];
        }
        
        [self.selectedIndexPaths addObject:indexPath];
    }
    
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:self.scrollToRowScrollPositionOnSelect
                                  animated:(UITableViewScrollPositionNone != self.scrollToRowScrollPositionOnSelect) ? YES : NO];
    
    //    [self.tableView reloadRowsAtIndexPaths:indexPathsToReload
    //                          withRowAnimation:UITableViewRowAnimationNone];
    
    if (nil != self.selectBlock)
        self.selectBlock(self.selectedIndexPaths, self);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UISearchBarDelegate


// Thanks to Peter Steinberger
// https://gist.githubusercontent.com/steipete/6829002/raw/e1e285991b30b4881d2c9c83a7b52642ebca7b32/FixUISearchDisplayController.m
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)correctSearchDisplayFrames {
    // Update search bar frame.
    CGRect superviewFrame = self.searchDisplayController.searchBar.superview.frame;
    superviewFrame.origin.y = 0.f;
    self.searchDisplayController.searchBar.superview.frame = superviewFrame;
    
    // Strech dimming view.
    UIView *dimmingView = PSPDFViewWithSuffix(self.view, @"DimmingView");
    if (dimmingView) {
        CGRect dimmingFrame = dimmingView.superview.frame;
        dimmingFrame.origin.y = self.searchDisplayController.searchBar.frame.size.height;
        dimmingFrame.size.height = self.view.frame.size.height - dimmingFrame.origin.y;
        dimmingView.superview.frame = dimmingFrame;
    }
}


// Thanks to Peter Steinberger
// https://gist.githubusercontent.com/steipete/6829002/raw/e1e285991b30b4881d2c9c83a7b52642ebca7b32/FixUISearchDisplayController.m
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setAllViewsExceptSearchHidden:(BOOL)hidden animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? 0.825f : 0.f animations:^{
        for (UIView *view in self.tableView.subviews) {
            if (view != self.searchDisplayController.searchResultsTableView &&
                view != self.searchDisplayController.searchBar) {
                view.alpha = hidden ? 0.f : 1.f;
            }
        }
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    _searchItems = nil;
    return YES;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasAnyItems {
    if (self.items) {
        return [self.items count] > 0;
    }
    
    __block BOOL hasAnyItems = NO;
    
    if ([self.sections count] > 0) {
        [self.sections enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *items, BOOL *stop) {
            if ([items count] > 0) {
                hasAnyItems = YES;
                *stop = YES;
            }
        }];
    }
    
    return hasAnyItems;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isSectionSelected:(NSInteger)section {
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        if (indexPath.section == section) {
            return YES;
        }
    }
    
    return NO;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)itemsFromSection:(NSInteger)section {
    NSString *sectionKey = [self.sectionOrders objectAtIndex:section];
    NSArray *items = [self.sections objectForKey:sectionKey];
    
    if (self.dropDownSection && NO == [self isSectionSelected:section]) {
        items = [NSArray arrayWithObject:[items objectAtIndex:0]];
    }
    
    return items;
}


@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWSelectView

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] init];
        self.searchBar = [[UISearchBar alloc] init];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
    
    if (self.allowSearch) {
        
        self.searchBar.frame = CGRectMake(0, 0, self.frame.size.width, 40);
        
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame.origin.y = self.searchBar.frame.size.height;
        tableViewFrame.size.height = tableViewFrame.size.height - tableViewFrame.origin.y;
        self.tableView.frame = tableViewFrame;
        
    }
}

@end