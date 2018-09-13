//
//  ShellaServices.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/10/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation
import Firebase

class ShellaServices{
    
    private init(){
        
    }
    static let instance = ShellaServices()
    
    
    func CreateShella(withTitle title:String, andDescription description:String,andImageUrl imageURL:String,forUserIds userIds:[String],completionHandler:@escaping (_ status :Bool)->()){
        FirebaseReferences.instance.REF_SHELLA.childByAutoId().updateChildValues(["title":title,"description":description,"members":userIds,"ImageURL":imageURL])

            completionHandler(true)
    }
    func getShellaImage(forTitle title:String,handler:@escaping (_ imageURL:String)->()){
        FirebaseReferences.instance.REF_SHELLA.observeSingleEvent(of: .value) { (shellaSnapshot) in
            guard let shellaSnapshot = shellaSnapshot.children.allObjects as? [DataSnapshot]  else{return}
            for shella in shellaSnapshot{
                if title == shella.childSnapshot(forPath: "title").value as! String{
                    handler(shella.childSnapshot(forPath: "ImageURL").value as! String)
                }
            }
        }
    }
    
    func getAllShellas(handler:@escaping (_ shellaArray:[Shella])->()){
        var shellaArray = [Shella]()
        FirebaseReferences.instance.REF_SHELLA.observeSingleEvent(of: .value) { (shellaSnapshot) in
            guard let shellaSnapshot = shellaSnapshot.children.allObjects as? [DataSnapshot] else{return}
            for shella in shellaSnapshot{
                let membersArray = shella.childSnapshot(forPath: "members").value as! [String]
                if membersArray.contains((Auth.auth().currentUser?.uid)!){
                    
                    let title = shella.childSnapshot(forPath: "title").value as! String
                    let desc = shella.childSnapshot(forPath: "description").value as! String
                    let imageURL = shella.childSnapshot(forPath: "ImageURL").value as! String
                    let shella = Shella(title: title, desc: desc, imageURL: imageURL, members: membersArray, key: shella.key)
                    shellaArray.append(shella)
                }
            }
            handler(shellaArray)
 
        }
        
    }
    func downloadImage(withURL url:String,cell:ShellaCell){
        cell.shellaImage.loadImageUsingCacheWithUrlString(urlString: url)
    }

    
}
