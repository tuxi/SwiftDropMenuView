//
//  SegmentedView.swift
//  SwiftDropMenuView
//
//  Created by xiaoyuan on 2021/7/19.
//

import UIKit

class SegmentedView: UIView {
    
    lazy var nearbyBtn = SwiftDropMenuControl(frame: .zero, listView: MapFilterDropMenuListView()).with {
        $0.setTitle("自定义菜单", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.setTitleColor(.red, for: .selected)
        $0.setImage(UIImage(named: "icon_sort_arrow_down_1"), for: .normal)
        $0.setImage(UIImage(named: "icon_sort_arrow_up_1"), for: .selected)
        $0.contentHorizontalAlignment = .right
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        $0.animateDuration = 0.1
    }
    
    lazy var allBtn = UIButton().with {
        $0.setTitle("全部", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.setTitleColor(.red, for: .selected)
        $0.contentHorizontalAlignment = .left
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
    }
    
    var selectedBtn: UIButton? {
        didSet {
            selectedBtn?.isSelected = true
            oldValue?.isSelected = false
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(nearbyBtn)
        addSubview(allBtn)
        nearbyBtn.translatesAutoresizingMaskIntoConstraints = false
        allBtn.translatesAutoresizingMaskIntoConstraints = false
        
        nearbyBtn.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nearbyBtn.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nearbyBtn.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        allBtn.leadingAnchor.constraint(equalTo: nearbyBtn.trailingAnchor).isActive = true
        allBtn.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        allBtn.topAnchor.constraint(equalTo: topAnchor).isActive = true
        allBtn.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        allBtn.widthAnchor.constraint(equalTo: nearbyBtn.widthAnchor).isActive = true
        
        nearbyBtn.addTarget(self, action: #selector(nearbyBtnAction(sender:)), for: .touchUpInside)
        allBtn.addTarget(self, action: #selector(allBtnAction(sender:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func nearbyBtnAction(sender: UIButton) {
        selectedBtn = sender
    }
    @objc private func allBtnAction(sender: UIButton) {
        selectedBtn = sender
    }
    
}
