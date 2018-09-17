//
//  User.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/15/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation
class OtherUser{
    private var _email:String
    private var _imageURL:String
    private var _uid:String
    var email:String{
        return _email
    }
    var imageURL:String{
        return _imageURL
    }
    var uid:String{
        return _uid
    }
    init(email:String,imageURL:String,uid:String){
        self._email=email
        self._imageURL=imageURL
        self._uid=uid
    }
}
