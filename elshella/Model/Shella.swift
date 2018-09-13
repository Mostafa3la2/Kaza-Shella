//
//  Shella.swift
//  elshella
//
//  Created by Mostafa Alaa on 9/12/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation

class Shella{
    
    private var _title:String
    private var _desc:String
    private var _imageURL:String
    private var _membersCount:Int
    private var _members:[String]
    private var _key:String
    
    
    var title:String{
        return _title
    }
    var desc:String{
        return _desc
    }
    var key:String{
        return _key
    }
    var membersCount:Int{
        return _membersCount
    }
    var members:[String]{
        return _members
    }
    var imageURL:String{
        return _imageURL
    }
    
    init(title:String,desc:String,imageURL:String,members:[String],key:String) {
        self._title=title
        self._desc=desc
        self._imageURL=imageURL
        self._members=members
        self._key=key
        self._membersCount=members.count
    }
    
}
