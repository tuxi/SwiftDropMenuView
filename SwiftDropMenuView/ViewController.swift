//
//  ViewController.swift
//  SwiftDropMenuView
//
//  Created by xiaoyuan on 2020/10/21.
//

import UIKit

class ViewController: UIViewController {

    var titles = ["选项一\n1","选项二\n2","选项三\n3","选项四\n4", "选项五\n5", "选项六\n5", "选项七\n7"]
    var selectedIndex: Int?
    weak var dropMenu1: SwiftDropMenuView?
    weak var dropMenu2: SwiftDropMenuView?
    
    
    weak var ocMenuView: XYDropMenuView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        self.title = "DropMenu"
        
        let dropMenu = SwiftDropMenuView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        dropMenu.numberOfMaxLines = 5
        dropMenu.setTitle("点我", for: .normal)
        dropMenu.dataSource = self
        dropMenu.delegate = self
        self.dropMenu1 = dropMenu
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dropMenu)
        
        let dropMenu1 = SwiftDropMenuView()
        dropMenu1.contentBackgroundColor = UIColor.green
        dropMenu1.setTitle("点我", for: .normal)
        dropMenu1.backgroundColor = UIColor.orange
        dropMenu1.setTitleColor(UIColor.white, for: .normal)
        dropMenu1.setTitleColor(UIColor.lightGray, for: .highlighted)
        dropMenu1.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        dropMenu1.dataSource = self
        dropMenu1.delegate = self
        self.dropMenu2 = dropMenu1
        
        self.view.addSubview(dropMenu1)
        dropMenu1.translatesAutoresizingMaskIntoConstraints = false
        dropMenu1.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        dropMenu1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        let ocMenuView = XYDropMenuView()
        self.view.addSubview(ocMenuView)
        ocMenuView.delegate = self
        ocMenuView.dataSource = self
        ocMenuView.backgroundColor = UIColor.orange
        ocMenuView.translatesAutoresizingMaskIntoConstraints = false
        self.ocMenuView = ocMenuView
        
        ocMenuView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 60.0).isActive = true
        ocMenuView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        ocMenuView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        ocMenuView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        
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
    
    func numberOfOneLine(in menu: SwiftDropMenuView) -> Int {
        if menu == self.dropMenu1 {
            return 1
        }
        return 3
    }
}

extension ViewController: SwiftDropMenuViewDelegate {
    func dropMenuView(_ menu: SwiftDropMenuView, didSelectItem: String?, atIndex index: Int) {
        self.selectedIndex = index
    }
}


// oc 的 menuView
extension ViewController: XYDropMenuViewDataSource {
    func numberOfItems(in menu: XYDropMenuView) -> Int {
        return self.titles.count
    }
    
    func numberOfOneLine(in menu: XYDropMenuView) -> Int {
        return 5
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
