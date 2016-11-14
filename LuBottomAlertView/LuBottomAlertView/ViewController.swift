//
//  ViewController.swift
//  LuBottomAlertView
//
//  Created by 路政浩 on 2016/11/11.
//  Copyright © 2016年 RamboLu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    lazy var testTableView : UITableView = {
        var testTableView = UITableView()
        testTableView.backgroundColor = UIColor.lightGray
        testTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        testTableView.delegate   = self
        testTableView.dataSource = self
        return testTableView
    }()
    
    let textArr = ["弹出相同样式列表",
                   "弹出上灰下红样式列表",
                   "弹出时间轴"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(testTableView)
        testTableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}
extension ViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        cell.textLabel?.text = textArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("\(indexPath)")
        switch indexPath.row {
        case 0:
            let str = ["0","测试测试测试","测试测试测试"]
            LuBottomAlertView().showBottomTableView(indexTextArr: str, bottomAction: { (num) in
                debugPrint("所选角标:\(num!)")
            })
            break
        case 1:
            let str = ["1","测试测试测试","测试测试测试"]
            LuBottomAlertView().showBottomTableView(indexTextArr: str, bottomAction: { (num) in
                debugPrint("所选角标:\(num!)")
            })
            break
        case 2:
            
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.size.height-64)/5
    }
}

