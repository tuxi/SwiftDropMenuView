//
//  XYDropMenuView.m
//  XYDropMenuView
//
//  Created by xiaoyuan on 2020/10/20.
//  Copyright © 2020 xiaoyuan. All rights reserved.
//

#import "XYDropMenuView.h"

@interface XYDropMenuDefaultCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@interface XYDropMenuViewBgView : UIControl

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UIControl *coverView;
@property (nonatomic, weak, nullable) NSLayoutConstraint *contentViewTop;
@property (nonatomic, weak, nullable) NSLayoutConstraint *contentViewHeight;
@property (nonatomic, weak, nullable) NSLayoutConstraint *coverViewTop;
// 触摸了不在contentView 区域的回调
@property (nonatomic, copy) void (^ touchNotInContentBlock)(CGPoint point);

@end

@interface XYDropMenuView() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;  // 下拉列表


@property (nonatomic, strong) XYDropMenuViewBgView *bgView;

// 下拉动画时间 default: 0.25
@property (nonatomic,assign) CGFloat animateTime;
@property (nonatomic, weak) NSLayoutConstraint *collectionViewTop;

@end

@implementation XYDropMenuView {
    BOOL _isOpened;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}


#pragma mark - Init
- (void)commonInit {
    self.layer.masksToBounds = YES;
    
    // 主按钮 显示在界面上的点击按钮
    [self addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _bgView = [[XYDropMenuViewBgView alloc] init];
    [_bgView addTarget:self action:@selector(tapOnBgView) forControlEvents:UIControlEventTouchUpInside];
    _bgView.hidden = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate       = self;
    _collectionView.dataSource     = self;
    _collectionView.scrollEnabled  = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.bgView.contentView addSubview:_collectionView];
    
    [_collectionView registerClass:[XYDropMenuDefaultCell class] forCellWithReuseIdentifier:@"XYDropMenuDefaultCell"];
    
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [_collectionView.leadingAnchor constraintEqualToAnchor:self.bgView.contentView.leadingAnchor].active = YES;
    [_collectionView.trailingAnchor constraintEqualToAnchor:self.bgView.contentView.trailingAnchor].active = YES;
    NSLayoutConstraint *collectionViewTop = [_collectionView.topAnchor constraintEqualToAnchor:self.bgView.contentView.topAnchor];
    collectionViewTop.active = YES;
    self.collectionViewTop = collectionViewTop;
    [_collectionView.heightAnchor constraintEqualToAnchor:self.bgView.contentView.heightAnchor].active = YES;
    
    _animateTime = 0.25f;
    _isOpened = NO;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    if (_isOpened) {
//        return;
//    }
//
//    CGPoint newPosition = [self getScreenPosition];
//    self.bgView.contentViewTop.constant = newPosition.y + self.frame.size.height;
//}



#pragma mark - Action Methods
- (void)reloadData {
    [self.collectionView reloadData];
}
- (void)clickMainBtn:(UIButton *)button{
    if (!_isOpened) {
        [self show];
    }
    else {
        [self hide];
    }
}

- (NSInteger)totalLines {
    NSUInteger count = [self.dataSource numberOfItemsInDropMenuView:self];
    
    NSUInteger numberOfOneLine = [self numberOfOneLine];
    // 计算行数
    NSInteger totalLines = ceil(count / (CGFloat)numberOfOneLine);
    return totalLines;
}

- (void)show {
    if (_isOpened) {
        return;
    }
    _isOpened = YES;
    
    __weak typeof(self) weakSelf = self;
    self.bgView.touchNotInContentBlock = ^(CGPoint point) {
        [weakSelf hide];
    };
    
    CGPoint newPosition = [self getScreenPosition];
    self.bgView.contentViewTop.constant = newPosition.y + self.frame.size.height;
    
    self.bgView.contentView.layer.borderColor  = self.layer.borderColor;
    self.bgView.contentView.layer.borderWidth  = self.layer.borderWidth;
    self.bgView.contentView.layer.cornerRadius = self.layer.cornerRadius;
    self.bgView.coverViewTop.constant = newPosition.y + self.frame.size.height;
    
    UIWindow *window = [self getCurrentKeyWindow];
    [window addSubview:_bgView];
    _bgView.frame = window.bounds;
    
    // call delegate
    if ([self.delegate respondsToSelector:@selector(dropMenuViewWillShow:)]) {
        [self.delegate dropMenuViewWillShow:self]; // 将要显示回调代理
    }
    
    // 刷新下拉列表数据
    [self reloadData];
    
    // 菜单高度计算
    // 计算行数
    NSInteger totalLines = [self totalLines];
    CGFloat listHeight = [self heightForLine] * totalLines;
    UIEdgeInsets insets = [self collectionView:self.collectionView layout:(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout insetForSectionAtIndex:0];
    listHeight += insets.top + insets.bottom;
    
    // 加上每行之间的间距
    CGFloat padding = [self collectionView:self.collectionView layout:(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout minimumLineSpacingForSectionAtIndex:0];
    listHeight += (totalLines - 1) * padding;
    
    
    self.bgView.contentViewHeight.constant = listHeight;
    [self.bgView layoutIfNeeded];
    self.bgView.hidden = NO;
    
    // 执行展开动画
    self.collectionViewTop.constant = 0.0;
    
    [UIView animateWithDuration:self.animateTime animations:^{
        [self.bgView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(dropMenuViewDidShow:)]) {
            [self.delegate dropMenuViewDidShow:self]; // 已经显示回调代理
        }
    }];
    
}

- (void)tapOnBgView {
    [self hide];
}

- (void)hide {
    if (_isOpened == NO) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(dropMenuViewWillHidden:)]) {
        [self.delegate dropMenuViewWillHidden:self]; // 将要隐藏回调代理
    }
    self.bgView.touchNotInContentBlock = nil;
    // 执行关闭动画
    self.collectionViewTop.constant = -self.bgView.contentView.frame.size.height;
    [UIView animateWithDuration:self.animateTime animations:^{
        [self.bgView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.bgView.hidden = YES;
        self->_isOpened = NO;
        
        if ([self.delegate respondsToSelector:@selector(dropMenuViewDidHidden:)]) {
            [self.delegate dropMenuViewDidHidden:self]; // 已经隐藏回调代理
        }
    }];
    
}

#pragma mark - Utility Methods
- (CGPoint)getScreenPosition {
    return [self.superview convertPoint:self.frame.origin toView:[self getCurrentKeyWindow]];
}

- (UIWindow *)getCurrentKeyWindow {
    UIApplication * application = [UIApplication sharedApplication];
    NSInteger foundIndex = [application.windows indexOfObjectWithOptions:NSEnumerationReverse passingTest:^BOOL(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectEqualToRect(obj.bounds, UIScreen.mainScreen.bounds)) {
            if ([obj isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
                return NO;
            }
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    if (foundIndex != NSNotFound) {
        return application.windows[foundIndex];
    }
    return [UIApplication sharedApplication].keyWindow;
}

- (NSInteger)numberOfOneLine {
    if (![self.dataSource respondsToSelector:@selector(numberOfOneLineInDropMenuView:)]) {
        return  1;
    }
    NSUInteger numberOfOnline = [self.dataSource numberOfOneLineInDropMenuView:self];
    if (numberOfOnline <= 0) {
        return 1;
    }
    return numberOfOnline;
}

- (CGFloat)heightForLine {
    if (![self.dataSource respondsToSelector:@selector(heightForLineInDropMenuView:)]) {
        return  30.0;
    }
    return  [self.dataSource heightForLineInDropMenuView:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfItemsInDropMenuView:self];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYDropMenuDefaultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYDropMenuDefaultCell" forIndexPath:indexPath];
    NSString *title = [self.dataSource dropMenuView:self titleForItemAtIndex:indexPath.row];
    NSInteger selectedIndex = [self.dataSource indexOfSelectedItemInDropMenuView:self];
    
    if (selectedIndex == indexPath.row) {
        cell.contentView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:49/255.0 blue:74/255.0 alpha:1.0].CGColor;
        cell.contentView.backgroundColor = [UIColor colorWithRed:253/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        cell.titleLabel.textColor = [UIColor colorWithRed:253/255.0 green:49/255.0 blue:74/255.0 alpha:1.0];
    }
    else {
        cell.contentView.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.textColor = [UIColor colorWithRed:111/255.0 green:111/255.0 blue:112/255.0 alpha:1.0];
    }
    cell.titleLabel.text = title;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger numberOfOnline = [self numberOfOneLine];
    UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    NSInteger padding = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    CGFloat itemWidth = floor(((collectionView.frame.size.width - insets.left - insets.right) - (numberOfOnline - 1) * padding) / numberOfOnline);
    
    return CGSizeMake(itemWidth, [self heightForLine]);
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 15, 10, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XYDropMenuDefaultCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(dropMenuView:didSelectItemAtIndex:optionTitle:)]) {
        [self.delegate dropMenuView:self didSelectItemAtIndex:indexPath.row optionTitle:cell.titleLabel.text];
    }
    
    [collectionView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       [self hide];
    });
}


@end



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
    if ([self shouldTouchInContent:point]) {
        return [super hitTest:point withEvent:event];
    }
    if (event.type == UIEventTypeTouches
        /*&& event.allTouches.anyObject.phase == UITouchPhaseEnded*/
    ) {
        if (self.touchNotInContentBlock) {
            self.touchNotInContentBlock(point);
        }
    }
    return nil;
}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    touches.anyObject.view.frame
//}

// 只有相对在contentView上的坐标才可以点击
- (BOOL)shouldTouchInContent:(CGPoint)point {
    return CGRectContainsPoint(self.contentView.frame, point) == YES;
}

@end


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
