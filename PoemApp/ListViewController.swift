//
//  ListViewController.swift
//  PoemApp
//
//  Created by 诺崇 on 15/6/10.
//  Copyright © 2015年 charsunny. All rights reserved.
//

import Cocoa

class ListViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var themeLabel: NSTextField!
    
    @IBOutlet weak var backButton: NSButton!
    
    @IBOutlet weak var themeDesLabel: NSTextField!
    
    @IBOutlet weak var searchField: NSSearchField!
    
    @IBOutlet weak var indicator: NSProgressIndicator!
    
    var recommandIndex:Int = 0
    
    var recommandData:NSDictionary = [String:AnyObject]()
    
    var recPoems:NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        themeDesLabel.selectable = true
        indicator.startAnimation(nil)
        loadRecPoems(recommandIndex)
    }
    
    @IBAction func onNaviBack(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(kShowEmptyNotification, object: nil)
        self.dismissViewController(self)
    }
    
    func loadRecPoems(index:Int) {
        var url = "http://poetry.duapp.com/rec.json"
        if index > 0 {
            url = url.stringByAppendingString(".\(index)")
        } else {
            backButton.hidden = true
        }
        let task = NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: NSURL(string: url)!)) { (data: NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if error == nil {
                if let recData:NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error:nil) as? NSDictionary {
                    self.recommandData = recData
                    self.recPoems = recData["poems"] as! NSArray
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.themeLabel.stringValue = recData["theme"] as! String
                        self.themeDesLabel.stringValue = recData["desc"] as! String
                        self.tableView.reloadData()
                        self.indicator.stopAnimation(nil)
                        self.indicator.removeFromSuperview()
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        //self.tableView.reloadData()
                        self.indicator.stopAnimation(nil)
                        self.indicator.removeFromSuperview()
                    })
                }
            }
        }
        task.resume()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return recPoems.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier("cell", owner: tableView) as! RecTableCellView
        
        if let data = recPoems[row] as? NSDictionary {
            cell.titleLabel.stringValue = data["title"] as! String
            cell.descLabel.stringValue = data["desc"] as! String
            cell.authorCell.stringValue = data["author"] as! String
            if let image = NSImage(contentsOfURL: NSURL(string: data["image"] as! String)!) {
                cell.iconImage.image = image
            }
            cell.iconImage.wantsLayer = true
            cell.iconImage.layer?.cornerRadius = 22;
            cell.iconImage.layer?.masksToBounds = true
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if tableView.numberOfSelectedRows <= 0 || tableView.selectedRow >= recPoems.count{
            return
        }
        if let data = recPoems[tableView.selectedRow] as? NSDictionary {
            let poem = DBManager.sharedManager.queryPoemWithRecommand(data)
            NSNotificationCenter.defaultCenter().postNotificationName(kShowPoemNotification, object: nil, userInfo: ["poem":poem])
        }
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 75
    }
}
