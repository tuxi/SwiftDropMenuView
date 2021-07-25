# SwiftDropMenuView

一个自定义下拉菜单的实现，可用于一些筛选菜单。
GitHub: https://github.com/tuxi/SwiftDropMenuView

![自定义菜单SwiftDropMenuControl.png](https://upload-images.jianshu.io/upload_images/2135374-414a7ad5e61bea72.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/360)

![截屏2021-07-25 上午10.20.06.png](https://upload-images.jianshu.io/upload_images/2135374-505b9e54421808a3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/360)


根据项目中经常使用的几种情况（比如地图上的范围筛选、商品的分类及价格筛选等等），封装的下拉菜单，可查看示例了解其使用原理

### 已实现两种菜单：
- 1.通用的下拉菜单`SwiftDropMenuControl`，可通过初始化方法中传入`listView`自定义其展开内容
```swift
        func createMenuControl() {
            /// 使用`frame`方式
            let menuControl = SwiftDropMenuControl(frame: CGRect(x: 100, y: 280, width: 120, height: 44), listView: MapFilterDropMenuListView())
            menuControl.setTitle("自定义菜单", for: .normal)
            menuControl.setTitleColor(.gray, for: .normal)
            menuControl.setTitleColor(.gray, for: .normal)
            menuControl.setTitleColor(.red, for: .selected)
            menuControl.setImage(UIImage(named: "icon_sort_arrow_down_1"), for: .normal)
            menuControl.setImage(UIImage(named: "icon_sort_arrow_up_1"), for: .selected)
            menuControl.contentHorizontalAlignment = .right
            menuControl.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
            menuControl.animateDuration = 0.1
            menuControl.delegate = self
            menuControl.sizeToFit()
            self.view.addSubview(menuControl)
        }
```
- 2. `SwiftDropMenuListView`是基于`SwiftDropMenuControl`，使用`CollectionView`作为下拉菜单的`listView`的下拉菜单
```swift
      func createMenuListView() {
            let menuView = SwiftDropMenuListView(frame: .zero)
            menuView.setTitle("menu", for: .normal)
            self.view.addSubview(menuView)
            menuView.delegate = self
            menuView.dataSource = self
            menuView.backgroundColor = UIColor.orange
            menuView.translatesAutoresizingMaskIntoConstraints = false
            menuView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 60.0).isActive = true
            menuView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            menuView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            menuView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        }
```

通过`SwiftDropMenuControl `的`show()`和`dismiss()`方法，展开和收起下拉菜单，通常情况，我们不需要主动调用`show ()`展开菜单，因为在用户点击`SwiftDropMenuControl `时，`show()`方法会被执行，如果你不需要点击时展开，可实现代理方法`shouldTou

### 下拉菜单展开或收起的代理方法
```swift
/// 反内容馈显示或消失的回调
public protocol SwiftDropMenuControlContentAppearable {
     
     func on(appear element: SwiftDropMenuControl.AppearElement, forDropMenu menu: SwiftDropMenuControl)
}

@objc public protocol SwiftDropMenuControlDelegate: NSObjectProtocol {
     
     @objc optional func shouldTouchMe(forDropMenu menu: SwiftDropMenuControl) -> Bool
}
```
