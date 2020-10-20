//
//  XYDropMenuView.h
//  XYDropMenuView
//
//  Created by xiaoyuan on 2020/10/20.
//  Copyright © 2020 xiaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XYDropMenuView;

@protocol XYDropMenuViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInDropMenuView:(XYDropMenuView *)menu;
// 每行展示的数量
- (NSInteger)numberOfOneLineInDropMenuView:(XYDropMenuView *)menu;
- (CGFloat)heightForLineInDropMenuView:(XYDropMenuView *)menu;
// 获取选中的index
- (NSInteger)indexOfSelectedItemInDropMenuView:(XYDropMenuView *)menu;
- (NSString *)dropMenuView:(XYDropMenuView *)menu titleForOptionAtIndex:(NSInteger)index;
@end


@protocol XYDropMenuViewDelegate <NSObject>
@optional
- (void)dropMenuViewWillShow:(XYDropMenuView *)menu;    // 当下拉菜单将要显示时调用
- (void)dropMenuViewDidShow:(XYDropMenuView *)menu;     // 当下拉菜单已经显示时调用
- (void)dropMenuViewWillHidden:(XYDropMenuView *)menu;  // 当下拉菜单将要收起时调用
- (void)dropMenuViewDidHidden:(XYDropMenuView *)menu;   // 当下拉菜单已经收起时调用

 // 当选择某个选项时调用
- (void)dropMenuView:(XYDropMenuView *)menu didSelectItemAtIndex:(NSInteger)index optionTitle:(NSString *)title;
@end




@interface XYDropMenuView : UIControl

@property (nonatomic, weak) id <XYDropMenuViewDataSource> dataSource;
@property (nonatomic, weak) id <XYDropMenuViewDelegate> delegate;

@property(nonatomic,assign) CGFloat animateTime;   // 下拉动画时间 default: 0.25


- (void)reloadData;

// 显示下拉菜单
- (void)show;
// 隐藏下拉菜单
- (void)hide;

@end

NS_ASSUME_NONNULL_END
