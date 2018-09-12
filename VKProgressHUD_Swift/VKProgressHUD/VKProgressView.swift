//
//  VKProgressView.swift
//  VKOOY_iOS
//
//  Created by Mike on 18/9/10.
//  E-mail:vkooys@163.com
//  Copyright © 2018年 VKOOY. All rights reserved.
//

import Foundation
import UIKit

private var VKProgressViewShareInstance = VKProgressView()

let bubble_width: CGFloat = 180.0               //  控件的宽度
let bubble_height: CGFloat = 120.0              //  控件的高度
let bubble_icon_width: CGFloat = 60.0           //  控件中的图标边长
let bubble_padding: CGFloat = 17.0              //  控件的顶部内边距，即图标距离顶部的长度
let bubble_icon_title_space: CGFloat = 0.0      //  控件中图标和标题的空隙


class VKProgressView : UIView {
    
    //  进度属性
    var progress : CGFloat = 0.0{
        didSet {
            if (self.currentInfo?.onProgressChanged != nil){
                
                DispatchQueue.main.async(execute: {
                    self.currentInfo?.onProgressChanged!(self.currentDrawLayer!, self.progress)
                })
            }
        }
    }
    
    var iconImageView : UIImageView?
    
    var titleLabel : UILabel?
    //  是否正在显示中
    var isShowing : Bool = false
    var infoDic = Dictionary<String, VKProgressInfo>()
    //  当前正在显示的信息对象
    var currentInfo : VKProgressInfo?
    //  当前自定义动画绘图的图层
    var currentDrawLayer : CAShapeLayer?
    //  当前使用的图片帧动画计时器
    var currentTimer : Timer?
    //  蒙版view
    var maskVieww : UIView?
    //  关闭验证key，用来做关闭时候的延迟验证，当设置自动关闭之后，若在关闭之前出发了显示其他info的bubble，通过修改这个值保证不关闭其他样式的infoProgress
    var closeKey : CGFloat = 0.0
    //  帧动画播放的下标索引
    var frameAnimationPlayIndex : NSInteger = 0

    
    
    /**
     *  单例方法
     */
    class var sharedInstance : VKProgressView {
        return VKProgressViewShareInstance
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //do something what you want
        let keyWindow : UIWindow = ((UIApplication.shared.delegate?.window)!)!
        
        self.frame = CGRect.init(x: keyWindow.center.x, y: keyWindow.center.y, width: 0, height: 0)
        self.clipsToBounds = true
        
        self.iconImageView = UIImageView.init()
        self.iconImageView?.clipsToBounds = true
        self.titleLabel = UILabel.init()
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.5
        self.titleLabel?.lineBreakMode = .byCharWrapping
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.numberOfLines = 0
        self.maskVieww = UIView.init(frame: UIScreen.main.bounds)
        self.maskVieww?.isHidden = true

        self.addSubview(self.iconImageView!)
        self.addSubview(self.titleLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     *  注册信息对象
     */
    func registerInfo(info: VKProgressInfo, key: String) ->Void {
        self.infoDic[key] = info
    }
    
    /**
     *  显示指定的信息模型对应的控件
     */
    func showWithInfo(info: VKProgressInfo) -> Void {
        self.currentInfo = info
        self.closeKey = (self.currentInfo?.key)!    //  保存当前要关闭的key，防止关闭不需要关闭的Progress
        
        // 防止使用Storyboard的时候keywindow为nil
        let mWindow : UIWindow = ((UIApplication.shared.delegate?.window)!)!

        if info.isShowMaskView {
            mWindow.addSubview(self.maskVieww!)
            mWindow.addSubview(self)
        }
        //  弹簧动画改变外观
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            if (self.currentDrawLayer != nil) {
                self.currentDrawLayer!.removeFromSuperlayer()
            }

            self.frame = info.calBubbleViewFrame()
            self.titleLabel?.text = info.title
            self.titleLabel?.font = UIFont.systemFont(ofSize: info.titleFontSize)
            info.calIconView(iconView: self.iconImageView!, titleView: self.titleLabel!)
            self.layer.cornerRadius = info.cornerRadius


            if info.iconArray == nil || info.iconArray?.count == 0 {
                // 显示自定义动画
                if ((info.iconAnimation) != nil) {
                    self.iconImageView?.image = UIImage.init()
                    self.currentDrawLayer = CAShapeLayer.init()
                    self.currentDrawLayer?.fillColor = UIColor.clear.cgColor
                    self.currentDrawLayer?.frame = (self.iconImageView?.bounds)!
                    self.iconImageView?.layer.addSublayer(self.currentDrawLayer!)
                    self.currentTimer?.invalidate()
                    
                    DispatchQueue.main.async(execute: {
                        info.iconAnimation!(self.currentDrawLayer!)
                    })
                }
            } else if  info.iconArray?.count == 1 {  //  显示单张图片
                self.currentTimer?.invalidate()
                self.iconImageView?.image = info.iconArray?[0]
            } else {    //  逐帧连环动画
                self.frameAnimationPlayIndex = 0   //  帧动画播放索引归零
                self.iconImageView?.image = self.currentInfo?.iconArray![0]
                
                self.currentTimer = Timer.scheduledTimer(timeInterval: TimeInterval(info.frameAnimationTime), target: self, selector: #selector(self.frameAnimationPlayer), userInfo: nil, repeats: true)
            }
        
            // maskVieww
            if (self.currentInfo?.isShowMaskView)! && (self.maskVieww?.isHidden)! {
                // 本次需要显示，但是之前已经隐藏
                self.maskVieww?.alpha = 0
                self.maskVieww?.isHidden = false
            }
            self.maskVieww?.alpha = (self.currentInfo?.isShowMaskView)! ? 1 : 0
            
        }) { (bool) in
            if bool {
                if(!(self.currentInfo?.isShowMaskView)!){
                    self.maskVieww?.isHidden = true
                    self.maskVieww?.removeFromSuperview()
                }
            }
        }
        
        UIView.animate(withDuration: 0.45, delay: 0, options: .transitionCurlUp, animations: {
            
            self.titleLabel?.textColor = info.titleColor
            self.backgroundColor = info.backgroundColor
            self.currentDrawLayer?.strokeColor = info.iconColor?.cgColor
            self.maskVieww?.backgroundColor = self.currentInfo?.maskColor
            self.alpha = 1
            
        }) { (bool) in
            
        }
        
    }
    
    /**
     *  帧动画播放器 - Timer调用
     */
    @objc func frameAnimationPlayer() -> Void {
        self.iconImageView?.image = self.currentInfo?.iconArray![self.frameAnimationPlayIndex]
        self.frameAnimationPlayIndex = (self.frameAnimationPlayIndex + 1) % (self.currentInfo?.iconArray?.count)!
    }
    
    /**
     *  通过传入键来显示已经注册的指定样式控件
     */
    func showWithInfoKey(infoKey: String) -> Void {
        if self.infoDic.keys.contains(infoKey) {
            self.showWithInfo(info: self.infoDic[infoKey]!)
        }
    }
    
    /**
     *  显示指定的信息模型对应的控件，并指定的时间后隐藏
     */
    func showWithInfo(info: VKProgressInfo, autoCloseTime: CGFloat) -> Void {
        self.showWithInfo(info: info)
        self.perform(#selector(hide), with: self, afterDelay: TimeInterval(autoCloseTime + 0.2))
    }
    
    /**
     *  显示指定的信息模型对应的控件，并指定的时间后隐藏
     */
    func showWithInfoKey(infoKey: String, autoCloseTime: CGFloat) -> Void {
        if self.infoDic.keys.contains(infoKey) {
            self.showWithInfo(info: self.infoDic[infoKey]!, autoCloseTime: autoCloseTime)
        }
    }
    
    /**
     *  定时隐藏当前控件
     */
    func hideWithCloseTime(time: CGFloat) -> Void {
        self.perform(#selector(hide), with: self, afterDelay: TimeInterval(time))
    }
    
    /**
     *  隐藏当前控件
     */
    @objc func hide() -> Void {
        if self.closeKey == self.currentInfo?.key {  //  要关闭的key没有变化，可以关闭
            //  动画缩放，更改透明度使其动画隐藏
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                
                self.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                self.maskVieww?.alpha = 0
                self.alpha = 0
                //  记得把定时器停了
                self.currentTimer?.invalidate()
                
            }) { (bool) in
                if bool {
                    //  从父层控件中移除
                    self.removeFromSuperview()
                    self.maskVieww?.removeFromSuperview()
                }
            }
            
        }
    }
    
    
}



