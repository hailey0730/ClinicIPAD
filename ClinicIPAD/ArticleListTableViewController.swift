//
//  ArticleListTableViewController.swift
//  ClinicIPAD
//
//  Created by AsiaMac on 24/8/2017.
//  Copyright © 2017年 AsiaMac. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ArticleListTableViewController: UITableViewController {
    
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


//@IBOutlet weak var healthTopImage: UIImageView!
var articles = [ArticleObj]()


override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    self.loadFromFB()

    Timer.scheduledTimer(timeInterval: 90.0, target: self, selector: #selector(self.timeToMoveOn), userInfo: nil, repeats: false)
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print(self.articles.count)
    return self.articles.count
}


override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellIdentifier = "ArticleListTableViewCell"
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)as? ArticleListTableViewCell else{
        fatalError("The dequeued cell is not an instance of ClinicPadTableViewCell")
    }
    let article = self.articles[indexPath.row]
    
    //set article thumbnail
    self.getImage(imgageUrl: article.thumbnail, imgView: cell.article1.imageView!)

    print("table view reuse cell")
    return cell
}


/*
// Override to support conditional editing of the table view.
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
}
*/

/*
// Override to support editing the table view.
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
        tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }    
}
*/

/*
// Override to support rearranging the table view.
override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

}
*/

/*
// Override to support conditional rearranging of the table view.
override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
}
*/

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
}
*/

//==========================================

@IBAction func clicked(_ sender: UIButton){
    if(sender.tag == 1){
        // let artViewController = Article1ViewController(topData: artTop[0], imgData: artImg[0], contentData: artContent[0])
        //self.navigationController?.present(artViewController, animated: true, completion: nil)
        print("clicked")
        self.performSegue(withIdentifier: "Article1", sender: self)
    }else if(sender.tag == 2){
        //  let artViewController = Article1ViewController(topData: [artTop[1]], imgData: [artImg[1]], contentData: [artContent[1]])
        // self.performSegue(withIdentifier: "intro", sender: self)
    }else if(sender.tag == 3){
        //  let artViewController = Article1ViewController(topData: [artTop[2]], imgData: [artImg[2]], contentData: [artContent[2]])
        //  self.performSegue(withIdentifier: "intro", sender: self)
    }
}

private func loadFromFB(){
    
    var ref: DatabaseReference!
    ref = Database.database().reference().child("health")
    
    ref.observe(DataEventType.value, with: { (snapshot) in
        let postDict = snapshot.value as? [String : AnyObject]
        let topImg = postDict?["BannerURL"]
//                    self.getImage(imgageUrl: topImg as! String, imgView: self.healthTopImage)
        
        var i = 1
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
                    
                    self.articles.append(article)
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                    
                    i+=1
                    
                }
                
            }
            
        })
        
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
        //            if imgView == self.healthTop{
        //                imgView.contentMode = .scaleAspectFill
        //            }else{
        imgView.contentMode = .scaleAspectFit
        //            }
        self.getDataFromUrl(url: checkedUrl) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                imgView.image = UIImage(data: data)
            }
        }
    }
    
}
@objc private func timeToMoveOn() {
            self.performSegue(withIdentifier: "healthBackHome", sender: self)
    
}


}
