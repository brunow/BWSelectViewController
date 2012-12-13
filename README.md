## BWSelectViewController

Controller that show a list of items that can be selectable.

![Screenshot](https://github.com/brunow/BWSelectViewController/raw/master/screenshot.png)

## Installation

**Copy** **BWSelectViewController** dir into your project.

Or with **Cocoapods**

	pod 'BWSelectViewController', :git => "https://github.com/brunow/BWSelectViewController.git", :tag => "0.1.1"

## How to use it

    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    vc.multiSelection = NO;
    vc.allowEmpty = YES;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];

## ARC

BWSelectViewController is ARC only.