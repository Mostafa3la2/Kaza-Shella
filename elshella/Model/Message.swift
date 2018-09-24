//
//  Message.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/21/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation

class Message{
    private var _content:String
    private var _senderID:String
    private var _type:messageType
    var content:String{
        return _content
    }
    var senderID:String{
        return _senderID
    }
    var type:messageType{
        return _type
    }
    
    init(content:String,senderID:String,type:messageType){
        self._content=content
        self._senderID=senderID
        self._type=type
    }
}
