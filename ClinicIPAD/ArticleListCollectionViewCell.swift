//
//  ArticleListCollectionViewCell.swift
//  ClinicIPAD
//
//  Created by AsiaMac on 28/8/2017.
//  Copyright © 2017年 AsiaMac. All rights reserved.
//

import UIKit

class ArticleListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var article1: UIButton!
    @IBOutlet weak var article1Img: UIImageView!
    
    private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
func getImage(imageUrl: String, imgView: UIImageView){
    if let checkedUrl = URL(string: imageUrl ) {
        imgView.contentMode = .scaleAspectFit
        self.getDataFromUrl(url: checkedUrl) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                imgView.image = UIImage(data: data)
            }
        }
    }
    
}

   
}
