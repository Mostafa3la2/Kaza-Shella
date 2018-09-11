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
    
    
    func CreateShella(withTitle title:String, andDescription description:String,andImageUrl imageURL:String?,forUserIds userIds:[String],completionHandler:@escaping (_ status :Bool)->()){
        FirebaseReferences.instance.REF_SHELLA.childByAutoId().updateChildValues(["title":title,"description":description,"members":userIds,"ImageURL":imageURL])
            completionHandler(true)
    }

    
}
