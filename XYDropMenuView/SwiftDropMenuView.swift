//
//  SwiftDropMenuView.swift
//  XYDropMenuView
//
//  Created by xiaoyuan on 2020/10/21.
//  Copyright © 2020 xiaoyuan. All rights reserved.
//

import UIKit

@objc public protocol SwiftDropMenuViewDataSource: NSObjectProtocol {
    
    // 总数量
    func numberOfItems(in menu: SwiftDropMenuView) -> Int
    // 标题
    func dropMenuView(_ menu: SwiftDropMenuView, titleForItemAt index: Int) -> String
    
    // 获取每行的高度，默认30.0
    @objc optional func heightForLine(in menu: SwiftDropMenuView) -> CGFloat
    // 获取选中的index
    @objc optional func indexOfSelectedItem(in menu: SwiftDropMenuView) -> Int
    // 每行展示的数量
    @objc optional func numberOfOneLine(in menu: SwiftDropMenuView) -> Int
}

@objc public protocol SwiftDropMenuViewDelegate: NSObjectProtocol {

    @objc optional func dropMenuView(_ menu: SwiftDropMenuView, didSelectItem: String?, atIndex index: Int)
    @objc optional func dropMenuViewDidShow(_ menu: SwiftDropMenuView)
    @objc optional func dropMenuViewDidHidden(_ menu: SwiftDropMenuView)
    @objc optional func dropMenuViewWillShow(_ menu: SwiftDropMenuView)
    @objc optional func dropMenuViewWillHidden(_ menu: SwiftDropMenuView)
}

private class SeiftDropMenuDefaultCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12.0)
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel]|", options: [], metrics: nil, views: ["titleLabel": self.titleLabel])
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|", options: [], metrics: nil, views: ["titleLabel": self.titleLabel]))
        NSLayoutConstraint.activate(constraints)
        
        
        self.contentView.layer.borderColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1.0).cgColor
        self.contentView.backgroundColor = .white
        self.titleLabel.textColor = UIColor(red: 111/255.0, green: 111/255.0, blue: 112/255.0, alpha: 1.0)
        
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.borderWidth = 1.0
    }
}

private class SwiftDropMenuViewBgView: UIControl {
    
    lazy var contentView: UIView = {
        let contentView = UIView(frame: self.bounds)
        contentView.layer.masksToBounds = true
        return contentView
    }()
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.isUserInteractionEnabled = false
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return coverView
    }()
    
    weak var contentViewTop: NSLayoutConstraint?
    weak var coverViewTop: NSLayoutConstraint?
    weak var contentViewHeight: NSLayoutConstraint?
    
    // 点击了不在contentView 上的坐标
    var touchNotInContentBlock: ((_ point: CGPoint) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        
        self.backgroundColor = .clear
        
        self.addSubview(self.coverView)
        self.coverView.translatesAutoresizingMaskIntoConstraints = false
        let coverViewTop = coverView.topAnchor.constraint(equalTo: self.topAnchor)
        coverViewTop.isActive = true
        self.coverViewTop = coverViewTop
        coverView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        coverView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        coverView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        let contentViewTop = contentView.topAnchor.constraint(equalTo: self.topAnchor)
        contentViewTop.isActive = true
        self.contentViewTop = contentViewTop
        let contentHeight = contentView.heightAnchor.constraint(equalToConstant: 0.0)
        contentHeight.isActive = true
        self.contentViewHeight = contentHeight
        
    }
    
    // 只有相对在coverView上的坐标才可以点击
    func shouldTouchInCover(point: CGPoint) -> Bool {
        return self.coverView.frame.contains(point) == true
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let flag = shouldTouchInCover(point: point)
        if flag == true {
            return super.hitTest(point, with: event)
        }
        if let block = self.touchNotInContentBlock {
            block(point)
        }
        return nil
    }
    
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        return shouldTouch(point: point)
//    }
}

public class SwiftDropMenuView: UIButton {
    
    public weak var dataSource: SwiftDropMenuViewDataSource?
    public weak var delegate: SwiftDropMenuViewDelegate?
    // 最多展示的行数，当实际行数大于numberOfMaxLines时，支持滚动
    public var numberOfMaxLines: Int?
    
    // 下拉列表
    private weak var collectionView: UICollectionView?
    private var createCollectionView: UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout);
        collectionView.isScrollEnabled  = false
        collectionView.backgroundColor = .white
        collectionView.register(SeiftDropMenuDefaultCell.self, forCellWithReuseIdentifier: "SeiftDropMenuDefaultCell")
        return collectionView
    }
    
    private weak var collectionViewTop: NSLayoutConstraint?

    // 下拉动画时间 default: 0.25
    private var animateTime: TimeInterval = 0.25
    private var isOpened = false
    private var bgView = SwiftDropMenuViewBgView()
    
    private var numberOfOneLine: Int {
        
        if self.dataSource?.responds(to: #selector(SwiftDropMenuViewDataSource.numberOfOneLine(in:))) == false {
            return 1
        }
        let numberOfOnline = self.dataSource?.numberOfOneLine?(in: self) ?? 1
        return max(1, numberOfOnline)
    }
    
    private var totalLines: Int {
        guard let count = self.dataSource?.numberOfItems(in: self) else {
            return 0
        }
         // 计算行数
        let totalLines = ceil(Float(count) / Float(numberOfOneLine))
        return Int(totalLines)
    }
    
    private var heightForLine: CGFloat {
        if self.dataSource?.responds(to: #selector(SwiftDropMenuViewDataSource.heightForLine(in:))) == false {
            return 30.0
        }
        return self.dataSource?.heightForLine?(in: self) ?? 30.0
    }

    // 计算行数
    private var listHeight: CGFloat {
        guard let collectionView = self.collectionView else {
            return 0.0
        }
        var totalLines = self.totalLines
        if let maxLines = self.numberOfMaxLines, totalLines > maxLines {
            totalLines = maxLines
            collectionView.isScrollEnabled = true
        }
        else {
            collectionView.isScrollEnabled = false
        }
        var listHeight = floor(self.heightForLine * CGFloat(totalLines))
        let insets = self.collectionView(collectionView, layout: collectionView.collectionViewLayout as! UICollectionViewFlowLayout, insetForSectionAt: 0)
        
        listHeight += insets.top + insets.bottom

        // 加上每行之间的间距
        let linePadding = self.collectionView(collectionView, layout: collectionView.collectionViewLayout as! UICollectionViewFlowLayout, minimumLineSpacingForSectionAt: 0)
        listHeight += CGFloat(totalLines - 1) * linePadding
        return listHeight
    }
    
    private static var currentKeyWindow: UIWindow {
        let windows = UIApplication.shared.windows
        let UIRemoteKeyboardWindow: AnyClass? = NSClassFromString("UIRemoteKeyboardWindow")
        let topWindow = windows.last {
            if $0.bounds.equalTo(UIScreen.main.bounds) == true {
                if let UIRemoteKeyboardWindow = UIRemoteKeyboardWindow, $0.isKind(of: UIRemoteKeyboardWindow) {
                    return false
                }
                return true
            }
            return false
        }
        if let window = topWindow {
            return window
        }
        return UIApplication.shared.keyWindow ?? UIApplication.shared.delegate!.window!!
    }
    
    
    private var screenPosition: CGPoint {
        return self.superview?.convert(self.frame.origin, to: Self.currentKeyWindow) ?? .zero
    }

    deinit {
        self.bgView.removeFromSuperview()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    private func commonInit() {
        let collectionView = self.createCollectionView
        collectionView.delegate = self
        collectionView.dataSource  = self
        
        self.bgView.contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.leadingAnchor.constraint(equalTo: self.bgView.contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.bgView.contentView.trailingAnchor).isActive = true
        let collectionViewTop = collectionView.topAnchor.constraint(equalTo: self.bgView.contentView.topAnchor)
        collectionViewTop.isActive = true
        self.collectionViewTop = collectionViewTop
        collectionView.heightAnchor.constraint(equalTo: self.bgView.contentView.heightAnchor).isActive = true
        
        self.collectionView = collectionView
        
        self.addTarget(self, action: #selector(clickMe(sender:)), for: .touchUpInside)
        
        bgView.isHidden = true
        bgView.addTarget(self, action: #selector(tapOnBgView), for: .touchUpInside)
    }
    
    @objc private func clickMe(sender: UIButton) {
        if isOpened == false {
            show()
        }
        else {
            hide()
        }
    }

    public func reloadData() {
        self.collectionView?.reloadData()
    }

    // 显示下拉菜单
    public func show() {
        if self.isOpened == true {
            return
        }
        self.isOpened = true
        
        bgView.touchNotInContentBlock = {[weak self] point in
            self?.hide()
        }
        
        let newPosition = self.screenPosition
        self.bgView.contentViewTop?.constant = newPosition.y + self.frame.size.height
        
        self.bgView.contentView.layer.borderColor  = self.layer.borderColor
        self.bgView.contentView.layer.borderWidth  = self.layer.borderWidth
        self.bgView.contentView.layer.cornerRadius = self.layer.cornerRadius
        self.bgView.coverViewTop?.constant = newPosition.y + self.frame.size.height
        
        let window = SwiftDropMenuView.currentKeyWindow
        window.addSubview(self.bgView)
        self.bgView.frame = window.bounds
        
        if self.delegate?.responds(to: #selector(SwiftDropMenuViewDelegate.dropMenuViewWillShow(_:))) == true {
            // 将要显示回调代理
            self.delegate?.dropMenuViewWillShow?(self)
        }
        
        // 刷新下拉列表数据
        reloadData()
        
        // 菜单高度计算
        self.bgView.contentViewHeight?.constant = listHeight
        self.bgView.layoutIfNeeded()
        self.bgView.isHidden = false

        // 执行展开动画
        self.collectionViewTop?.constant = 0.0

        UIView.animate(withDuration: self.animateTime, animations: {
            self.bgView.layoutIfNeeded()
        }) { (isFinished) in
            // 已经显示回调代理
            if self.delegate?.responds(to: #selector(SwiftDropMenuViewDelegate.dropMenuViewDidShow(_:))) == true {
                self.delegate?.dropMenuViewDidShow?(self)
            }
        }
    }
    
    
    
    // 隐藏下拉菜单
    public func hide() {
        if self.isOpened == false {
            return
        }

        self.bgView.touchNotInContentBlock = nil
        if self.delegate?.responds(to: #selector(SwiftDropMenuViewDelegate.dropMenuViewWillHidden(_:))) == true {
            // 将要隐藏回调代理
            self.delegate?.dropMenuViewWillHidden?(self)
        }
       
        // 执行关闭动画
        self.collectionViewTop?.constant = -self.bgView.contentView.frame.size.height
        UIView.animate(withDuration: self.animateTime, animations: {
            self.bgView.layoutIfNeeded()
        }) { (isFinished) in
            self.bgView.isHidden = true
            self.isOpened = false
            
            if self.delegate?.responds(to: #selector(SwiftDropMenuViewDelegate.dropMenuViewDidHidden(_:))) == true {
                // 已经隐藏回调代理
                self.delegate?.dropMenuViewDidHidden?(self)
            }
        }
    }
    
    @objc private func tapOnBgView() {
        hide()
    }
    
}

extension SwiftDropMenuView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.numberOfItems(in: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeiftDropMenuDefaultCell", for: indexPath) as! SeiftDropMenuDefaultCell
        let title = self.dataSource?.dropMenuView(self, titleForItemAt: indexPath.row)
        let selectIndex = self.dataSource?.indexOfSelectedItem?(in: self)
        if selectIndex == indexPath.row {
            cell.contentView.layer.borderColor = UIColor(red: 255/255.0, green: 49/255.0, blue: 74/255.0, alpha: 1.0).cgColor
            cell.contentView.backgroundColor = UIColor(red: 253/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
            cell.titleLabel.textColor = UIColor(red: 253/255.0, green: 49/255.0, blue: 74/255.0, alpha: 1.0)
        }
        else {
            cell.contentView.layer.borderColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1.0).cgColor
            cell.contentView.backgroundColor = .white
            cell.titleLabel.textColor = UIColor(red: 111/255.0, green: 111/255.0, blue: 112/255.0, alpha: 1.0)
        }
        cell.titleLabel.text = title
        return cell
    }

}

extension SwiftDropMenuView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfOnline = CGFloat(self.numberOfOneLine)
        let insets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let padding = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
            
        let contentWidth = ((collectionView.frame.size.width - insets.left - insets.right) - (numberOfOnline - 1) * padding)
        let itemWidth = floor(contentWidth / numberOfOnline)

        return CGSize(width: itemWidth, height: self.heightForLine)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:  IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SeiftDropMenuDefaultCell
        if self.delegate?.responds(to: #selector(SwiftDropMenuViewDelegate.dropMenuView(_:didSelectItem:atIndex:))) == true {
            self.delegate?.dropMenuView?(self, didSelectItem: cell.titleLabel.text, atIndex: indexPath.row)
        }
        
        collectionView.reloadData()
        
        DispatchQueue.main.async {
            self.hide()
        }
    }
}
