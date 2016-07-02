//
//  FileTool.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/7/2.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class FileTool: NSObject {
    static let shareInstance: FileTool = FileTool()
    
    
    
    /**
     指定一个文件夹路径，删除
     
     - parameter directoryPath: 文件夹全路径
     */
    func clearCachesOfDirectoryPath(directoryPath: String){
        let mgr = NSFileManager()
        
        var isDir: ObjCBool = ObjCBool(false) // 是否是一个文件夹
        let isExist: Bool = mgr.fileExistsAtPath(directoryPath, isDirectory: &isDir)
        
        if !isDir || !isExist{
            let exception = NSException(name: "fileError", reason: "文件夹不存在或路径错误", userInfo: nil)
            exception.raise()
        }
        
        // 获取文件夹下所有子文件，只能获取下一级（从缓存目录结构来看获取下一级已经够了）
        let subPaths = try? mgr.contentsOfDirectoryAtPath(directoryPath)  
        for subPath in subPaths! {
            // 拼接
            let filePath = (directoryPath + "/").stringByAppendingString(subPath)
            do {
                try mgr.removeItemAtPath(filePath)
            } catch {
                print(error)
            }
        }
    }
    
    /**
     获取指定路径下文件夹尺寸的大小
     
     - parameter directoryPath: 指定路径
     
     - returns: 文件夹大小(字符串形式，如:"15.3MB")
     */
    func getSizeOfDirectoryPath(directoryPath: String) -> String {
        let mgr = NSFileManager()
        
        var isDir: ObjCBool = ObjCBool(false) // 是否是一个文件夹
        let isExist: Bool = mgr.fileExistsAtPath(directoryPath, isDirectory: &isDir)
        
        if !isDir || !isExist{
            let exception = NSException(name: "fileError", reason: "文件夹不存在或路径错误", userInfo: nil)
            exception.raise()
        }
        
        var totalFileSize: Int = 0
        let pathArray = mgr.subpathsAtPath(directoryPath) // 获取所有子级目录(即这目录下所有全路径都有了)
        
        for subPath in pathArray! { // 遍历子目录
            let filePath = directoryPath.stringByAppendingString("/").stringByAppendingString(subPath) // 拼接子目录全路径
            if filePath.containsString(".DS") {continue} // 隐藏文件不需要优化
            
            var isDirectory: ObjCBool = ObjCBool(false)
            let isExist = mgr.fileExistsAtPath(filePath, isDirectory: &isDirectory)
            if isDirectory || !isExist {continue} // 是文件或不存在就不优化
            
            
            let fileAttr = try? mgr.attributesOfItemAtPath(filePath)
            let fileSize = fileAttr![NSFileSize] as! Int
            totalFileSize += fileSize
        }
        
        var sizeStr: String = ""
        // MB KB等转换
        if totalFileSize > 1000*1000{ // MB
            let sizeFloat = CGFloat(totalFileSize) / 1000.0 / 1000.0
            sizeStr = String(format: "%.1fMB", arguments: [sizeFloat])
        } else if totalFileSize > 1000 { // KB
            let sizeFloat = CGFloat(totalFileSize) / 1000.0
            sizeStr = String(format: "%.1fKB", arguments: [sizeFloat])
        } else if totalFileSize >= 0 {
            let sizeFloat = CGFloat(totalFileSize)
            sizeStr = String(format: "%.1fB", arguments: [sizeFloat]) 
        }
        return sizeStr
    }
}
