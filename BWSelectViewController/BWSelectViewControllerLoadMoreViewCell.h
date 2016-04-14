//
//  BWSelectViewControllerLoadMoreViewCell.h
//  BWSelectControllerExample
//
//  Created by cesar4 on 14/04/16.
//
//

#import <UIKit/UIKit.h>

@class BWSelectViewController;

typedef void(^BWSelectViewControllerShouldLoadMore)(BWSelectViewController *controller, NSUInteger page);

@interface BWSelectViewControllerLoadMoreViewCell : UITableViewCell {
    UIActivityIndicatorView *_activityView;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) BWSelectViewControllerShouldLoadMore shouldLoadMoreBlock;

+ (CGFloat)height;

@end
