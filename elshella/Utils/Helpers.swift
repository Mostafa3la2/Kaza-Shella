//
//  Helpers.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/14/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation


let NOTIF_CHANNEL_SELECTED = Notification.Name("channelSelected")
let NOTIF_CHANNEL_LEFT = Notification.Name("channelLeft")

func downloadImage(withURL url:String,imageView:UIImageView){
    imageView.loadImageUsingCacheWithUrlString(urlString: url)
}

enum SegmentType :String{
    case ViewFriend = "viewFriendCell"
    case AddFriend = "addFriendCell"
    case ViewRequest = "viewRequestCell"
}

enum messageType:String{
    case regular="regular"
    case outing="outing"
}
