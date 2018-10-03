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
        

        
        let shella = FirebaseReferences.instance.REF_SHELLA.childByAutoId()
        shella.updateChildValues(["title":title,"description":description,"ImageURL":imageURL])
        for id in userIds{
            shella.child("members").childByAutoId().setValue(id)
        }
        
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
    
    func getAllShellas(handler:@escaping (_ success:Bool)->()){
        
        FirebaseReferences.instance.REF_SHELLA.observeSingleEvent(of: .value) { (shellaSnapshot) in
            guard let shellaSnapshot = shellaSnapshot.children.allObjects as? [DataSnapshot] else{return}
            for shella in shellaSnapshot{
                let membersDict = shella.childSnapshot(forPath: "members").value as! [String:String]
                if membersDict.values.contains((Auth.auth().currentUser?.uid)!){
                    let members = membersDict.values.map{$0}
                    let title = shella.childSnapshot(forPath: "title").value as! String
                    let desc = shella.childSnapshot(forPath: "description").value as! String
                    let imageURL = shella.childSnapshot(forPath: "ImageURL").value as! String
                    let shella = Shella(title: title, desc: desc, imageURL: imageURL, members: members, key: shella.key)
                    if !UserServices.instance.shellas.contains(where: {$0.key == shella.key}){
                        UserServices.instance.shellas.append(shella)}
                }
            }
            handler(true)
 
        }
        
    }
    func getFirstShella(handler:@escaping (_ shella : Shella)->()){
        FirebaseReferences.instance.REF_SHELLA.observeSingleEvent(of: .value) { (shellaSnapshot) in
            guard let shellaSnapshot = shellaSnapshot.children.allObjects as? [DataSnapshot] else{return}
            for shella in shellaSnapshot{
                let membersDict = shella.childSnapshot(forPath: "members").value as! [String:String]
                if membersDict.values.contains((Auth.auth().currentUser?.uid)!){
                    let members = membersDict.values.map{$0}
                    let title = shella.childSnapshot(forPath: "title").value as! String
                    let desc = shella.childSnapshot(forPath: "description").value as! String
                    let imageURL = shella.childSnapshot(forPath: "ImageURL").value as! String
                    let shella = Shella(title: title, desc: desc, imageURL: imageURL, members: members, key: shella.key)
                    handler(shella)
                    break
                }
                let shella = Shella(title: "No Shella joined", desc: "try creating one of let your friends add you", imageURL: "", members: [], key: "")
                handler(shella)
            }
        }
    }
    
    func getUserIDFor(shella:Shella,handler:@escaping(_ usersArray:[OtherUser])->()){
        var othersArray = [OtherUser]()
        FirebaseReferences.instance.REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapshot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot{
                if shella.members.contains(user.key){
                    let email = user.childSnapshot(forPath: "email").value as! String
                    let imageURL = user.childSnapshot(forPath: "photoURL").value as! String
                    let otherUser = OtherUser(email: email, imageURL: imageURL, uid: user.key)
                    othersArray.append(otherUser)
                }
            }
            handler(othersArray)
        }
        
        
    }
    func getAllMessagesFor(desiredShella:Shella,handler:@escaping (_ messagesArray:[Message])->()){
        
        var groupMessageArray = [Message]()
        FirebaseReferences.instance.REF_SHELLA.child(desiredShella.key).child("messages").observe(.value) { (shellaMessageSnapshot) in
            guard let shellaMessageSnapshot = shellaMessageSnapshot.children.allObjects as? [DataSnapshot] else{return}
            for shellaMessage in shellaMessageSnapshot{
                let content = shellaMessage.childSnapshot(forPath: "content").value as! String
                let senderID = shellaMessage.childSnapshot(forPath: "senderID").value as! String
                let type = shellaMessage.childSnapshot(forPath: "type").value as! String
                
                let message = Message(content: content, senderID: senderID, type: messageType(rawValue: type)!)
                groupMessageArray.append(message)
            }
            handler(groupMessageArray)
        }
        
    }
    func uploadPost(withMessage message:Message,withShellaKey shellaKey:String, sendComplete:@escaping (_ status:Bool)->()){
        
        FirebaseReferences.instance.REF_SHELLA.child(shellaKey).child("messages").childByAutoId().updateChildValues(["content":message.content,"senderID":message.senderID,"type":message.type.rawValue])
            sendComplete(true)
        
        
    }
    func leaveShella(withKey key :String,completionHandler:@escaping (_ success:Bool)->()){
        FirebaseReferences.instance.REF_SHELLA.child(key).observe(.value) { (shellaMembersSnapshot) in
            guard let members = shellaMembersSnapshot.childSnapshot(forPath: "members").value as? [String:String] else {return}
            let index = members.values.index(of: UserServices.instance.user.uid)
            let indexToRemove = members.keys[index!]
            
            FirebaseReferences.instance.REF_SHELLA.child(key).child("members").child(indexToRemove).removeValue()
            for shella in UserServices.instance.shellas{
                if shella.key == key{
                    UserServices.instance.shellas = UserServices.instance.shellas.filter{$0.key != shella.key}
                    break
                }
            }
            completionHandler(true)
        }
    }
    func addToShella(withKey key:String,userID:String,completionHandler:@escaping (_ success:Bool)->()){
        FirebaseReferences.instance.REF_SHELLA.child(key).child("members").childByAutoId().setValue(userID)
        completionHandler(true)
    }
    

    
}
