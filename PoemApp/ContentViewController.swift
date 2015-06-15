//
//  ContentViewController.swift
//  PoemApp
//
//  Created by 诺崇 on 15/6/13.
//  Copyright (c) 2015年 charsunny. All rights reserved.
//

import Cocoa
import WebKit

class ContentViewController: NSViewController {

    @IBOutlet weak var titleLabel: NSTextField!
    
    @IBOutlet weak var authorLabel: NSButton!
    
    @IBOutlet var contentTextView: NSTextView!
    
    @IBOutlet weak var webView: WebView!
    
    var poemInfo:Poem? = nil
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationController as? AuthorPopoverViewController {
            vc.author = poemInfo!.author
        }
    }
    
    func showPoem(poem:Poem) {
        poemInfo = poem
        titleLabel.selectable = true
        //authorDesLabel.selectable = true
        titleLabel.stringValue = poem.title
        authorLabel.title = poem.author.name
        contentTextView.string = poem.content
    }
}
