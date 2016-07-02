//
//  QJDJNavViewController.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/17.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class QJDJNavViewController: UINavigationController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 添加pan
        let pan = UIPanGestureRecognizer(target: self.interactivePopGestureRecognizer?.delegate, action: Selector("handleNavigationTransition:"))
        
        view.addGestureRecognizer(pan)
        
        // 禁止边缘手势触发
        self.interactivePopGestureRecognizer?.enabled = false
        
        pan.delegate = self
        
    }
    //MARK: - 设置导航条相关属性
   override class func initialize() {
    
        let bar = UINavigationBar.appearance()
            bar.barTintColor = UIColor(red: 0.0, green: 166/255.0, blue: 83/255.0, alpha: 1)
        var dict = [String: AnyObject]()
    
            dict[NSFontAttributeName] = UIFont.boldSystemFontOfSize(20)
            dict[NSForegroundColorAttributeName] = UIColor.whiteColor()
            bar.titleTextAttributes = dict
    
            //bar.setBackgroundImage(UIImage(named: "navigationbarBackgroundWhite"), forBarMetrics: .Default)
    }

}


    //MARK: - 全局返回按钮,侧滑返回
extension QJDJNavViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        // 在根控制器下不需要滑动手势
        return self.childViewControllers.count > 1
    }
    
    // 根控制器不需要设置返回按钮
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
        if viewController.classForCoder == QJDJShopsViewController.classForCoder() {
        
            viewController.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
            viewController.navigationController?.navigationBarHidden = true

        }
        
        if self.childViewControllers.count != 0 {
            
            let backBtn = UIButton(type: .Custom)
            backBtn.setImage(UIImage(named: "navigationButtonReturn"), forState: .Normal)
            backBtn.setImage(UIImage(named: "navigationButtonReturnClick"), forState: .Highlighted)
            
            // 文字不需要
            
            backBtn.addTarget(self, action: #selector(QJDJNavViewController.back), forControlEvents: .TouchUpInside)
            
            backBtn.sizeToFit()
            
            let view = UIView()
            view.bounds = backBtn.bounds
            view.addSubview(backBtn)
            backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
            
            viewController.hidesBottomBarWhenPushed = true
            
        }
        super.pushViewController(viewController, animated: true)
    }
    
  @objc private func back() {
    
        self.popViewControllerAnimated(true)
    
    }
}