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
- (CGFloat)heightForLineInDropMenuView:(XYDropMenuView *)menu;
- (NSString *)dropMenuView:(XYDropMenuView *)menu titleForOptionAtIndex:(NSInteger)index;

@optional
// 每行展示的数量
- (NSInteger)numberOfOneLineInDropMenuView:(XYDropMenuView *)menu;
// 获取选中的index
- (NSInteger)indexOfSelectedItemInDropMenuView:(XYDropMenuView *)menu;
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




@interface XYDropMenuView : UIButton

@property (nonatomic, weak) id <XYDropMenuViewDataSource> dataSource;
@property (nonatomic, weak) id <XYDropMenuViewDelegate> delegate;


- (void)reloadData;

// 显示下拉菜单
- (void)show;
// 隐藏下拉菜单
- (void)hide;

@end

NS_ASSUME_NONNULL_END
