# VKProgressHUD_Swift
VKProgressHUD_Swift

#### Image
![image](https://github.com/VKOOY/VKProgressHUD_Swift/blob/master/VKProgressHUD.gif)

#### Use
```
    /**
     *  Success
     */
    self.showRightWithTitle(title: "这是一个成功的提示", autoCloseTime: 2)
    
    /**
     *  Fail
     */
    self.showErrorWithTitle(title: "这是一个失败的提示", autoCloseTime: 2)
    
    /**
     *  Wait
     */
    self.showRoundProgressWithTitle(title: "请求中...")
        
    DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(2)) {
        self.showRightWithTitle(title: "请求成功", autoCloseTime: 1)
    }
    
    /**
     *  Bottom
     */
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
    
    /**
     *  ppt
     */
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
    
    /**
     *  customIcon
     */
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
    
```

