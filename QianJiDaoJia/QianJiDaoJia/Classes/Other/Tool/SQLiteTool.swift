//
//  SQLiteTool.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/25.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit
import FMDB

class SQLiteTool: NSObject {
    static var shareInstance: SQLiteTool = SQLiteTool()
    /// 懒加载创建一个数据库
    lazy var dbQueue: FMDatabaseQueue = {
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last
        // 数据库文件名
        let fileName = (path! as NSString).stringByAppendingPathComponent("QJDJ.sqlite")
        
        let queue = FMDatabaseQueue(path: fileName)
        return queue
    }()
    override init(){
        super.init()
    }
    
    /**
     创建一张表并设置好字段
     
     - parameter tabelName: 表名
     - parameter column:    一个字段名
     */
    func createTable(tabelName: String, column: String) {
        // topBanner为表内字段
        let sql = "create table if not exists \(tabelName)(id integer PRIMARY KEY AUTOINCREMENT,\(column) text);"
        dbQueue.inDatabase { (db) in
            db.executeUpdate(sql, withArgumentsInArray: nil)
        }
    }
    
    /**
     删除一张表
     
     - parameter tableName: 表名
     */
    func dropTable(tableName: String){
        if isExistTable(tableName) == false {return}
        let sql = "delete from \(tableName)" // 删除表内所有数据
        dbQueue.inDatabase { (db) in
            db.executeUpdate(sql, withArgumentsInArray: nil)
        }
    }
    
    /**
     查询一张表内所有数据
     
     - parameter tableName:   表名
     - parameter finshiBlock: block将查询到的数据回调出去
     */
    func queryTable(tableName: String, finshiBlock: (result: FMResultSet!) -> (Void)){
        if isExistTable(tableName) == false {return}
        let sql = "select * from \(tableName)"  
        dbQueue.inDatabase { (db) in
            guard let fmrSet = db.executeQuery(sql, withArgumentsInArray: nil) else {return}
            finshiBlock(result: fmrSet)
        }
    }
    
    /**
     保存data到数据库
     
     - parameter tableName: 要保存到哪张表
     - parameter column:    要保存到哪个字段下
     - parameter data:      要保存的值
     */
    func saveDataTo(tableName: String, column: String, data: NSData){
        if isExistTable(tableName) == false { 
            createTable(tableName, column: column)
        }
        let sql = "INSERT INTO \(tableName)(\(column)) VALUES(?)"
        dbQueue.inTransaction { (db, rollback) in
            do {
                try db.executeUpdate(sql, values: [data])
            }catch { // 保存数据，有错误则回滚
                rollback.memory = true
            }
        }
    }
    /**
     判断一张表是否存在
     
     - parameter tableName: 传入表名
     
     - returns: 返回布尔值(true: 存在)
     */
    func isExistTable(tableName: String) -> Bool{
        let sql = "select count(*) as 'count' from sqlite_master where type='table' and name='\(tableName)'"
        var isExist: Bool = false
        dbQueue.inDatabase { (db) in
            let rs = db.executeQuery(sql, withArgumentsInArray: nil)
            while rs.next(){
                let count = rs.intForColumn("count")
                if count == 0{
                    isExist = false
                }else{
                    isExist = true
                }
            }
        }
        return isExist
    }
}
