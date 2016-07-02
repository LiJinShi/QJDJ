//
//  QJDJTabBarController.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/16.
//  Copyright © 2016年 LJS. All rights reserved.
//  标签控制器

import UIKit

class QJDJTabBarController: UITabBarController {

    var myTabBar: QJDJTabBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAllChildVC() // 添加子控制器
        setTabBarItem() // 设置全局的tabBarItem(里面的文字大小颜色)
        setupAllTabBarButton() // 设置tabBarButton文字和图片内容

        setupTabBar() // 设置自定义的tabBar
    }
    
    // 自定义tabBar的高度
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var tabFrame = tabBar.frame
        tabFrame.size.height = 55
        tabFrame.origin.y = view.height - 55
        myTabBar?.frame = tabFrame
        
        let newImage = ImageTool.OriginImage(UIImage(named: "tabbarImage")!, size: CGSize(width: view.width, height: 55))
        myTabBar?.backgroundImage = newImage
        myTabBar?.shadowImage = UIImage()
    }
    
    // 添加子控制器
    private func addAllChildVC() {
        addChildViewController(QJDJNavViewController(rootViewController: QJDJHomeController()))
        addChildViewController(QJDJNavViewController(rootViewController: QJDJSortController(nibName: "QJDJSortController", bundle: nil)))
        addChildViewController(QJDJNavViewController(rootViewController: UIViewController()))
        addChildViewController(QJDJNavViewController(rootViewController: QJDJDiscoverController()))
        addChildViewController(QJDJNavViewController(rootViewController: QJDJMineViewController()))
    }

    // 设置全局的tabBarItem(里面的文字大小颜色)
    private func setTabBarItem() {
        // 获取当前类下的UITabBarItem
        let item = UITabBarItem.appearance()
        
        // 设置选中状态下文字颜色
        var attrColor = [String: AnyObject]()
        attrColor[NSForegroundColorAttributeName] = UIColor(red: 0.0, green: 166/255.0, blue: 83/255.0, alpha: 1)
        item.setTitleTextAttributes(attrColor, forState: .Selected)
        
        // 设置字体大小
        var attrFont = [String: AnyObject]()
        attrFont[NSFontAttributeName] = UIFont.systemFontOfSize(14)
        item.setTitleTextAttributes(attrFont, forState: .Normal)
    }
    
    // 设置tabBarButton文字和图片内容
    private func setupAllTabBarButton() {
    // 设置tabBarButton文字和图片
        
        let size = CGSize(width: 30, height: 30) // 图片统一尺寸
        
        let nav0 = self.childViewControllers[0]
        nav0.tabBarItem.title = "主页"
        nav0.tabBarItem.image = ImageTool.OriginImage(UIImage(named: "tabbar_home_n")!, size: size)
        nav0.tabBarItem.selectedImage = ImageTool.OriginImage(UIImage(named: "tabbar_home_o")!, size: size)
        
        let nav1 = self.childViewControllers[1]
        nav1.tabBarItem.title = "分类"
        nav1.tabBarItem.image = ImageTool.OriginImage(UIImage(named: "tabbar_sort_n")!, size: size)
        nav1.tabBarItem.selectedImage = ImageTool.OriginImage(UIImage(named: "tabbar_sort_o")!, size: size)
        // 占位控制器
        let vc = self.childViewControllers[2]
        vc.tabBarItem.enabled = false
        
        let nav3 = self.childViewControllers[3]
        nav3.tabBarItem.title = "发现"
        nav3.tabBarItem.image = ImageTool.OriginImage(UIImage(named: "tabbar_event_n")!, size: size) 
        nav3.tabBarItem.selectedImage = ImageTool.OriginImage(UIImage(named: "tabbar_event_o")!, size: size)
        
        let nav4 = self.childViewControllers[4]
        nav4.tabBarItem.title = "我的"
        nav4.tabBarItem.image = ImageTool.OriginImage(UIImage(named: "tabbar_user_n")!, size: size) 
        nav4.tabBarItem.selectedImage = ImageTool.OriginImage(UIImage(named: "tabbar_user_o")!, size: size)
    }
    
    // 设置自定义的tabBar
    private func setupTabBar() {
        let tabBar1 = QJDJTabBar()
        tabBar1.delegateForBtn = self
        myTabBar = tabBar1
        self.setValue(tabBar1, forKey: "tabBar")
        
        // 设置tabBar的y值（可让tabBar悬浮）
//        let frame = UIScreen.mainScreen().bounds
//        let y = CGRectGetHeight(frame) - 80
//        tabBar1.frame = CGRect(x: 0, y: y, width: frame.width, height: 80)
//        let transitionView = view.subviews[0]
//        transitionView.height = frame.size.height - 80

        self.selectedIndex = 0 // 设置默认选中第0个
    }
}
extension QJDJTabBarController: QJDJTabBarDelegate{
    func didShopButtonClick() {
        (selectedViewController as! UINavigationController).pushViewController(QJDJShopCarController(), animated: true)
    }
}

