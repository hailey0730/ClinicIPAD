//
//  IntroViewController.swift
//  ClinicIPAD
//
//  Created by AsiaMac on 16/8/2017.
//  Copyright © 2017年 AsiaMac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase


class IntroViewController: UIViewController {
    @IBOutlet weak var introTop: UIImageView!
    @IBOutlet weak var intro: UIImageView!
    @IBOutlet weak var introContent: UIImageView!
    @IBOutlet weak var service: UIImageView!
    @IBOutlet weak var serviceContent: UIImageView!
    @IBOutlet weak var fee: UIImageView!
    @IBOutlet weak var feeContent: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadPage()
        
//        self.reset_idle_timer()
         Timer.scheduledTimer(timeInterval: 90.0, target: self, selector: #selector(self.timeToMoveOn), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func sendEvent( event: UIEvent )
//    {
//        super.sendEvent( event )
//        
//        if let all_touches = event.allTouches() {
//            if ( all_touches.count > 0 ) {
//                let phase = (all_touches.anyObject() as UITouch).phase
//                if phase == UITouchPhase.Began {
//                    reset_idle_timer()
//                }
//            }
//        }
//    }
//    
//    private func reset_idle_timer()
//    {
//        cancel_delay( idle_timer )
//        idle_timer = delay( g_secs ) { self.idle_timer_exceeded() }
//    }
//    
//    func idle_timer_exceeded()
//    {
//        println( "Ring ----------------------- Do some Idle Work!" )
//        reset_idle_timer()
//    }
    
    //=======================================
    
    private func loadPage(){
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("clinic")
        
        ref.observe(DataEventType.value, with: {(snapshot) in
            let postDict = snapshot.value as? [String: AnyObject]
            let top = postDict?["BannerURL"]
            let intro = postDict?["IntroLogoURL"]
            let introContent = postDict?["IntroURL"]
            let service = postDict?["ServiceLogoURL"]
            let serviceContent = postDict?["ServiceURL"]
            let fee = postDict?["FeeLogoURL"]
            let feeContent = postDict?["FreeURL"]
            
            self.getImage(imgageUrl: top as! String, imgView: self.introTop)
            self.getImage(imgageUrl: intro as! String, imgView: self.intro)
            self.getImage(imgageUrl: introContent as! String, imgView: self.introContent)
            self.getImage(imgageUrl: service as! String, imgView: self.service)
            self.getImage(imgageUrl: serviceContent as! String, imgView: self.serviceContent)
            self.getImage(imgageUrl: fee as! String, imgView: self.fee)
            self.getImage(imgageUrl: feeContent as! String, imgView: self.feeContent)
            
        })

    }
    
    private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    private func getImage(imgageUrl: String, imgView: UIImageView){
        if let checkedUrl = URL(string: imgageUrl ) {
            if imgView == self.introTop{
                imgView.contentMode = .scaleAspectFill
            }else{
                imgView.contentMode = .scaleToFill
            }
            
            self.getDataFromUrl(url: checkedUrl) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { () -> Void in
                    imgView.image = UIImage(data: data)
                }
            }
        }
        
    }
    
    @objc private func timeToMoveOn() {
        self.performSegue(withIdentifier: "backHome", sender: self)
        
    }
}
