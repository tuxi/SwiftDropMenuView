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

@interface XYDropMenuView() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;  // 下拉列表

@property (nonatomic, strong) UIView *floatView;
@property (nonatomic, strong) UIView *coverView;

@end

@implementation XYDropMenuView
{
    CGFloat _listHeight;
    BOOL _isOpened;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self updateFrame:self.frame];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
    [self updateFrame:self.frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isOpened) return;
    
    [self updateFrame:self.frame];
}

#pragma mark - Init
- (void)commonInit {
    self.layer.masksToBounds = YES;
    
    _floatView = [[UIView alloc] initWithFrame:self.bounds];
    _floatView.layer.masksToBounds = YES;
    [self addSubview:_floatView];
    
    
    // 主按钮 显示在界面上的点击按钮
    [self addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];

    // 下拉列表TableView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate       = self;
    _collectionView.dataSource     = self;
    _collectionView.scrollEnabled  = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_floatView addSubview:_collectionView];
    
    [_collectionView registerClass:[XYDropMenuDefaultCell class] forCellWithReuseIdentifier:@"XYDropMenuDefaultCell"];
    
    _animateTime = 0.25f;
    _isOpened = NO;
}


- (void)updateFrame:(CGRect)frame {
    CGFloat width  = frame.size.width;
    CGFloat height = frame.size.height;
    [_floatView setFrame:CGRectMake(0, height, width, height)];
    [_collectionView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _collectionView.frame.size.height)];
}


#pragma mark - Set Methods
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateFrame:frame];
}



#pragma mark - Get Methods
- (UIView *)coverView {
    UIWindow *window = [self getCurrentKeyWindow];
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
        _coverView.backgroundColor = [UIColor clearColor];
        [window addSubview:_coverView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tap.delegate = self;
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}


#pragma mark - Action Methods
- (void)reloadData {
    [self.collectionView reloadData];
}
- (void)clickMainBtn:(UIButton *)button{
    if(button.selected == NO) {
        [self show];
    }else {
        [self hide];
    }
}

- (NSInteger)totalLines {
    NSUInteger count = [self.dataSource numberOfItemsInDropMenuView:self];
    
    NSUInteger numberOfOneLine = [self.dataSource numberOfOneLineInDropMenuView:self];
    // 计算行数
    NSInteger totalLines = ceil(count / (CGFloat)numberOfOneLine);
    return totalLines;
}

- (void)show {   /* 显示下拉列表 */
    _isOpened = YES;
    // 变更menu图层
    CGPoint newPosition = [self getScreenPosition];
    _floatView.frame = CGRectMake(0, newPosition.y + self.frame.size.height, UIScreen.mainScreen.bounds.size.width, _floatView.bounds.size.height);
    _floatView.layer.borderColor  = self.layer.borderColor;
    _floatView.layer.borderWidth  = self.layer.borderWidth;
    _floatView.layer.cornerRadius = self.layer.cornerRadius;
    [self.coverView addSubview:_floatView];
    
    // call delegate
    if ([self.delegate respondsToSelector:@selector(dropMenuViewWillShow:)]) {
        [self.delegate dropMenuViewWillShow:self]; // 将要显示回调代理
    }
    
    // 刷新下拉列表数据
    [self reloadData];
    
    // 菜单高度计算
    // 计算行数
    NSInteger totalLines = [self totalLines];
    _listHeight = [self.dataSource heightForLineInDropMenuView:self] * totalLines;
    UIEdgeInsets insets = [self collectionView:self.collectionView layout:(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout insetForSectionAtIndex:0];
    _listHeight += insets.top + insets.bottom;
    
    // 加上每行之间的间距
    CGFloat padding = [self collectionView:self.collectionView layout:(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout minimumLineSpacingForSectionAtIndex:0];
    _listHeight += (totalLines - 1) * padding;
    
    // 执行展开动画
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.animateTime animations:^{
        UIView *floatView     = weakSelf.floatView;
        UIView *listView = weakSelf.collectionView;
        
        floatView.frame = CGRectMake(floatView.frame.origin.x, floatView.frame.origin.y, floatView.frame.size.width, self->_listHeight);
        listView.frame = CGRectMake(listView.frame.origin.x, listView.frame.origin.y, UIScreen.mainScreen.bounds.size.width, self->_listHeight);
        
    }completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(dropMenuViewDidShow:)]) {
            [self.delegate dropMenuViewDidShow:self]; // 已经显示回调代理
        }
    }];
    
}


- (void)hide{  // 隐藏下拉列表
    // call delegate
    if ([self.delegate respondsToSelector:@selector(dropMenuViewWillHidden:)]) {
        [self.delegate dropMenuViewWillHidden:self]; // 将要隐藏回调代理
    }

    // 执行关闭动画
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.animateTime animations:^{
        UIView *floatView = weakSelf.floatView;
        weakSelf.floatView.frame  = CGRectMake(floatView.frame.origin.x, floatView.frame.origin.y, floatView.frame.size.width, 0);
        
    }completion:^(BOOL finished) {
        weakSelf.collectionView.frame = CGRectMake(weakSelf.collectionView.frame.origin.x, weakSelf.collectionView.frame.origin.y, weakSelf.frame.size.width, 0);
        
        // 变更menu图层
        weakSelf.floatView.frame = weakSelf.floatView.frame;
        [self addSubview:weakSelf.floatView];
        [weakSelf.coverView removeFromSuperview];
        weakSelf.coverView = nil;
        
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
//    return nil;
    return [UIApplication sharedApplication].keyWindow;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfItemsInDropMenuView:self];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYDropMenuDefaultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYDropMenuDefaultCell" forIndexPath:indexPath];
    NSString *title = [self.dataSource dropMenuView:self titleForOptionAtIndex:indexPath.row];
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
    
    NSUInteger numberOfOnline = [self.dataSource numberOfOneLineInDropMenuView:self];
    UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    NSInteger padding = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    CGFloat itemWidth = floor(((collectionView.frame.size.width - insets.left - insets.right) - (numberOfOnline - 1) * padding) / numberOfOnline);
    
    return CGSizeMake(itemWidth, [self.dataSource heightForLineInDropMenuView:self]);
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


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
   if ([touch.view isKindOfClass:[XYDropMenuDefaultCell class]] ||
       [touch.view.superview isKindOfClass:[XYDropMenuDefaultCell class]]) {
       return NO;
   }
   return  YES;
}

@end

