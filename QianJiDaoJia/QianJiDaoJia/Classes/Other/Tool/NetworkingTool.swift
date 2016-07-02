//
//  NetworkingTool.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/17.
//  Copyright © 2016年 LJS. All rights reserved.
//  网络工具类的封装

import UIKit
import Alamofire
import Foundation
import SystemConfiguration

//创建请求类枚举
enum RequestType: Int {
    case requestTypeGet
    case requestTypePost
    case requestTypeDelegate
}
//关于网络检测枚举
let ReachabilityStatusChangedNotification = "ReachabilityStatusChangedNotification"

enum ReachabilityType: CustomStringConvertible {
    case WWAN
    case WiFi
    
    var description: String {
        switch self {
        case .WWAN: return "WWAN"
        case .WiFi: return "WiFi"
        }
    }
}

enum ReachabilityStatus: CustomStringConvertible  {
    case Offline
    case Online(ReachabilityType)
    case Unknown
    
    var description: String {
        switch self {
        case .Offline: return "Offline"
        case .Online(let type): return "Online (\(type))"
        case .Unknown: return "Unknown"
        }
    }
}

//创建一个闭包(注:oc中block)
typealias sendVlesClosure = (responseData: AnyObject?, error: NSError?)->Void
typealias uploadClosure = (AnyObject?, NSError?,Int64?,Int64?,Int64?)->Void

class NetworkingTool: NSObject {
    //网络请求中的GET,Post,DELETE
    func request(type:RequestType ,URLString:String, Parameter:[String:AnyObject]?, block:sendVlesClosure) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if (!self.checkConnect()) { // 有网络
            return
        }
        switch type {
            
        case .requestTypeGet:
            Alamofire.request(.GET, URLString, parameters: Parameter).responseJSON {response in
                block(responseData: response.result.value, error: response.result.error)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                //把得到的JSON数据转为字典
            }
        case .requestTypePost:
            Alamofire.request(.POST, URLString, parameters:Parameter).responseJSON {response in
                block(responseData: response.result.value, error: response.result.error)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                //把得到的JSON数据转为字典
            }
        case .requestTypeDelegate:
            Alamofire.request(.DELETE, URLString, parameters: Parameter).responseJSON{responde in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
            }
        }
        
    }
    
    //关于文件上传的方法
    //fileURL实例:let fileURL = NSBundle.mainBundle().URLForResource("Default",withExtension: "png")
    func upload(type:RequestType,URLString:String,fileURL:NSURL,block:uploadClosure) {
        //检测网络是否存在的方法
        if (!self.checkConnect()) {
            return
        }
        Alamofire.upload(.POST, URLString, file: fileURL).progress {(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
            block(nil,nil,bytesWritten ,totalBytesWritten,totalBytesExpectedToWrite)
            }.responseJSON { response in
                block(response.result.value,response.result.error,nil,nil,nil)
        }
    }
    //关于文件下载的方法
    //下载到默认路径let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
    let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
    //默认路径可以设置为空,因为有默认路径
    func download(type:RequestType,URLString:String,block:uploadClosure) {
        //检测网络是否存在的方法
        if (!self.checkConnect()) {
            return
        }
        switch type {
        case .requestTypeGet:
            Alamofire.download(.GET, URLString, destination: destination)
                .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                    block(nil,nil,bytesRead, totalBytesRead, totalBytesExpectedToRead)
                }
                .response { (request, response, _, error) in
                    block(response,error,nil,nil,nil)
            }
            break
        case .requestTypePost:
            Alamofire.download(.POST, URLString, destination: destination)
                .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                    block(nil,nil,bytesRead, totalBytesRead, totalBytesExpectedToRead)
                }
                .response { (request, response, _, error) in
                    block(response,error,nil,nil,nil)
            }
        default:break
        }
    }
    //检测网络
    func checkConnect()->Bool {
        let status = self.connectionStatus()
        switch status{
        case .Unknown,.Offline:
            //print("无网络")
            return false
        case .Online(.WWAN):
            //print("y有网络")
            return true
        case .Online(.WiFi):
            //print("有wifi请链接")
            return true
        }
    }
    //下面是关于网络检测的方法
    func connectionStatus() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return .Unknown
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .Unknown
        }
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    
    
    func monitorReachabilityChanges() {
        let host = "google.com"
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        let reachability = SCNetworkReachabilityCreateWithName(nil, host)!
        
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
            let status = ReachabilityStatus(reachabilityFlags: flags)
            
            NSNotificationCenter.defaultCenter().postNotificationName(ReachabilityStatusChangedNotification,
                object: nil,
                userInfo: ["Status": status.description])
            
            }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes)
    }
}

extension ReachabilityStatus {
    private init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.ConnectionRequired)
        let isReachable = flags.contains(.Reachable)
        let isWWAN = flags.contains(.IsWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .Online(.WWAN)
            } else {
                self = .Online(.WiFi)
            }
        } else {
            self =  .Offline
        }
    }
}
