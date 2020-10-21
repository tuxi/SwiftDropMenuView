//
//  XYDropMenuViewBgView.h
//  XYDropMenuView
//
//  Created by xiaoyuan on 2020/10/21.
//  Copyright © 2020 xiaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYDropMenuViewBgView : UIControl

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UIControl *coverView;
@property (nonatomic, weak, nullable) NSLayoutConstraint *contentViewTop;
@property (nonatomic, weak, nullable) NSLayoutConstraint *contentViewHeight;
@property (nonatomic, weak, nullable) NSLayoutConstraint *coverViewTop;

@end

NS_ASSUME_NONNULL_END
