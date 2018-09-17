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
        print("this should be called only once")
        getFriends { (success) in
            if !success{
                print("couln't fetch friends")
            }
            print("friends list should be ready!!!!!!")
        }
        getRequests { (succes) in
            if !succes{
                print("couldn't fetch requests")
            }
        }
    }
    private var _friendsIDs = [OtherUser]()
    
    private var _requests = [OtherUser]()

    static let instance = UserServices()
    
    var user:User{
        return Auth.auth().currentUser!
    }
    var reqeuests:[OtherUser]{
        return _requests
    }
    var friends:[OtherUser]{
        return _friendsIDs
    }
    func createUser(WithEmail email:String,andPassword password:String,userCreationComplete:@escaping (_ status :Bool,_ error:Error?)->()){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else{
                userCreationComplete(false,error)
                return
            }
            let uid = user.uid
            let userData = ["proivder":user.providerID,"email":user.email,"photoURL":""]
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
    
    func getUsersStarting(WithCharacters characters:String,handler:@escaping(_ emails:[OtherUser])->()){
        var userArray = [OtherUser]()
        FirebaseReferences.instance.REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else{return}
            for user in userSnapshot{
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.hasPrefix(characters) && email != Auth.auth().currentUser?.email{
                    let otherUser = OtherUser(email: email, imageURL: user.childSnapshot(forPath: "photoURL").value as! String, uid: user.key)
                    userArray.append(otherUser)
                }
            }
            handler(userArray)
        }
        
    }
    func getFriends(handler:@escaping(_ success:Bool)->()){
    
    FirebaseReferences.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (userSnapshot) in
            let userSnapshot = userSnapshot.childSnapshot(forPath: "friends").value as! [String]
            for id in userSnapshot{
                UserServices.instance.getUser(forUID: id, handler: { (returnedUser) in
                    let _user = returnedUser
                    self._friendsIDs.append(_user)
                })
            }
        handler(true)
        }
        
    }
    func getFriendsStarting(WithCharacters characters:String,handler:@escaping(_ emails:[OtherUser])->()){
        
        var userArray = [OtherUser]()
            for friend in _friendsIDs{
                if friend.email.hasPrefix(characters) && friend.email != Auth.auth().currentUser?.email{
                    userArray.append(friend)

                }
            }
        handler(userArray)
            
        
    }
  /*  func getFriendsStarting(WithCharacters characters:String,handler:@escaping(_ friends:[OtherUser])->()){
        var allFriendsArray = [OtherUser]()
        var friendsArray = [OtherUser]()
        FirebaseReferences.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (userSnapshot) in
            let userSnapshot = userSnapshot.childSnapshot(forPath: "friends").value as! [String]
            
           
                for id in userSnapshot{
                    UserServices.instance.getUser(forUID: id, handler: { (returnedUser) in
                        let friend = returnedUser
                        //here is the problem, this gets executed after the below checkup is done
                        allFriendsArray.append(friend)
                    })
                }
                
            

        }
        //this loop doesn't wait for the above loop to populate the allFriendsArray
        
        DispatchQueue.main.async {
            if allFriendsArray.isEmpty{
                handler([OtherUser]())
            }else{
            for friend in allFriendsArray{
                if friend.email.hasPrefix(characters) && friend.email != Auth.auth().currentUser?.email{
                    friendsArray.append(friend)
                    
                }
            }
            handler(friendsArray)
        }
        }
            
        
    
    }*/
    func getRequests(handler:@escaping (_ success:Bool)->()){
       
        FirebaseReferences.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (userSnapshot) in
            let userSnapshot = userSnapshot.childSnapshot(forPath: "requests").value as! [String]
            for id in userSnapshot{
                UserServices.instance.getUser(forUID: id, handler: { (returnedUser) in
                    let _user = returnedUser
                    self._requests.append(_user)
                    
                })
            }
            
        }
        handler(true)
    }
    func getUser(forUID uid :String, handler:@escaping (_ user:OtherUser)->()){
        FirebaseReferences.instance.REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapshot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot{
                if user.key == uid {
                    let returnedUser = OtherUser(email: user.childSnapshot(forPath: "email").value as! String, imageURL: user.childSnapshot(forPath: "photoURL").value as! String,uid:user.key)
                    handler(returnedUser)
                }
            }
        }
        
    }
    
    func deleteFriend(withUID uid:String,completionHandler:@escaping(_ success:Bool)->()){
        FirebaseReferences.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (dataSnapShot) in
            let userSnapshot = dataSnapShot.childSnapshot(forPath: "friends").value as! [String]
            var index = 0
            for id in userSnapshot{
                if id == uid{
                    FirebaseReferences.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("friends").child(String(index)).removeValue()
                    completionHandler(true)
                    break
                    
                }
                index+=1
            }
        }
    }
    
    func getIds(forEmails emails:[String],handler:@escaping (_ uidArray:[String])->()){
        var idArray = [String]()
        FirebaseReferences.instance.REF_USERS.observeSingleEvent(of: .value) { (usersnapShot) in
            guard let usersnapShot = usersnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in usersnapShot{
                let email = user.childSnapshot(forPath: "email").value as! String
                if emails.contains(email){
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
        
        
    }
    func getImageURL(forUserId uid:String,handler:@escaping(_ url:String)->()){
        var imageURL = ""
        if uid == Auth.auth().currentUser?.uid{
            handler((Auth.auth().currentUser?.photoURL?.absoluteString)!)
            return
        }
        FirebaseReferences.instance.REF_USERS.observeSingleEvent(of: .value) { (usersnapShot) in
            guard let usersnapShot = usersnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in usersnapShot{
                if user.key == uid{
                    imageURL = user.childSnapshot(forPath: "photoURL").value as! String
                    break
                }
                
            }
            handler(imageURL)
        }
    }
    func addImage(image:UIImage,completionHandler:@escaping (_ success:Bool)->()){
        //TODO
        //Upload the image to the storage
        //Then add it to the photoURL attr of the user
        let data = UIImageJPEGRepresentation(image, 0.8)!
        let user = Auth.auth().currentUser!
        let email = user.email!
        FirebaseReferences.instance.REF_STORAGE.child("\(email).png").putData(data, metadata: nil) { (metadata, error) in
            if error != nil{
                print(error!)
                return
            }
           FirebaseReferences.instance.REF_STORAGE.child("\(email).png").downloadURL(completion: { (returnedURL, error) in
                if error != nil{
                    print(error)
                    return
                }
                print(returnedURL)
                /*let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = returnedURL
            
                changeRequest?.commitChanges(completion: { (error) in
                    if error != nil {
                        print("cannot set photo")
                    }else{
             
                    }
                })*/
            FirebaseReferences.instance.REF_USERS.child(user.uid).updateChildValues(["photoURL" : returnedURL?.absoluteString])
            completionHandler(true)
            })
            
        }
        
    }
    
    
}
