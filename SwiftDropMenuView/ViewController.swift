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
    weak var dropMenu1: SwiftDropMenuListView?
    weak var dropMenu2: SwiftDropMenuListView?
    
    
    weak var ocMenuView: SwiftDropMenuListView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        self.title = "DropMenu"
        
        let dropMenu = SwiftDropMenuListView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        dropMenu.backgroundColor = UIColor.blue
        dropMenu.numberOfMaxRows = 5
        dropMenu.setTitle("点我", for: .normal)
        dropMenu.dataSource = self
        dropMenu.delegate = self
        self.dropMenu1 = dropMenu
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dropMenu)
        
        let dropMenu1 = SwiftDropMenuListView(frame: .zero)
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
        
        
        let ocMenuView = SwiftDropMenuListView(frame: .zero)
        ocMenuView.setTitle("点我", for: .normal)
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
        
        /// 自定义`listView`
        let segmentView = ServicePointSegmentedView()
        view.addSubview(segmentView)
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        segmentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        segmentView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        segmentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
    }


}

extension ViewController: SwiftDropMenuListViewDataSource {
    func numberOfItems(in menu: SwiftDropMenuListView) -> Int {
        return self.titles.count
    }
    
    func dropMenu(_ menu: SwiftDropMenuListView, titleForItemAt index: Int) -> String {
        return self.titles[index]
    }
    
    func heightOfRow(in menu: SwiftDropMenuListView) -> CGFloat {
        return 40.0
    }
    
    func indexOfSelectedItem(in menu: SwiftDropMenuListView) -> Int {
        return selectedIndex ?? 0
    }
    
    func numberOfColumns(in menu: SwiftDropMenuListView) -> Int {
        if menu == self.dropMenu1 {
            return 1
        }
        return 3
    }
}

extension ViewController: SwiftDropMenuListViewDelegate {
    func dropMenu(_ menu: SwiftDropMenuListView, didSelectItem: String?, atIndex index: Int) {
        self.selectedIndex = index
    }
}


