//
//  XYDropMenuViewBgView.m
//  XYDropMenuView
//
//  Created by xiaoyuan on 2020/10/21.
//  Copyright © 2020 xiaoyuan. All rights reserved.
//

#import "XYDropMenuViewBgView.h"

@implementation XYDropMenuViewBgView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *coverView = [UIView new];
        coverView.userInteractionEnabled = NO;
        coverView.translatesAutoresizingMaskIntoConstraints = NO;
        coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:coverView];
        NSLayoutConstraint *coverViewTop = [coverView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0];
        coverViewTop.active = true;
        self.coverViewTop = coverViewTop;
        
        [coverView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0].active = YES;
        [coverView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0].active = YES;
        [coverView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0].active = YES;
        
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [_contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        NSLayoutConstraint *top = [_contentView.topAnchor constraintEqualToAnchor:self.topAnchor];
        top.active = YES;
        self.contentViewTop = top;
        NSLayoutConstraint *contentHeight = [self.contentView.heightAnchor constraintEqualToConstant:0.0];
        contentHeight.active = YES;
        self.contentViewHeight = contentHeight;
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *touchView = [super hitTest:point withEvent:event];
    return touchView;
}

@end

