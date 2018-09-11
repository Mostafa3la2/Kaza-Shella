//
//  UserServices.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/10/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation
import Firebase
class UserServices{
    
    private init(){
        
    }
    static let instance = UserServices()
    
    func createUser(WithEmail email:String,andPassword password:String,userCreationComplete:@escaping (_ status :Bool,_ error:Error?)->()){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else{
                userCreationComplete(false,error)
                return
            }
            let uid = user.uid
            let userData = ["proivder":user.providerID,"email":user.email]
            FirebaseReferences.instance.REF_USERS.child(uid).updateChildValues(userData)
            userCreationComplete(true,nil)
        }
    }
    
    func loginUser(withEmail email:String,withPassword password:String,loginComplete:@escaping (_ status:Bool, _ error:Error?)->()){
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil{
                loginComplete(false,error)
                return
            }
            loginComplete(true,nil)
        }
    }
    
    func getEmailsStarting(WithCharacters characters:String,handler:@escaping(_ emails:[String])->()){
        var emailArray = [String]()
        //this should be updated to observe only friends not users
        FirebaseReferences.instance.REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else{return}
            for user in userSnapshot{
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.hasPrefix(characters) && email != Auth.auth().currentUser?.email{
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
        
    }
    
    func getIds(forEmails emails:[String],handler:@escaping (_ uidArray:[String])->()){
        var idArray = [String]()
        FirebaseReferences.instance.REF_USERS.observeSingleEvent(of: .value) { (usersnapShot) in
            guard let usersnapShot = usersnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in usersnapShot{
                let email = user.childSnapshot(forPath: "email").value as! String
                if emails.contains(email){
                    idArray.append(email)
                }
            }
            handler(idArray)
        }
        
        
    }
    
    
    
}
