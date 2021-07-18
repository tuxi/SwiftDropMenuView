//
//  NearbyFilterDropMenuView.swift
//  DigitalCommunity
//
//  Created by xiaoyuan on 2021/7/19.
//

import UIKit

class NearbyFilterDropMenuView: UIView {

    lazy var leftView = UITableView(frame: .zero).with {
        $0.keyboardDismissMode = .onDrag
        $0.backgroundColor = .gray
    }
    
    lazy var rightView = UITableView(frame: .zero).with {
        $0.keyboardDismissMode = .onDrag
        $0.backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(leftView)
        addSubview(rightView)
        
        leftView.translatesAutoresizingMaskIntoConstraints = false
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        leftView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        leftView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        rightView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
        rightView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        rightView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rightView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rightView.widthAnchor.constraint(equalTo: leftView.widthAnchor).isActive = true
        
        leftView.dataSource = self
        rightView.dataSource = self
        leftView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        rightView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension NearbyFilterDropMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)行"
        return cell
    }
}
