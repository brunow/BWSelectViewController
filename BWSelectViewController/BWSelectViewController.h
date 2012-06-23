//
//  BWSelectViewController.h
//  BWSelectControllerExample
//
//  Created by Bruno Wernimont on 16/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWSelectViewController;

typedef void(^BWSelectViewControllerDidSelectBlock)(NSArray *selectedIndexPaths, BWSelectViewController *controller);

@interface BWSelectViewController : UITableViewController

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) BWSelectViewControllerDidSelectBlock selectBlock;
@property (nonatomic, readonly) NSMutableArray *selectedIndexPaths;
@property (nonatomic, assign) BOOL multiSelection;
@property (nonatomic, assign) Class cellClass;
@property (nonatomic, assign) BOOL allowEmpty;

- (id)initWithItems:(NSArray *)items
     multiselection:(BOOL)multiSelection
         allowEmpty:(BOOL)allowEmpty
      selectedItems:(NSArray *)selectedItems
        selectBlock:(BWSelectViewControllerDidSelectBlock)selectBlock;

- (void)setDidSelectBlock:(BWSelectViewControllerDidSelectBlock)didSelectBlock;

- (void)setSlectedIndexPaths:(NSArray *)selectedIndexPaths;

@end
