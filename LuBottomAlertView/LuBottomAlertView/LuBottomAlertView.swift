//
//  LuBottomAlertView.swift
//  LuBottomAlertView
//
//  Created by 路政浩 on 2016/11/14.
//  Copyright © 2016年 RamboLu. All rights reserved.
//

import UIKit

let buttonAlertIdentifier = "buttonAlertIdentifier"

enum showAlertType : Int {
    case Tableview
    case DatePicker
}

typealias IndexPathNumBlock = (_ IndexPathNum:Int?)->Void

class LuBottomAlertView: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    fileprivate var indexPathNumBlock     : IndexPathNumBlock?
    
    fileprivate var strongSelf            : UIViewController?
    
    /// 弹出列表
    fileprivate var bottomAlertTableView  : UITableView!
    
    /// 弹出时间轴
    fileprivate var bottomAlertDatePicker : UIDatePicker!
    
    /// 弹出样式 例如: 0.默认列表,1.时间轴
    fileprivate var alertType             = Int()
    
    /// 传入字符串数组参数  参数1: 0.默认列表,1.上灰色下红色列表 ; 参数2以后:正常显示值
    fileprivate var indexText             = [String]()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let bounds = UIScreen.main.bounds
        view.frame = bounds
    }
    
    /// 带回调的底部列表弹框
    ///   - alertType   : 数组第一参数      例如: 0.默认列表,1.上灰色下红色列表
    ///   - indexTextArr: 传入一个字符串数组 例如: ["0","测试1","测试2"]
    ///   - block       : 回调输出角标数
    func showBottomTableView(indexTextArr:[String],bottomAction block:((_ IndexPathNum:Int?)->Void)?){
        showBottomBaseView(alertType: .Tableview,indexTextArr:indexTextArr)
        indexPathNumBlock = block
        alertType = 0
    }
    
    /// 带回调的底部时间轴
    ///
    ///   - block       : 回调输出年龄
    func showBottomDatePickerView(bottomAction block:((_ IndexPathNum:Int?)->Void)?){
        showBottomBaseView(alertType: .DatePicker,indexTextArr:nil)
        indexPathNumBlock = block
        alertType = 1
    }
    
    /// 基类底部弹框视图
    ///
    ///   - indexTextArr: 传入一个字符串数组
    func showBottomBaseView(alertType:showAlertType,indexTextArr:[String]?){
        view.backgroundColor = UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        let window = UIApplication.shared.keyWindow!
        window.addSubview(view)
        window.bringSubview(toFront:view)
        strongSelf = self
        switch alertType {
        case .Tableview:
            debugPrint("弹出列表视图")
            indexText = indexTextArr!
            assert(indexText == indexTextArr!, "必须传传入一个字符串数组")
            setTableView()
            showAnimation(bottomAlertTableView)
            break
        case .DatePicker:
            debugPrint("弹出时间轴视图")
            setDatePick()
            showAnimation(bottomAlertDatePicker)
            break
        }
    }
    
    deinit {
        debugPrint("销毁:\(self.classForCoder)控制器")
    }
}

extension LuBottomAlertView{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch alertType {
        case 0 :
            hideAnimation(bottomAlertTableView)
            break
        case 1 :
            hideAnimation(bottomAlertDatePicker)
            break
        default:
            break
        }
    }
    
    fileprivate func dismissAlert(){
        view.removeFromSuperview()
        strongSelf = nil
    }
    
}

// MARK: - 底部弹出时间轴
extension LuBottomAlertView{
    
    fileprivate func setDatePick(){
        view.backgroundColor = UIColor.clear
        bottomAlertDatePicker  = UIDatePicker()
        bottomAlertDatePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1334 * 430)
        bottomAlertDatePicker.datePickerMode = .date
        bottomAlertDatePicker.locale = Locale(identifier:"zh_CN")
        bottomAlertDatePicker.date = Date()
        bottomAlertDatePicker.backgroundColor = UIColor.colorWithString("#EFEFF4")
        bottomAlertDatePicker.addTarget(self, action: #selector(LuBottomAlertView.datePickerValueChange(_:)), for: UIControlEvents.valueChanged)
        view.addSubview(bottomAlertDatePicker)
        let  line = UIView()
        line.backgroundColor = UIColor.colorWithString("#d9d9d9")
        line.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1334 * 1)
        bottomAlertDatePicker.addSubview(line)
    }
    
    @objc
    fileprivate func datePickerValueChange(_ sender: UIDatePicker) {
        let beforeFormatter = DateFormatter()
        beforeFormatter.dateFormat = "yyyy"
        let beforeTime = (beforeFormatter.string(from: bottomAlertDatePicker.date) as NSString).intValue
        let currentFormatter = DateFormatter()
        let time = Date()
        currentFormatter.dateFormat = "yyyy"
        currentFormatter.locale = Locale(identifier: "en")
        let currentTime = (currentFormatter.string(from: time) as NSString).intValue
        let difference = currentTime - beforeTime
        guard difference > 0 else {
            let actionAlert = UIAlertController(title: "年龄选择错误", message: nil, preferredStyle: .alert)
            let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            actionAlert.addAction(cancelBtn)
            present(actionAlert, animated: true, completion: nil)
            debugPrint("年龄错误")
            return
        }
        if indexPathNumBlock != nil{
            indexPathNumBlock!(Int(difference))
        }
    }
}
// MARK: - 底部弹出列表
extension LuBottomAlertView{
    
    fileprivate func setTableView(){
        bottomAlertTableView = UITableView()
        bottomAlertTableView.backgroundColor = UIColor.colorWithString("#EFEFF4")
        let height:CGFloat = ((UIScreen.main.bounds.height/1334) * 100)*CGFloat(indexText.count)+((UIScreen.main.bounds.height/1334) * 10)
        bottomAlertTableView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: height)
        bottomAlertTableView.isScrollEnabled = false
        bottomAlertTableView.separatorStyle  = .none
        bottomAlertTableView.delegate        = self
        bottomAlertTableView.dataSource      = self
        bottomAlertTableView.register(bottomAlertCell.self, forCellReuseIdentifier: buttonAlertIdentifier)
        view.addSubview(bottomAlertTableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? indexText.count - 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: buttonAlertIdentifier, for: indexPath) as! bottomAlertCell
        
        if indexPath.section == 0{
            switch indexText[0] {
            case "0":
                cell.alertName.text = indexText[indexPath.row + 1]
                break
            case "1":
                if indexPath.row == 0 {
                    cell.alertName.text      = indexText[1]
                    cell.alertName.font      = UIFont.systemFont(ofSize: 15)
                    cell.alertName.textColor = UIColor.colorWithString("#888888")
                    cell.selectionStyle      = .none
                }else if indexPath.row == 1 {
                    cell.alertName.text      = indexText[2]
                    cell.alertName.font      = UIFont.systemFont(ofSize: 18)
                    cell.alertName.textColor = UIColor.colorWithString("#ff0030")
                }
                break
            default:
                break
            }
        }else{
            cell.alertName.text = "取消"
        }
        let section = tableView.numberOfSections - 2
        debugPrint("弹出的section数:\(section)")
        let row = tableView.numberOfRows(inSection: section) - 1
        debugPrint("弹出的row数:\(row)")
        if section == indexPath.section && row == indexPath.row{
            cell.lineIcon.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/1334 * 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : UIScreen.main.bounds.height/1334 * 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPathNumBlock != nil{
            if indexPath.section == 0{
                switch indexText[0] {
                case "0":
                    indexPathNumBlock!(indexPath.row)
                    hideAnimation(bottomAlertTableView)
                    break
                case "1":
                    if indexPath.row == 0 {
                        
                    }else if indexPath.row == 1{
                        indexPathNumBlock!(indexPath.row)
                        hideAnimation(bottomAlertTableView)
                    }
                    break
                default:
                    break
                }
            }
        }
        if indexPath.section == 1 {
            hideAnimation(bottomAlertTableView)
        }
    }
}

extension LuBottomAlertView{
    
    fileprivate func showAnimation(_ view:UIView){
        UIView.animate(withDuration: 0.2, animations: {
            var frame : CGRect = view.frame
            frame.origin.y =  UIScreen.main.bounds.height - view.bounds.size.height
            view.frame = frame
        })
    }
    
    fileprivate func hideAnimation(_ view:UIView){
        UIView.animate(withDuration: 0.2, animations: {
            var frame : CGRect = view.frame
            frame.origin.y =  UIScreen.main.bounds.height
            view.frame = frame
        }, completion: { (finished) in
            self.dismissAlert()
        })
    }
}

class bottomAlertCell: UITableViewCell {
    
    lazy var alertName : UILabel = {
        let alertName = UILabel()
        alertName.text      = "测试"
        alertName.font      = UIFont.systemFont(ofSize: 18)
        alertName.textColor = UIColor.black
        return alertName
    }()
    
    lazy var lineIcon : UIView = {
        var lineIcon = UIView()
        lineIcon.backgroundColor = UIColor.colorWithString("#d9d9d9")
        return lineIcon
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        alertName.textAlignment = .center
        alertName.frame = CGRect.init(x: UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width / 750 * 200, y: contentView.frame.size.height / 2 - UIScreen.main.bounds.height / 1334 * 10, width: UIScreen.main.bounds.width / 750 * 400, height: UIScreen.main.bounds.height / 1334 * 40)
        
        contentView.addSubview(alertName)
        lineIcon.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height/1334 * 99, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1334 * 1)
        contentView.addSubview(lineIcon)
    }
}
extension UIColor{
    
    class func colorWithString(_ colorString:String) -> UIColor{
        
        var cString:String = colorString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        //截取传进来的字符串 To(截取到哪一位) From(从哪一位开始截取)
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        //创建颜色的值,并将十六进制转换成十进制
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
