//
//  HomeViewController.swift
//  ClinicIPAD
//
//  Created by AsiaMac on 11/8/2017.
//  Copyright © 2017年 AsiaMac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation



class HomeViewController: UIViewController {
    
    @IBOutlet weak var showDate: UITextView!
    @IBOutlet weak var showTime: UITextView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var GMCintro: UIButton!
    @IBOutlet weak var magazine: UIButton!
    @IBOutlet weak var form: UIButton!
   
    var videoPlayer : AVPlayerViewController?
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var startUsing = false
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let displayTime = self.displayTime()
        let displayDate = self.displayDate()
        self.showTime.text = displayTime
        self.showDate.text = displayDate
       
        GMCintro.tag = 0
        magazine.tag = 1
        form.tag = 2
        
        startBtn.addTarget(self, action: #selector(HomeViewController.buttonClicked(_:)), for: .touchUpInside)
        startBtn.isHidden = true
        GMCintro.addTarget(self, action: #selector(HomeViewController.clicked(_:)), for: .touchUpInside)
        magazine.addTarget(self, action: #selector(HomeViewController.clicked(_:)), for: .touchUpInside)
        form.addTarget(self, action: #selector(HomeViewController.clicked(_:)), for: .touchUpInside)
        
//        self.playVideo();
        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.timeToMoveOn), userInfo: nil, repeats: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //==============================================================
    
    @IBAction func buttonClicked(_ sender: AnyObject?){
        startUsing = true
        //print("start btn clicked")
        
        //close the video
        self.avPlayer?.pause()
        self.avPlayer = nil
        self.avPlayerLayer?.removeFromSuperlayer()
        self.avPlayerLayer = nil
        
        //hide button
        startBtn.isHidden = true
        
    }
    
    @IBAction func clicked(_ sender: AnyObject?){
        startUsing = true
        if(startUsing == true){
            if(sender?.tag == 0){
                print("intro")
                self.performSegue(withIdentifier: "intro", sender: self)
            }else if(sender?.tag == 1){
                print("magazine")
                self.performSegue(withIdentifier: "health", sender: self)
            }else if(sender?.tag == 2){
                print("form")
                self.performSegue(withIdentifier: "form", sender: self)

            }
          
    
        }
    }
    
    
    private func playVideo() {
        startUsing = false
        startBtn.isHidden = false
        
        guard let path = Bundle.main.path(forResource: "Centrum_AD_resized22-Aug", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        avPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        avPlayer?.actionAtItemEnd = AVPlayerActionAtItemEnd(rawValue: 2)!
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.frame = self.view.bounds                             //needed to show the video
        avPlayerLayer?.frame = CGRect(x:0,y:0,width:855,height:768)       //need to be after self.view.bounds to be able to change size
        avPlayerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill     // if add Fill at the end, video fill the screen
        self.view!.layer.addSublayer(avPlayerLayer!)                  //without this, video becomes background
        self.view.transform = CGAffineTransform(scaleX:1,y:1)           //-1,1 will horizontally inverted the view
        avPlayer?.play()                                               //this auto-play the video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer?.currentItem, queue: nil, using: {(_) in
            DispatchQueue.main.async{
                self.avPlayer?.seek(to: kCMTimeZero)
                self.avPlayer?.play()
            }})
       
    }
    
    @objc private func timeToMoveOn() {
        if(startUsing == false){
            self.playVideo()
        }
        
    }
    
    private func displayTime()-> String{
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from : date)
        let minutes = calendar.component(.minute, from : date)
        var finalMin = String(minutes)
        if minutes<10{
            finalMin = "0" + String(minutes)
        }
        
        let displayTime = "\(String(hour) )\(" : ")\(finalMin)"
        
        return displayTime
    }
    
    private func displayDate()->String{
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let date0 = calendar.component(.day, from: date)
        let weekday = calendar.component(.weekday, from: date)
        
        var wd = "一"
        if weekday-1 == 0 {
            wd = "日"
        }else if weekday-1==1 {
            wd = "一"
        }else if weekday-1==2{
            wd = "二"
        }else if weekday-1==3{
            wd = "三"
        }else if weekday-1==4{
            wd = "四"
        }else if weekday-1==5{
            wd = "五"
        }else if weekday-1==6{
            wd = "六"
        }
        let displayDate = "\(String(month))\("月")\(String(date0))\("日  星期")\(wd)"
        
        return displayDate
        
    }


}

