//
//  BWSelectViewControllerLoadMoreViewCell.m
//  BWSelectControllerExample
//
//  Created by cesar4 on 14/04/16.
//
//

#import "BWSelectViewControllerLoadMoreViewCell.h"


////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWSelectViewControllerLoadMoreViewCell

////////////////////////////////////////////////////////////////////////////////////////////////////
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:self.activityView];
        
        [self.activityView startAnimating];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.activityView startAnimating];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.activityView sizeToFit];
    self.activityView.center = self.contentView.center;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)height {
    return 40;
}

@end
