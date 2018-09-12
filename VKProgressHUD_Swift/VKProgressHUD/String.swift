//
//  String.swift
//  VKOOY_iOS
//
//  Created by Mike on 18/9/10.
//  E-mail:vkooys@163.com
//  Copyright © 2018年 VKOOY. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /**
     Get the height with font.
     
     - parameter font:       The font.
     - parameter fixedWidth: The fixed width.
     
     - returns: The height.
     */
    func heightWithFont(font : UIFont, fixedWidth : CGFloat) -> CGFloat {
        
        guard self.count > 0 && fixedWidth > 0 else {
            
            return 0
        }
        
        let size = CGSize(width:fixedWidth, height:CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context:nil)
        
        return rect.size.height
    }
    
    /**
     Get the width with the string.
     
     - parameter font: The font.
     
     - returns: The string's width.
     */
    func widthWithFont(font : UIFont) -> CGFloat {
        
        guard self.count > 0 else {
            
            return 0
        }
        
        let size = CGSize(width:CGFloat.greatestFiniteMagnitude, height:0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context:nil)
        
        return rect.size.width
    }
}

