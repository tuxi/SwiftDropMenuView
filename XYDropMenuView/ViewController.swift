//
//  ViewController.swift
//  XYDropMenuView
//
//  Created by xiaoyuan on 2020/10/20.
//  Copyright © 2020 xiaoyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var menuView = XYDropMenuView()
    lazy var menuView1 = SwiftDropMenuView()
    
    var titles = ["选项一\n1","选项二\n2","选项三\n3","选项四\n4"]
    var selectedIndex: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let btn = UIButton(frame: CGRect(x: 0, y: 100.0, width: 60, height: 30))
        btn.setTitle("点我", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30 )
        btn.backgroundColor = .orange
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(btn)
        
        self.view.addSubview(self.menuView)
        self.menuView.delegate = self
        self.menuView.dataSource = self
        self.menuView.backgroundColor = UIColor.orange
        self.menuView.translatesAutoresizingMaskIntoConstraints = false
        
        self.menuView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.menuView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.menuView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        self.menuView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        
        self.view.addSubview(self.menuView1)
        self.menuView1.delegate = self
        self.menuView1.dataSource = self
        self.menuView1.backgroundColor = UIColor.red
        self.menuView1.translatesAutoresizingMaskIntoConstraints = false
        
        self.menuView1.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50.0).isActive = true
        self.menuView1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.menuView1.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        self.menuView1.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        self.menuView1.numberOfMaxLines = 2
        
    }
    
    @objc private func btnClick() {
        print("点几了点哦")
    }
    

}

extension ViewController: XYDropMenuViewDataSource {
    func numberOfItems(in menu: XYDropMenuView) -> Int {
        return self.titles.count
    }
    
    func numberOfOneLine(in menu: XYDropMenuView) -> Int {
        return 3
    }
    
    func heightForLine(in menu: XYDropMenuView) -> CGFloat {
        return 40.0
    }
    
    func indexOfSelectedItem(in menu: XYDropMenuView) -> Int {
        return selectedIndex ?? 0
    }
    
    func dropMenuView(_ menu: XYDropMenuView, titleForItemAt index: Int) -> String {
        return self.titles[index]
    }
    
    
}

extension ViewController: XYDropMenuViewDelegate {
    
    func dropMenuView(_ menu: XYDropMenuView, didSelectItemAt index: Int, optionTitle title: String) {
        self.selectedIndex = index
    }
    
    @nonobjc func dropMenuViewDidShow(_ menu: XYDropMenuView) {

    }

    @nonobjc func dropMenuViewDidHidden(_ menu: XYDropMenuView) {

    }

    @nonobjc func dropMenuViewWillShow(_ menu: XYDropMenuView) {

    }

    @nonobjc func dropMenuViewWillHidden(_ menu: XYDropMenuView) {

    }
}

extension ViewController: SwiftDropMenuViewDataSource {
    func numberOfItems(in menu: SwiftDropMenuView) -> Int {
        return self.titles.count
    }
    
    func dropMenuView(_ menu: SwiftDropMenuView, titleForItemAt index: Int) -> String {
        return self.titles[index]
    }
    
    func heightForLine(in menu: SwiftDropMenuView) -> CGFloat {
        return 40.0
    }
    
    func indexOfSelectedItem(in menu: SwiftDropMenuView) -> Int {
        return selectedIndex ?? 0
    }
}

extension ViewController: SwiftDropMenuViewDelegate {
    func dropMenuView(_ menu: SwiftDropMenuView, didSelectItem: String?, atIndex index: Int) {
        self.selectedIndex = index
    }
}
