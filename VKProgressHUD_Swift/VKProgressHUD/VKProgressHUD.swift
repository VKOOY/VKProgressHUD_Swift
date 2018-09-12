//
//  VKProgressHUD.swift
//  VKOOY_iOS
//
//  Created by Mike on 18/9/10.
//  E-mail:vkooys@163.com
//  Copyright © 2018年 VKOOY. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {

    /**
     *  获取默认的显示成功的信息对象，可以在此基础之上自定义
     */
    func getDefaultRightBubbleInfo() -> VKProgressInfo {
        
        let info = VKProgressInfo.init()
        
        info.iconAnimation = {(layer:CAShapeLayer) in
            let STROKE_WIDTH : CGFloat = 3.0
            
            //  绘制外部透明的圆形
            let circlePath = UIBezierPath()
            circlePath.addArc(withCenter: CGPoint.init(x: layer.frame.size.width / 2, y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - STROKE_WIDTH, startAngle: 0 * CGFloat.pi/180, endAngle: 360 * CGFloat.pi/180, clockwise: false)
            //  创建外部透明圆形的图层
            let alphaLineLayer = CAShapeLayer.init()
            //  设置透明圆形的绘图路径
            alphaLineLayer.path = circlePath.cgPath
            //  设置图层的透明圆形的颜色
            alphaLineLayer.strokeColor = UIColor(cgColor: layer.strokeColor!).withAlphaComponent(0.1).cgColor
            //  设置圆形的线宽
            alphaLineLayer.lineWidth = STROKE_WIDTH
            //  填充颜色透明
            alphaLineLayer.fillColor = UIColor.clear.cgColor
            //  把外部半透明圆形的图层加到当前图层上
            layer.addSublayer(alphaLineLayer)

            //  设置当前图层的绘制属性
            layer.fillColor = UIColor.clear.cgColor
            layer.lineCap = kCALineCapRound    //  圆角画笔
            layer.lineWidth = STROKE_WIDTH
            
            //  半圆+动画的绘制路径初始化
            let path = UIBezierPath()
            //  绘制大半圆
            path.addArc(withCenter: CGPoint.init(x: layer.frame.size.width / 2, y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - STROKE_WIDTH, startAngle: 67 * CGFloat.pi/180, endAngle: -158 * CGFloat.pi/180, clockwise: false)
            //  绘制对号第一笔
            path.addLine(to: CGPoint.init(x: layer.frame.size.width * 0.42, y: layer.frame.size.width * 0.68))
            //  绘制对号第二笔
            path.addLine(to: CGPoint.init(x: layer.frame.size.width * 0.75, y: layer.frame.size.width * 0.35))
            //  把路径设置为当前图层的路径
            layer.path = path.cgPath
            
            let timing = CAMediaTimingFunction.init(controlPoints: 0.3, 0.6, 0.8, 1.1)
            //  创建路径顺序绘制的动画
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 0.5       //  动画使用时间
            animation.fromValue = NSNumber.init(value: 0.0)     //  从头
            animation.toValue = NSNumber.init(value: 1.0)       //  画到尾
            
            //  创建路径顺序从结尾开始消失的动画
            let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
            strokeStartAnimation.duration = 0.4    //  动画使用时间
            strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.2    //  延迟0.2秒执行动画
            strokeStartAnimation.fromValue = NSNumber.init(value: 0.0)   // 从开始消失
            strokeStartAnimation.toValue = NSNumber.init(value: 0.74)    //  一直消失到整个绘制路径的74%，这个数没有啥技巧，一点点调试看效果，希望看此代码的人不要被这个数值怎么来的困惑
            strokeStartAnimation.timingFunction = timing
            layer.strokeStart = 0.74    //  设置最终效果，防止动画结束之后效果改变
            layer.strokeEnd = 1.0
            
            layer.add(animation, forKey: "strokeEnd")
            layer.add(strokeStartAnimation, forKey: "strokeStart")
        }
        
        info.title = "成功"
        info.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        info.iconColor = UIColor.init(red: 0 / 255.0, green: 205 / 255.0, blue: 0, alpha: 1)
        info.titleColor = UIColor.black
//        info.layoutStyle = .iconLeftTitleRight
        info.bubbleSize = CGSize.init(width: 200, height: 130)
   
        return info
    }
    
    /**
     *  展示一个带对号的提示信息
     */
    func showRightWithTitle(title: String, autoCloseTime: CGFloat) -> Void {
        let info: VKProgressInfo = self.getDefaultRightBubbleInfo()
        info.title = title
        VKProgressView.sharedInstance.showWithInfo(info: info, autoCloseTime: autoCloseTime)
    }
    
    /**
     *  获取默认的显示加载中的信息对象，可以在此基础之上自定义
     */
    func getDefaultRoundProgressBubbleInfo() -> VKProgressInfo {
        let info = VKProgressInfo.init()
        
        info.iconAnimation = {(layer:CAShapeLayer) in
            let STROKE_WIDTH : CGFloat = 3.0
            
            //  绘制外部透明的圆形
            let circlePath = UIBezierPath()
            circlePath.addArc(withCenter: CGPoint.init(x: layer.frame.size.width / 2, y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - STROKE_WIDTH, startAngle: 0 * CGFloat.pi/180, endAngle: 360 * CGFloat.pi/180, clockwise: false)
            //  创建外部透明圆形的图层
            let alphaLineLayer = CAShapeLayer.init()
            //  设置透明圆形的绘图路径
            alphaLineLayer.path = circlePath.cgPath
            //  设置图层的透明圆形的颜色
            alphaLineLayer.strokeColor = UIColor(cgColor: layer.strokeColor!).withAlphaComponent(0.1).cgColor
            //  设置圆形的线宽
            alphaLineLayer.lineWidth = STROKE_WIDTH
            //  填充颜色透明
            alphaLineLayer.fillColor = UIColor.clear.cgColor
            //  把外部半透明圆形的图层加到当前图层上
            layer.addSublayer(alphaLineLayer)
            
            
            let drawLayer = CAShapeLayer()
            let progressPath = UIBezierPath()
            progressPath.addArc(withCenter: CGPoint.init(x: layer.frame.size.width / 2, y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - STROKE_WIDTH, startAngle: 0 * CGFloat.pi/180, endAngle: 360 * CGFloat.pi/180, clockwise: true)
            
            drawLayer.lineWidth = STROKE_WIDTH
            drawLayer.fillColor = UIColor.clear.cgColor
            drawLayer.path = progressPath.cgPath
            drawLayer.frame = drawLayer.bounds
            drawLayer.strokeColor = layer.strokeColor
            layer.addSublayer(drawLayer)
            
            let progressRotateTimingFunction = CAMediaTimingFunction.init(controlPoints: 0.25, 0.80, 0.75, 1.0)
            //  开始划线的动画
            let progressLongAnimation = CABasicAnimation(keyPath: "strokeEnd")
            progressLongAnimation.isRemovedOnCompletion = false
            progressLongAnimation.fromValue = NSNumber.init(value: 0.0)
            progressLongAnimation.toValue = NSNumber.init(value: 1.0)
            progressLongAnimation.duration = 2
            progressLongAnimation.timingFunction = progressRotateTimingFunction
            progressLongAnimation.repeatCount = 10000
            
            //  线条逐渐变短收缩的动画
            let progressLongEndAnimation = CABasicAnimation(keyPath: "strokeStart")
            progressLongEndAnimation.isRemovedOnCompletion = false
            progressLongEndAnimation.fromValue = NSNumber.init(value: 0.0)
            progressLongEndAnimation.toValue = NSNumber.init(value: 1.0)
            progressLongEndAnimation.duration = 2
            let strokeStartTimingFunction = CAMediaTimingFunction.init(controlPoints: 0.65, 0.0, 1.0, 1.0)
            progressLongEndAnimation.timingFunction = strokeStartTimingFunction
            progressLongEndAnimation.repeatCount = 10000
            
            //  线条不断旋转的动画
            let progressRotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            progressRotateAnimation.isRemovedOnCompletion = false
            progressRotateAnimation.fromValue = NSNumber.init(value: 0.0)
            progressRotateAnimation.toValue = NSNumber.init(value: (Float.pi / 180 * 360))
            progressRotateAnimation.repeatCount = 1000000
            progressRotateAnimation.duration = 6
            
            
            drawLayer.add(progressLongAnimation, forKey: "strokeEnd")
            layer.add(progressRotateAnimation, forKey: "transfrom.rotation.z")
            drawLayer.add(progressLongEndAnimation, forKey: "strokeStart")
        }
        
        info.title = "请稍候..."
        info.bubbleSize = CGSize.init(width: 140, height: 120)
        info.maskColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.4)
        info.backgroundColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.8)
        
        return info
    }
    
    /**
     *  展示一个圆形的无限循环的进度条
     */
    func showRoundProgressWithTitle(title: String) -> Void {
        let info: VKProgressInfo = self.getDefaultRoundProgressBubbleInfo()
        info.title = title
        VKProgressView.sharedInstance.showWithInfo(info: info)
    }
    
    /**
     *  获取默认的显示错误的信息对象，可以在此基础之上自定义
     */
    func getDefaultErrorBubbleInfo() -> VKProgressInfo {
        let info = VKProgressInfo.init()
        
        info.iconAnimation = {(layer:CAShapeLayer) in
            let STROKE_WIDTH : CGFloat = 3.0
            
            //  绘制外部透明的圆形
            let circlePath = UIBezierPath()
            circlePath.addArc(withCenter: CGPoint.init(x: layer.frame.size.width / 2, y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - STROKE_WIDTH, startAngle: 0 * CGFloat.pi/180, endAngle: 360 * CGFloat.pi/180, clockwise: false)
            //  创建外部透明圆形的图层
            let alphaLineLayer = CAShapeLayer.init()
            //  设置透明圆形的绘图路径
            alphaLineLayer.path = circlePath.cgPath
            alphaLineLayer.strokeColor = UIColor(cgColor: layer.strokeColor!).withAlphaComponent(0.1).cgColor
            //  ↑ 设置图层的透明圆形的颜色，取图标颜色之后设置其对应的0.1透明度的颜色
            alphaLineLayer.lineWidth = STROKE_WIDTH     //  设置圆形的线宽
            alphaLineLayer.fillColor = UIColor.clear.cgColor    //  填充颜色透明
            layer.addSublayer(alphaLineLayer)       //  把外部半透明圆形的图层加到当前图层上
            
            //  开始画叉的两条线，首先画逆时针旋转的线
            let leftLayer = CAShapeLayer.init()
            //  设置当前图层的绘制属性
            leftLayer.frame = layer.bounds
            leftLayer.fillColor = UIColor.clear.cgColor
            leftLayer.lineCap = kCALineCapRound    //  圆角画笔
            leftLayer.lineWidth = STROKE_WIDTH
            leftLayer.strokeColor = layer.strokeColor
            
            //  半圆+动画的绘制路径初始化
            let leftPath = UIBezierPath()
            //  绘制大半圆
            leftPath.addArc(withCenter: CGPoint.init(x: layer.frame.size.width / 2, y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - STROKE_WIDTH, startAngle: -43 * CGFloat.pi/180, endAngle: -315 * CGFloat.pi/180, clockwise: false)
            leftPath.addLine(to: CGPoint.init(x: layer.frame.size.width * 0.35, y: layer.frame.size.width * 0.35))
            //  把路径设置为当前图层的路径
            leftLayer.path = leftPath.cgPath
            layer.addSublayer(leftLayer)
            
            //  逆时针旋转的线
            let rightLayer = CAShapeLayer.init()
            //  设置当前图层的绘制属性
            rightLayer.frame = layer.bounds
            rightLayer.fillColor = UIColor.clear.cgColor
            rightLayer.lineCap = kCALineCapRound       //  圆角画笔
            rightLayer.lineWidth = STROKE_WIDTH
            rightLayer.strokeColor = layer.strokeColor
            
            //  半圆+动画的绘制路径初始化
            let rightPath = UIBezierPath()
            //  绘制大半圆
            rightPath.addArc(withCenter: CGPoint.init(x: layer.frame.size.width / 2, y: layer.frame.size.height / 2), radius: layer.frame.size.width / 2 - STROKE_WIDTH, startAngle: -128 * CGFloat.pi/180, endAngle: 133 * CGFloat.pi/180, clockwise: true)
           rightPath.addLine(to: CGPoint.init(x: layer.frame.size.width * 0.65, y: layer.frame.size.width * 0.35))
            //  把路径设置为当前图层的路径
            rightLayer.path = rightPath.cgPath
            layer.addSublayer(rightLayer)
            
            
            let timing = CAMediaTimingFunction.init(controlPoints: 0.3, 0.6, 0.8, 1.1)
            //  创建路径顺序绘制的动画
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 0.5    //  动画使用时间
            animation.fromValue = NSNumber.init(value: 0.0)        //  从头
            animation.toValue = NSNumber.init(value: 1.0)          //  画到尾
            //  创建路径顺序从结尾开始消失的动画
            let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
            strokeStartAnimation.duration = 0.4    //  动画使用时间
            strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.2    //  延迟0.2秒执行动画
            strokeStartAnimation.fromValue = NSNumber.init(value: 0.0)   // 从开始消失
            strokeStartAnimation.toValue = NSNumber.init(value: 0.84)    //  一直消失到整个绘制路径的84%，这个数没有啥技巧，一点点调试看效果，希望看此代码的人不要被这个数值怎么来的困惑
            strokeStartAnimation.timingFunction = timing
            
            leftLayer.strokeStart = 0.84   //  设置最终效果，防止动画结束之后效果改变
            leftLayer.strokeEnd = 1.0
            rightLayer.strokeStart = 0.84  //  设置最终效果，防止动画结束之后效果改变
            rightLayer.strokeEnd = 1.0
            
            
            leftLayer.add(animation, forKey: "strokeEnd")   //  添加俩动画
            leftLayer.add(strokeStartAnimation, forKey: "strokeStart")
            rightLayer.add(animation, forKey: "strokeEnd")
            rightLayer.add(strokeStartAnimation, forKey: "strokeStart")
        }
        
        info.title = "发生了一个错误"
        info.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        info.iconColor = UIColor.init(red: 255 / 255.0, green: 48 / 255.0, blue: 48 / 255.0, alpha: 1)
        info.titleColor = UIColor.black
        info.layoutStyle = .iconTopTitleBottom
        info.bubbleSize = CGSize.init(width: 200, height: 130)
        return info
    }
    
    /**
     *  展示一个带错误X的提示信息
     */
    func showErrorWithTitle(title: String, autoCloseTime: CGFloat) -> Void {
        let info: VKProgressInfo = self.getDefaultErrorBubbleInfo()
        info.title = title
        VKProgressView.sharedInstance.showWithInfo(info: info, autoCloseTime: autoCloseTime)
    }
    
    /**
     *  隐藏现在显示的控件
     */
    func hideBubble() -> Void {
        VKProgressView.sharedInstance.hide()
    }

    /**
     *  定时隐藏现在显示的控件
     */
    func hideBubbleAfter(duration: CGFloat) -> Void {
        VKProgressView.sharedInstance.hideWithCloseTime(time: duration)
    }
    
    /**
     *  显示指定信息规定的控件
     */
    func showBubbleWithInfo(info: VKProgressInfo) -> Void {
        VKProgressView.sharedInstance.showWithInfo(info: info)
    }
    
    /**
     *  显示置顶的信息规定的控件，并在指定的时间后关闭
     */
    func showBubbleWithInfo(info: VKProgressInfo, time: CGFloat) -> Void {
        VKProgressView.sharedInstance.showWithInfo(info: info, autoCloseTime: time)
    }
    
    
}
