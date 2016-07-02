//
//  QJDJDetailTopView.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/19.
//  Copyright © 2016年 LJS. All rights reserved.
//  详情界面顶部view

import UIKit

class QJDJDetailTopView: UIView {
    
    let globeColor = UIColor(red: 0.0, green: 166/255.0, blue: 83/255.0, alpha: 1)
    
//    var index1 = 0
    // button
    // 综合
    @IBOutlet weak var zongheBtn: UIButton!
    // 销量
    @IBOutlet weak var xiaoliangBtn: UIButton!
    // 新品
    @IBOutlet weak var xinpinBtn: UIButton!
    // 价格
    @IBOutlet weak var jiageBtn: UIButton!
    
    // 点击不同的button执行不同的闭包
    var xiaoliangBlockDown: (() -> ())?
    var xiaoliangBlockUp: (() -> ())?
    
    var xinpinBlockDown: (() -> ())?
    var xinpinBlockUp: (() -> ())?
    
    var jiageBlockDown: (() -> ())?
    var jiageBlockUp: (() -> ())?
    
    var index1 = 0
    // 记录按钮的选中状态
    var preBtn: UIButton?
    
    // 下边跟随滚动的view
    @IBOutlet weak var xiabiaoView: UIView!
    // 监听点击

    @IBAction func zongheBtnClick() {

        clickBtn(zongheBtn, index: 0.0)
        
        // 请求数据
    }
    @IBAction func xiaoliangBtn(sender: UIButton) {

        clickBtn(sender, index: 1.0)

    }
    
    @IBAction func xinpinBtn(sender: UIButton) {
        
        clickBtn(sender, index: 2.0)
    }
    
    override func awakeFromNib() {
        
        autoresizingMask = .None
        
        preBtn = zongheBtn
        xiabiaoView.backgroundColor = globeColor
        
        zongheBtnClick()
        
    }
    
    // 在xib中取消了按钮的高亮状态
    
    @IBAction func jiageBtn(sender: UIButton) {
        clickBtn(sender, index: 3.0)
    }
    class func topView() -> QJDJDetailTopView{
    
        
       guard let view = NSBundle.mainBundle().loadNibNamed("QJDJDetailTopView", owner: nil, options: nil).first else {
        
            return QJDJDetailTopView()
        }

        return view as! QJDJDetailTopView
    }
}

    //MARK: - 点击button要做的事情
extension QJDJDetailTopView {

    func clickBtn(btn: UIButton, index: CGFloat) {
        // 根据返回的字段来判断图片朝向
        
        
        if btn == preBtn {
        
           index1 += 1
        } else {
        
            index1 = 0
        }
        
        
        
        
        // 点击button不断切换图片
        if index1 % 2 == 0 {
        
            if btn == zongheBtn {
            
                
            } else {
            
                  btn.setImage(UIImage(named: "cell_list_price_down"), forState: .Selected)
                
                // 请求降序排列 +
                if btn == xiaoliangBtn {
                    // 按销量降序排列
                    if xiaoliangBlockDown != nil {xiaoliangBlockDown!()}
                    
                }
                
                if btn == xinpinBtn {
                
                    // 按新品降序排列
                    if xinpinBlockDown != nil {xinpinBlockDown!()}
                }
                
                if btn == jiageBtn {
                
                    // 按价格降序排列
                    if jiageBlockDown != nil {jiageBlockDown!()}
                }
                
            }
          
        } else {
            
            if btn == zongheBtn {
            
            }else {
            
                  btn.setImage(UIImage(named: "cell_list_price_up"), forState: .Selected)
                
                // 请求升序排列 -
                
                if btn == xiaoliangBtn {
                    // 按销量升序排列
                    if xiaoliangBlockUp != nil {xiaoliangBlockUp!()}
                }
                
                if btn == xinpinBtn {
                    
                    // 按新品升序排列
                    if xinpinBlockUp != nil {xinpinBlockUp!()}
                }
                
                if btn == jiageBtn {
                    
                    // 按价格升序排列
                    if jiageBlockUp != nil {jiageBlockUp!()}
                }

            }
    
        }
            preBtn?.selected = false
            
            preBtn = btn
            
            btn.selected = !btn.selected
            
            xiabiaoView.frame.origin.x = index * xiabiaoView.bounds.width
            
            btn.setTitleColor(globeColor, forState: .Selected)
    
    }
}

    // 数据请求
