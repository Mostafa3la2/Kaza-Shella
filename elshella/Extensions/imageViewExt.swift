//
//  imageViewExt.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/13/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation

let imageCache = NSCache<AnyObject, UIImage>()
extension UIImageView{
    func loadImageUsingCacheWithUrlString(urlString:String){
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject){
            print("wow this actually works!")
            self.image = cachedImage
            return
        }
        
        let url = URL(string:urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data:data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
                
                
            }
            
            }.resume()
    }
}
