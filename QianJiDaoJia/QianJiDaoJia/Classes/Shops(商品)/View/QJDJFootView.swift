//
//  QJDJFootView.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/22.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class QJDJFootView: UIView {

    
    class func viewFromNib() -> QJDJFootView {
        return NSBundle.mainBundle().loadNibNamed("QJDJFootView", owner: nil, options: nil).first as! QJDJFootView
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
