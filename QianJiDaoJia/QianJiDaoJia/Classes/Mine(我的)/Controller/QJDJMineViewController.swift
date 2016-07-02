//
//  QJDJMineViewController.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/16.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class QJDJMineViewController: UIViewController {

    let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的"
        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(tableView)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension QJDJMineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // 返回cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellID)
        }
        let sizeStr = FileTool.shareInstance.getSizeOfDirectoryPath(cachePath!)
        cell?.textLabel?.text = "清除缓存" + "(\(sizeStr))"
        return cell!
    }
    // 点击cell时调用
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
        
            FileTool.shareInstance.clearCachesOfDirectoryPath(cachePath!)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            print("清除成功")
        }
    }
}





