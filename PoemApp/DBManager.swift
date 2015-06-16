//
//  DBManager.swift
//  PoemApp
//
//  Created by 诺崇 on 15/6/11.
//  Copyright (c) 2015年 charsunny. All rights reserved.
//

import Cocoa
import SQLite

class DBManager: NSObject {
    
    static let sharedManager:DBManager = DBManager()
    
    var title = Expression<String>("title")
    
    lazy var db = Database(NSBundle.mainBundle().pathForResource("poem", ofType: "db")!)
    
    lazy var poems:Query = {
        let tmpPoems =  self.db["poem"]
        return tmpPoems
    }()
    
    lazy var authors:Query = {
        let tmpPoems =  self.db["poet"]
        return tmpPoems
    }()
    
    func queryPoem(index:Int) -> Poem {
        var poem = Poem()
        if let row = poems.filter(Expression("id") == index).first {
            poem = Poem(row:row)
        }
        return poem
    }
    
    func queryPoemWithRecommand(rec:NSDictionary)->Poem {
        let quote = (rec["desc"] as! NSString).stringByReplacingOccurrencesOfString(",", withString: "，")
        if let str = (quote as NSString).componentsSeparatedByString("，").first as? NSString {
            let rows = poems.filter(like("%\(str)%", Expression("text_cn")));
            for row in rows {
                if row.get(Expression("name_cn")) == (rec["title"] as! String) {
                    var poem = Poem(row:rows.first!)
                    poem.author = DBManager.sharedManager.queryAuthorbyId(row.get(Expression("poet_id")))
                    return poem
                }
            }
            if rows.count > 0 {
                var poem = Poem(row:rows.first!)
                poem.author = DBManager.sharedManager.queryAuthorbyId(rows.first!.get(Expression("poet_id")))
                return poem
            }
        }
        return Poem()
    }
    
    func queryPoemByAuthorId(id:Int) -> [Poem] {
        let rows = poems.filter(Expression("poet_id") == id)
        
        var results : [Poem] = []
        
        var author = DBManager.sharedManager.queryAuthorbyId(id)
        
        for row in rows {
            var poem = Poem(row: row)
            poem.author = author
            results.append(poem)
        }
        
        return results
    }
    
    func queryAllPoem() -> [Poem] {
        var results : [Poem] = []
        for row in poems {
            var poem = Poem(row: row)
            results.append(poem)
        }
        return results
    }
    
    func queryAllPoet() -> [Author] {
        var results : [Author] = []
        for row in authors {
            var author = Author(row: row)
            results.append(author)
        }
        return results
    }
    
    func queryAllSongName() -> [Song] {
        return []
    }
    
    func queryAuthorbyId(index:Int) -> Author {
        if let row = authors.filter(Expression("id") == index).first {
            return Author(row: row)
        } else {
            return Author()
        }
    }
    
    func queryAuthorbyName(name:String) -> Author {
        if let row = authors.filter(Expression("name_cn") == name).first {
            return Author(row: row)
        } else {
            return Author()
        }
    }
}
