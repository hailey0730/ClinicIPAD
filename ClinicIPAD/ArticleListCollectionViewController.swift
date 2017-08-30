//
//  ArticleListCollectionViewController.swift
//  ClinicIPAD
//
//  Created by AsiaMac on 28/8/2017.
//  Copyright © 2017年 AsiaMac. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "ArticleListCollectionViewCell"
private let sectionInsets = UIEdgeInsets(top:20.0, left: 100.0, bottom: 20.0, right: 100.0)
fileprivate let itemsPerRow : CGFloat = 3
var articleTag = Int()

struct HealthPage{
    var banner: String
    init(banner:String){
        self.banner = banner
    }
}

struct ArticleObj{
    
    var banner: String
    var image: String
    var content: String
    var thumbnail: String
    var title: String
    var tag: Int
    
    init(banner: String, image: String, content: String, thumbnail: String, title: String, tag: Int){
        self.banner = banner
        self.image = image
        self.content = content
        self.thumbnail = thumbnail
        self.title = title
        self.tag = tag
    }
    
}

var articles = [ArticleObj]()
var healthPage = [HealthPage]()

class ArticleListCollectionViewController: UICollectionViewController {



    override func viewDidLoad() {
        super.viewDidLoad()

        healthPage.append(HealthPage(banner: "http://www.chatbot.hk/Image/ClinicPad/health_banner.png"))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes        //for some reason, this case should not register cell and reusableView, else IBOutlets will be nil and can't be accessed
//        self.collectionView?.register(ArticleListCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        self.collectionView?.register(ArticleListCollectionReusableView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "ArticleListCollectionReusableView")
        
        // Do any additional setup after loading the view.
        self.loadFromFB()
        collectionView?.reloadData()
        Timer.scheduledTimer(timeInterval: 90.0, target: self, selector: #selector(self.timeToMoveOn), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ArticleListCollectionViewCell else{
            fatalError("Wrong cell class dequeued")
        }
    
        // Configure the cell
        let article = articles[indexPath.row]
        if(cell.article1) != nil {
            cell.getImage(imageUrl: article.thumbnail, imgView: cell.article1Img)
            
            cell.article1.tag = articles[indexPath.row].tag
            cell.article1.addTarget(self, action: #selector(ArticleListCollectionViewController.clicked(_:)), for: .touchUpInside)
        }
        
       return cell
    }

    override func collectionView(_ collectionView:UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath)-> UICollectionReusableView{
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind:kind, withReuseIdentifier: "ArticleListCollectionReusableView", for: indexPath) as! ArticleListCollectionReusableView
        
        if (reusableView.healthText) != nil {
            print(healthPage[0].banner)
            reusableView.getImage(imgageUrl: healthPage[0].banner, imgView: reusableView.healthTopImg)
        }
        
        return reusableView
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    //==========================================
    
    @IBAction func clicked(_ sender: UIButton){
        articleTag = sender.tag
        self.performSegue(withIdentifier: "healthToArticle", sender: self)
    }
    
    private func loadFromFB(){
        articles.removeAll()
        var ref: DatabaseReference!
        ref = Database.database().reference().child("health")
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject]
            let topImg = postDict?["BannerURL"] as! String
            let hpage = HealthPage(banner: topImg)
            healthPage[0] = hpage
            
            var i = 0
            let articleRef = Database.database().reference().child("health").child("Article")
            articleRef.observe(DataEventType.value, with: { firDataSnapshot in
                if firDataSnapshot.childrenCount > 0{
                    for Article in firDataSnapshot.children.allObjects as! [DataSnapshot]{
                        
                        let articleObj = Article.value as! [String: AnyObject]
                        let ban = articleObj["BannerURL"] as! String
                        let cont = articleObj["Content"] as! String
                        let img = articleObj["ImageURL"] as! String
                        let thumb = articleObj["ThumbnailURL"] as! String
                        let artTitle = articleObj["Title"] as! String
                        
                        let article = ArticleObj(banner: ban, image: img, content: cont, thumbnail: thumb, title: artTitle, tag: i)
                        
                        articles.append(article)
                        DispatchQueue.main.async{
                           self.collectionView?.reloadData()
                        }
                        
                        i+=1
                        
                    }
                    
                }
                
            })
            
        })
    }
    
    @objc private func timeToMoveOn() {
        self.performSegue(withIdentifier: "healthBackHome", sender: self)
        
    }

}

extension ArticleListCollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int)-> CGSize {
        return CGSize(width: 1024, height: 262)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)->CGSize{
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
//         return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int)-> UIEdgeInsets{
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int)-> CGFloat{
        return sectionInsets.left
    }
}


