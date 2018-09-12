//
//  ViewController.swift
//  VKOOY_iOS
//
//  Created by Mike on 18/9/10.
//  E-mail:vkooys@163.com
//  Copyright © 2018年 VKOOY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white;
        
        let btn1 = UIButton(frame: CGRect.init(x: 50, y: 100, width: 120, height: 40))
        self.setButton(title: "成功的提示", action: #selector(success), button: btn1)
        
        let btn2 = UIButton(frame: CGRect.init(x: 200, y: 100, width: 120, height: 40))
        self.setButton(title: "失败的提示", action: #selector(fail), button: btn2)
        
        let btn3 = UIButton(frame: CGRect.init(x: 50, y: 150, width: 120, height: 40))
        self.setButton(title: "等待的提示", action: #selector(wait), button: btn3)
        
        let btn4 = UIButton(frame: CGRect.init(x: 200, y: 150, width: 120, height: 40))
        self.setButton(title: "底部的提示", action: #selector(bottom), button: btn4)
        
        let btn5 = UIButton(frame: CGRect.init(x: 50, y: 200, width: 120, height: 40))
        self.setButton(title: "逐帧播放的提示", action: #selector(ppt), button: btn5)
        
        let btn6 = UIButton(frame: CGRect.init(x: 200, y: 200, width: 120, height: 40))
        self.setButton(title: "自定义图标的提示", action: #selector(icon), button: btn6)
    }
    
    func setButton(title: String, action: Selector, button: UIButton) -> Void {
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor.darkGray
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    /**
     *  成功
     */
    @objc func success() -> Void {
        self.showRightWithTitle(title: "这是一个成功的提示", autoCloseTime: 2)
    }
    
    /**
     *  失败
     */
    @objc func fail() -> Void {
        self.showErrorWithTitle(title: "这是一个失败的提示", autoCloseTime: 2)
    }
    
    /**
     *  等待
     */
    @objc func wait() -> Void {
        self.showRoundProgressWithTitle(title: "请求中...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(2)) {
            self.showRightWithTitle(title: "请求成功", autoCloseTime: 1)
        }
    }
    
    /**
     *  底部
     */
    @objc func bottom() -> Void {
        let myInfo = self.getDefaultRoundProgressBubbleInfo()
        myInfo.locationStyle = .bottom
        myInfo.layoutStyle = .iconLeftTitleRight
        myInfo.title = "正在删除"
        myInfo.bubbleSize = CGSize.init(width: 200, height: 50)
        myInfo.proportionOfDeviation = 0.1
        
        self.showBubbleWithInfo(info: myInfo)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(2)) {
            self.showRightWithTitle(title: "删除成功", autoCloseTime: 2)
        }
        
    }
    
    /**
     *  逐帧播放
     */
    @objc func ppt() -> Void {
        let frameInfo = VKProgressInfo()
        
        var icons = [UIImage]()
        for i in 1...9 {
            icons.append(UIImage.init(named: "icon_hud_\(i)")!)
        }
        frameInfo.iconArray = icons
        //  在数组中依次放入多张图片即可实现多图循环播放
        frameInfo.backgroundColor = UIColor.init(red: 238 / 255.0, green: 238 / 255.0, blue: 238 / 255.0, alpha: 1)
        //  动画的帧动画播放间隔
        frameInfo.frameAnimationTime = 0.15
        frameInfo.title = "正在加载中..."
        frameInfo.titleColor = UIColor.darkGray
        VKProgressView.sharedInstance.showWithInfo(info: frameInfo)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(3)) {
            self.showErrorWithTitle(title: "加载失败", autoCloseTime: 2)
        }
    }
    
    /**
     *  自定义图标
     */
    @objc func icon() -> Void {
        let iconInfo = VKProgressInfo()
        //  把图标数组里面设置只有一张图片即可单图固定图标
        iconInfo.iconArray = [UIImage.init(named: "icon_icon")!]
        iconInfo.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        iconInfo.titleColor = UIColor.darkGray
        iconInfo.locationStyle = .top
        iconInfo.layoutStyle = .iconLeftTitleRight
        iconInfo.title = "飞行模式已开启"
        iconInfo.proportionOfDeviation = 0.05
        iconInfo.bubbleSize = CGSize.init(width: 300, height: 60)
        
        self.showBubbleWithInfo(info: iconInfo, time: 2)
    }


}

