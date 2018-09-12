//
//  VKProgressInfo.swift
//  VKOOY_iOS
//
//  Created by Mike on 18/9/10.
//  E-mail:vkooys@163.com
//  Copyright © 2018年 VKOOY. All rights reserved.
//

import Foundation
import UIKit

//  自定义动画Closure
typealias VKCustomAnimationClosure = (_ layer : CAShapeLayer)->Void
//  进度被改变的Closure，通常用于自定义进度动画
typealias VKOnProgressChangedClosure = (_ layer : CAShapeLayer,_ progress : CGFloat)->Void

//  枚举 - 图文布局
enum HUDLayoutStyle: Int {
    case iconTopTitleBottom     = 0      //  图上文下
    case iconBottomTitleTop     = 3      //  图下文上
    case iconLeftTitleRight     = 1      //  图左文右
    case iconRightTitleLeft     = 4      //  图右文左
    case iconOnly               = 2      //  只显示图
    case titleOnly              = 5      //  只显示文
}

//  枚举 - 控件位置
enum HUDLocationStyle: Int {
    case top        = 0      //  屏幕顶部
    case center     = 1      //  屏幕中间
    case bottom     = 2      //  屏幕底部
}


class VKProgressInfo : NSObject {
    //  控件的大小
    var bubbleSize : CGSize?
    //  控件的圆角半径
    var cornerRadius : CGFloat = 0.0
    //  图文布局属性
    var layoutStyle : HUDLayoutStyle = .iconTopTitleBottom
    //  图标动画
    var iconAnimation : VKCustomAnimationClosure?
    //  进度被改变的回调Closure
    var onProgressChanged : VKOnProgressChangedClosure?
    //  图标数组，如果该数组为空或者该对象为nil，那么显示自定义动画，如果图标为一张，那么固定显示那个图标，大于一张的时候显示图片帧动画
    var iconArray : Array<UIImage>?
    //  要显示的标题
    var title : String?
    //  帧动画时间间隔
    var frameAnimationTime : CGFloat = 0.0
    //  图标占比 0 - 1，图标控件的边长占高度的比例
    var proportionOfIcon : CGFloat = 0.0
    //  间距占比 0 - 1，图标控件和标题控件之间距离占整个控件的比例（如果横向布局那么就相当于宽度，纵向布局相当于高度）
    var proportionOfSpace : CGFloat = 0.0
    //  内边距占比 0 - 1，整个控件的内边距，x最终为左右的内边距，y最终为上下的内边距（左右内边距以宽度算最终的像素值，上下边距以高度算最终的像素值）
    var proportionOfPadding : CGPoint?
    //  位置样式
    var locationStyle : HUDLocationStyle = .center
    //  控件显示时偏移，当位置样式为上中的时候，偏移值是向下移动，当位置样式为底部时候，偏移值是向上移动
    var proportionOfDeviation : CGFloat = 0.0
    //  是否展示蒙版，展示蒙版后，显示控件时会产生一个蒙版层来拦截所有其他控件的点击事件
    var isShowMaskView : Bool = false
    //  蒙版颜色
    var maskColor : UIColor?
    //  控件的背景色
    var backgroundColor : UIColor?
    //  图标渲染色
    var iconColor : UIColor?
    //  标题文字颜色
    var titleColor : UIColor?
    //  标题字体大小
    var titleFontSize : CGFloat = 0.0
    //  随机数，用于标志一个info的唯一性，关闭时候会通过这个验证
    var key : CGFloat = 0.0

    
    override init() {
        super.init()
        
        self.bubbleSize = CGSize.init(width: 180, height: 120)
        self.cornerRadius = 8
        self.layoutStyle = .iconTopTitleBottom
        self.iconAnimation = nil
        self.onProgressChanged = nil
        self.iconArray = nil
        self.title = "VKProgressHUD"
        self.frameAnimationTime = 0.1
        self.proportionOfIcon = 0.675
        self.proportionOfSpace = 0.1
        self.proportionOfPadding = CGPoint.init(x: 0.1, y: 0.1)
        self.locationStyle = .center
        self.proportionOfDeviation = 0.0
        self.isShowMaskView = true
        self.maskColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.iconColor = UIColor.white
        self.titleColor = UIColor.white
        self.titleFontSize = 13
        
        self.key = CGFloat(arc4random())
    }
    
    /**
     *  计算控件的整体frame
     */
    func calBubbleViewFrame() -> CGRect {

        var y : CGFloat = 0.0
        
        switch (self.locationStyle) {
            case .top:
                y = 0.0
                break
            case .center:
                y = (UIScreen.main.bounds.size.height - self.bubbleSize!.height) / 2.0
                break
            case .bottom:
                y = UIScreen.main.bounds.size.height - self.bubbleSize!.height
                break
            }
        
        y += (self.locationStyle != .bottom ? 1 : -1) * (self.proportionOfDeviation * UIScreen.main.bounds.size.height)
        
        return CGRect.init(x: (UIScreen.main.bounds.size.width - self.bubbleSize!.width) / 2, y: y, width: self.bubbleSize!.width, height: self.bubbleSize!.height)
    }
    
    
    /**
     *  计算并设置图标控件和标题控件的frame
     *  @param iconView 要设置的图标控件
     *  @param titleView 要设置的标题控件
     */
    func calIconView(iconView:UIImageView,titleView:UILabel) {
        
        let bubbleContentSize = CGSize.init(width: self.bubbleSize!.width * (1 - self.proportionOfPadding!.x * 2), height: self.bubbleSize!.height * (1 - self.proportionOfPadding!.y * 2))
        
        let iconWidth : CGFloat = (self.layoutStyle == .titleOnly) ? 0 : bubbleContentSize.height * self.proportionOfIcon
        
        let baseX : CGFloat = self.bubbleSize!.width * self.proportionOfPadding!.x
        let baseY : CGFloat = self.bubbleSize!.height * self.proportionOfPadding!.y
        
        //计算文本高度，可能是单行也可能是多行
        //先假设是单行文本
        let calTitleWidth : CGFloat = self.title!.widthWithFont(font: UIFont.systemFont(ofSize: self.titleFontSize))
        
        var titleWidth : CGFloat = (self.layoutStyle == .iconTopTitleBottom ||
                    self.layoutStyle == .iconBottomTitleTop ||
                    self.layoutStyle == .titleOnly) ?
                        bubbleContentSize.width :
                    bubbleContentSize.width * (1 - self.proportionOfSpace) - iconWidth
        //  不能超过显示区域宽度
        if (titleWidth > calTitleWidth) {
            titleWidth = calTitleWidth
        }
        
        //  根据限定的宽度计算多行文本高度
        var titleHeight : CGFloat = self.title!.heightWithFont(font: UIFont.systemFont(ofSize: self.titleFontSize), fixedWidth: titleWidth)
        //  不能超过显示区域高度
        if (titleHeight > bubbleContentSize.height) {
            titleHeight = bubbleContentSize.height
        }

        //  初始化frame
        var iconFrame = CGRect.init(x: baseX, y: baseY, width: iconWidth, height: iconWidth)
        var titleFrame = CGRect.init(x: baseX, y: baseY, width: titleWidth, height: titleHeight)
        
        switch (self.layoutStyle) {
            case .iconTopTitleBottom:
                //  图标+文本高度
                let contentHeight : CGFloat = iconWidth + bubbleContentSize.height * self.proportionOfSpace + titleHeight
                //  垂直居中，图标坐标
                iconFrame.origin.x = baseX + (bubbleContentSize.width - iconWidth) / 2.0
                iconFrame.origin.y = baseY + (bubbleContentSize.height - contentHeight) / 2.0
                //  由图标Y坐标求出文本Y坐标
                titleFrame.origin.y = iconFrame.origin.y + iconWidth + bubbleContentSize.height * self.proportionOfSpace
                titleFrame.origin.x = baseX + (bubbleContentSize.width - titleWidth) / 2.0
                
                break
            case .iconBottomTitleTop:
                //  图标+文本高度
                let contentHeight : CGFloat = iconWidth + bubbleContentSize.height * self.proportionOfSpace + titleHeight
                //  垂直居中，文本Y坐标
                titleFrame.origin.y = baseY + (bubbleContentSize.height - contentHeight) / 2.0
                titleFrame.origin.x = baseX + (bubbleContentSize.width - titleWidth) / 2.0
                //  由文本坐标求出图标坐标
                iconFrame.origin.x = baseX + (bubbleContentSize.width - iconWidth) / 2.0
                iconFrame.origin.y = titleFrame.origin.y + titleFrame.size.height + bubbleContentSize.height * self.proportionOfSpace

                break
            case .iconLeftTitleRight:
                //  图标+文本宽度
                let contentWidth : CGFloat = iconWidth + bubbleContentSize.width * self.proportionOfSpace + titleWidth
                //  水平居中，图标X坐标
                iconFrame.origin.x = baseX + (bubbleContentSize.width - contentWidth) / 2
                iconFrame.origin.y = baseY + (bubbleContentSize.height - iconWidth) / 2
                //  由图标X坐标求出文本X坐标
                titleFrame.origin.x = iconFrame.origin.x + iconWidth + bubbleContentSize.width * self.proportionOfSpace
                titleFrame.origin.y = baseY + (bubbleContentSize.height - titleHeight) / 2
            
                break
            case .iconRightTitleLeft:
                //  图标+文本宽度
                let contentWidth : CGFloat = iconWidth + bubbleContentSize.width * self.proportionOfSpace + titleWidth
                //  水平居中，文本X坐标
                titleFrame.origin.x = baseX + (bubbleContentSize.width - contentWidth) / 2
                titleFrame.origin.y = baseY + (bubbleContentSize.height - titleHeight) / 2
                //  由文本坐标求出图标坐标
                iconFrame.origin.x = titleFrame.origin.x + titleFrame.size.width + bubbleContentSize.width * self.proportionOfSpace
                iconFrame.origin.y = baseY + (bubbleContentSize.height - iconWidth) / 2

                break
            case .iconOnly:
                titleFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
                iconFrame.origin.x = baseX + (bubbleContentSize.width - iconWidth) / 2
                iconFrame.origin.y = baseY + (bubbleContentSize.height - iconWidth) / 2
            
                break
            case .titleOnly:
                titleFrame.origin.x = baseX + (bubbleContentSize.width - titleWidth) / 2
                titleFrame.origin.y = baseY + (bubbleContentSize.height - titleHeight) / 2
                iconFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
            
                break
            }
        
        iconView.frame = iconFrame
        titleView.frame = titleFrame
        
    }
    
    
}

