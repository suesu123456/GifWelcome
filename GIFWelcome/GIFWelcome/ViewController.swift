//
//  ViewController.swift
//  GIFWelcome
//
//  Created by sue on 15/10/15.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit
import AVFoundation

enum currentStatus {
    case freeStatus
    case loginStatus
    case signupStatus
}

class ViewController: UIViewController {

    var status: currentStatus = .freeStatus

    var player: AVPlayer!
    var cardView: CardView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var regBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        self.createVideoPlayer()
        self.setTwoButton()
        self.createShowAnim()
        self.addCardView()
        //键盘弹出
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChangeFrame:"), name: UIKeyboardWillChangeFrameNotification ,object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createVideoPlayer() {
        let filePath: String = NSBundle.mainBundle().pathForResource("welcome_video", ofType: "mp4")!
        let url: NSURL = NSURL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(URL: url)
        //playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        
        self.player = AVPlayer(playerItem: playerItem)
        self.player.volume = 0

        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.frame = self.playerView.layer.bounds
        self.playerView.layer.addSublayer(playerLayer)
        
        self.player.play()
        
        self.player.currentItem?.addObserver(self, forKeyPath: AVPlayerItemDidPlayToEndTimeNotification, options: NSKeyValueObservingOptions.New,context: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("moviePlayDidEnd"), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player.currentItem)
    }
    //循环播放
    func moviePlayDidEnd(notification: NSNotification) {
        let item = notification.object
        item?.seekToTime(kCMTimeZero)
        self.player.play()
    }
    //点击按钮设置
    func setTwoButton() {
        setBorder(self.loginBtn)
        setBorder(self.regBtn)
    }
    func setBorder(btn: UIButton) {
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = UIColor.whiteColor().CGColor
        btn.layer.borderWidth = 1
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor.clearColor()
    }
    //动画
    func createShowAnim() {
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.duration = 3.0
        self.loginBtn.layer.addAnimation(anim, forKey: "alpha")
        self.regBtn.layer.addAnimation(anim, forKey: "alpha")
        
        let keyAnim = CAKeyframeAnimation(keyPath: "opacity")
        keyAnim.duration = 5.0
        keyAnim.values = [0, 1, 0]
        keyAnim.keyTimes = [0, 0.35, 1.0]
        self.titleLabel.layer.addAnimation(keyAnim, forKey: "opacity")
        
    }
    func addCardView() {
        self.cardView = CardView()
        self.cardView.center = CGPointMake(CGRectGetMidX(self.view.bounds), -CGRectGetMidY(self.cardView.bounds))
        self.view.addSubview(self.cardView)
    
    }
    
    func showCardView() {
        UIView.animateWithDuration(1.0) { () -> Void in
            self.cardView.center = CGPointMake(self.cardView.center.x, self.cardView.center.y + 500)
        }
    }
    //解决键盘弹出遮盖textField
    func keyboardWillChangeFrame(notification: NSNotification){
        let info: NSDictionary = notification.userInfo!
        let beginKeyboardRect = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue
        let endKeyboardRect = info.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue
        
        let yOffset = (endKeyboardRect?.origin.y)! - (beginKeyboardRect?.origin.y)!
        for subview in self.view.subviews {
            if subview.isEqual(self.playerView) || subview.isEqual(self.titleLabel){
                continue
            }
            var frame = subview.frame
            frame.origin.y += yOffset
            subview.frame = frame
        }
        
    }

   
    @IBAction func loginClick(sender: AnyObject) {
        transitionToNewStatus(currentStatus.loginStatus)
    }
    @IBAction func signClick(sender: AnyObject) {
    }
    
    func transitionToNewStatus(newStatus: currentStatus) {
        showCardView()
        
    }
    
    
}

