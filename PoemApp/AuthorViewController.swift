//
//  AuthorViewController.swift
//  PoemApp
//
//  Created by 诺崇 on 15/6/13.
//  Copyright (c) 2015年 charsunny. All rights reserved.
//

import Cocoa

extension String {
    func trimContent()->String {
        var str = (self as NSString).stringByReplacingOccurrencesOfString("\n", withString: "")
        str = (str as NSString).stringByReplacingOccurrencesOfString("\r", withString: "")
        return str
    }
}

class AuthorViewController: NSViewController {

    @IBOutlet weak var authorIconImage: NSImageView!
    
    @IBOutlet weak var authorNameLabel: NSTextField!
    
    @IBOutlet weak var authorSubtitleLabel: NSTextField!
    
    @IBOutlet weak var tableContainerView: NSScrollView!
    
    @IBOutlet weak var tableView: NSTableView!
    
    var poems:[Poem] = []
    var author:Author = Author()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        authorIconImage.wantsLayer = true
        authorIconImage.layer?.cornerRadius = 33
        authorIconImage.layer?.borderWidth = 0.5
        authorIconImage.layer?.borderColor = NSColor.gridColor().CGColor
    }
    
    func loadAuthorData(author:Author) {
        self.author = author
        authorNameLabel.stringValue = author.name
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            self.poems = DBManager.sharedManager.queryPoemByAuthorId(author.index)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        })
    }
    
    @IBAction func onCloseViewController(sender: AnyObject) {
        let rootVC =  self.parentViewController as! ContentRootViewController
        rootVC.transitionFromViewController(self, toViewController: rootVC.contentViewController, options: NSViewControllerTransitionOptions.SlideDown) { () -> Void in
            rootVC.currentViewController = rootVC.contentViewController
        }
    }
    
    // MARK: tableview delegate
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return poems.count + 1
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if row == 0 {
            let cell = tableView.makeViewWithIdentifier("detail", owner: tableView) as! NSTableCellView
            (cell.viewWithTag(1) as! NSTextField).stringValue = self.author.desc
            return cell
        } else {
            let cell = tableView.makeViewWithIdentifier("cell", owner: tableView) as! NSTableCellView
            var data = poems[row-1]
            (cell.viewWithTag(1) as! NSTextField).stringValue = data.title
            (cell.viewWithTag(2) as! NSTextField).stringValue = data.content.trimContent()
            return cell
        }
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        self.performSegueWithIdentifier("popover", sender: tableView.selectedCell())
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let cell = tableView.makeViewWithIdentifier("detail", owner: tableView) as! NSTableCellView
        (cell.viewWithTag(1) as! NSTextField).stringValue = self.author.desc
        (cell.viewWithTag(1) as! NSTextField).sizeToFit()
        if row == 0 {
            return (cell.viewWithTag(1) as! NSTextField).frame.height + 60
        }
        return 60
    }

}
