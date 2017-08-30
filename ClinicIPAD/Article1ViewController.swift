//
//  Article1ViewController.swift
//  ClinicIPAD
//
//  Created by AsiaMac on 17/8/2017.
//  Copyright © 2017年 AsiaMac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase


class Article1ViewController: UIViewController {
    @IBOutlet weak var art1top: UIImageView!
    @IBOutlet weak var art1img: UIImageView!
    @IBOutlet weak var art1content: UITextView!
    
    
//    init(topData : String, imgData:String, contentData:String){
//        self.art1topData = topData
//        self.art1imgData = imgData 
//        self.art1contentData = contentData
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//        super.init(coder: aDecoder)
//    }
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadPage()
        Timer.scheduledTimer(timeInterval: 90.0, target: self, selector: #selector(self.timeToMoveOn), userInfo: nil, repeats: false)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //========================================
    
    private func loadPage(){
//        var articleRef: DatabaseReference!
//            var i = 1
//            articleRef = Database.database().reference().child("health").child("Article")
//            articleRef.observe(DataEventType.value, with: { firDataSnapshot in
//                if firDataSnapshot.childrenCount > 0{
//                    for Article in firDataSnapshot.children.allObjects as! [DataSnapshot]{
//                        if i == articleTag {
//                        let articleObj = Article.value as? [String: AnyObject]
//                        let banner = articleObj?["BannerURL"]
//                        let content = articleObj?["Content"]
//                        let image = articleObj?["ImageURL"]
//                                               
//                         self.getImage(imgageUrl: banner as! String, imgView: self.art1top)
//                         self.getImage(imgageUrl: image as! String, imgView: self.art1img)
//                        self.art1content.text = content as! String
//                        }else{
//                            i += 1
//                        }
//                        
//                    }
//                    
//                }
//            
//        })

        for i in 0 ... articles.count-1{
            if i == articleTag{
                let article = articles[i]
                self.getImage(imgageUrl: article.banner, imgView: self.art1top)
                self.getImage(imgageUrl: article.image, imgView: self.art1img)
                self.art1content.text = article.content
            }
        }
    }
    
    
    private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    private func getImage(imgageUrl: String, imgView: UIImageView){
        if let checkedUrl = URL(string: imgageUrl ) {
            if imgView == self.art1top{
                imgView.contentMode = .scaleAspectFill
            }else{
                imgView.contentMode = .scaleAspectFit
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
        self.performSegue(withIdentifier: "articleBackHome", sender: self)
        
    }
    
}
