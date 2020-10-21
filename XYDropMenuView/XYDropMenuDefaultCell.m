//
//  XYDropMenuDefaultCell.m
//  XYDropMenuView
//
//  Created by xiaoyuan on 2020/10/21.
//  Copyright © 2020 xiaoyuan. All rights reserved.
//

#import "XYDropMenuDefaultCell.h"

@implementation XYDropMenuDefaultCell

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]|" options:kNilOptions metrics:nil views:@{@"titleLabel": self.titleLabel}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]|" options:kNilOptions metrics:nil views:@{@"titleLabel": self.titleLabel}]];
        
        self.contentView.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor colorWithRed:111/255.0 green:111/255.0 blue:112/255.0 alpha:1.0];
        
        self.contentView.clipsToBounds = true;
        self.contentView.layer.cornerRadius = 5.0;
        self.contentView.layer.borderWidth = 1.0;
    }
    return self;
}

@end
