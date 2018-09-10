//
//  FirebaseReferences.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/10/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class FirebaseReferences{
    
    private init(){
        
    }
    static let instance = FirebaseReferences()
    
    private var _REF_DATABASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_SHELLA = DB_BASE.child("shellas")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE : DatabaseReference{
        return _REF_DATABASE
    }
    var REF_USERS : DatabaseReference{
        return _REF_USERS
    }
    var REF_SHELLA: DatabaseReference{
        return _REF_SHELLA
    }
    var REF_FEED : DatabaseReference{
        return _REF_FEED
    }
    
   

    
}
