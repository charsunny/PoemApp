//
//  Poem.swift
//  PoemApp
//
//  Created by 诺崇 on 15/6/11.
//  Copyright (c) 2015年 charsunny. All rights reserved.
//

import Cocoa
import SQLite

class Author {
    var index:Int = 0
    var name:String = ""
    var desc:String = ""
    var age:String = ""
    var pinyin:String = ""
    init () {
       
    }

    init(row:Row) {
        index = row.get(Expression("id"))
        name = row.get(Expression("name_cn"))
        desc = row.get(Expression("description_cn")) ?? "暂无介绍。"
        //age = row.get(Expression("period_id"))
        pinyin = row.get(Expression("pinyin_roman")) ?? ""
        pinyin = pinyin.stringByReplacingOccurrencesOfString(" ", withString: "")
        pinyin = (pinyin as NSString).stringByReplacingOccurrencesOfString("[0-9]", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: NSMakeRange(0, (pinyin as NSString).length))
    }
}

class Poem: NSObject {
    var index:Int = 0
    var title:String = ""
    var subtitle:String = ""
    var author:Author = Author()
    var content:String = ""
    var note:String? = ""
    var format:String? = ""
    
    override init () {
        
    }
    
    init(row:Row) {
        index = row.get(Expression("id"))
        title = row.get(Expression("name_cn"))
        content = row.get(Expression("text_cn"))
    }
}

class Song {
    var index:Int = 0
    var name:String = ""
    var desc:String = ""
}
