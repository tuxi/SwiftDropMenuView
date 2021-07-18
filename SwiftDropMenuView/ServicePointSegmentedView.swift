//
//  ServicePointSegmentedView.swift
//  DigitalCommunity
//
//  Created by xiaoyuan on 2021/7/19.
//

import UIKit

class ServicePointSegmentedView: UIView {

    lazy var nearbyBtn = SwiftDropMenuControl(frame: .zero, listView: NearbyFilterDropMenuView()).with {
        $0.setTitle("附近", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
//        $0.titleLabel?.font = UIFont.dc.font(size: 14)
//        $0.setTitleColor(hexColor("#666666"), for: .normal)
//        $0.setTitleColor(hexColor("#04B8B8"), for: .selected)
//        $0.setImage(R.image.icon_sort_arrow_down_1(), for: .normal)
//        $0.setImage(R.image.icon_sort_arrow_up_1(), for: .selected)
        $0.contentHorizontalAlignment = .right
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        $0.animateDuration = 0.1
    }
    
    lazy var allBtn = UIButton().with {
        $0.setTitle("全部", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
//        $0.titleLabel?.font = UIFont.dc.font(size: 14)
//        $0.setTitleColor(hexColor("#666666"), for: .normal)
//        $0.setTitleColor(hexColor("#04B8B8"), for: .selected)
        $0.contentHorizontalAlignment = .left
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
