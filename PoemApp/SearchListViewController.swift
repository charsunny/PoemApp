//
//  SearchListViewController.swift
//  PoemApp
//
//  Created by sunsing on 6/16/15.
//  Copyright (c) 2015 charsunny. All rights reserved.
//

import Cocoa

class SearchListViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource {

    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var segementControl: NSSegmentedControl!
    
    @IBOutlet weak var indicator: NSProgressIndicator!
    
    @IBOutlet weak var searchField: NSSearchField!
    
    var currentDataSource:NSArray = []
    
    var poems:NSArray = []
    var authors:NSArray = []
    var songs:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.indicator.startAnimation(nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onTextChanged:", name: NSControlTextDidEndEditingNotification, object: searchField)
        dispatch_async(dispatch_get_global_queue(0, 0)){
            self.poems = DBManager.sharedManager.queryAllPoem()
            self.authors = DBManager.sharedManager.queryAllPoet()
            self.songs = DBManager.sharedManager.queryAllSongName()
            self.currentDataSource = self.poems
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.indicator.hidden = true
            }
        }
    }
    
    @IBAction func valueChanged(sender: NSSegmentedControl) {
        self.indicator.hidden = false
        if searchField.stringValue != "" {
            onTextChanged(nil)
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0)){
                switch sender.selectedSegment {
                case 0:
                    self.currentDataSource = self.poems
                case 1:
                    self.currentDataSource = self.authors
                case 2:
                    self.currentDataSource = self.songs
                default:
                    print("wrong path!")
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.indicator.hidden = true
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: search field notifcation 
    func onTextChanged(notif:NSNotification?) {
        dispatch_async(dispatch_get_global_queue(0, 0)){
            var searchText = self.searchField.stringValue.trimContent()
            switch self.segementControl.selectedSegment {
            case 0:
                if searchText == "" {
                    self.currentDataSource = self.poems
                } else {
                    self.currentDataSource = filter(self.poems, { (poem:AnyObject) -> Bool in
                        return ((poem as! Poem).title as NSString).containsString(searchText) || ((poem as! Poem).content as NSString).containsString(searchText)
                    })
                }
            case 1:
                if searchText == "" {
                    self.currentDataSource = self.poems
                } else {
                    self.currentDataSource = filter(self.authors, { (author:AnyObject) -> Bool in
                        return ((author as! Author).name as NSString).containsString(searchText)
                    })
                }
            case 2:
                fallthrough
            default:
                print("xxxx")
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.indicator.hidden = true
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: tableview delegate
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return currentDataSource.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = (segementControl.selectedSegment == 1) ?  tableView.makeViewWithIdentifier("cell", owner: tableView) as! RecTableCellView : tableView.makeViewWithIdentifier("textcell", owner: tableView) as! NSTableCellView
        
        switch(segementControl.selectedSegment) {
        case 0:
            if let poem = self.currentDataSource[row] as? Poem {
                (cell.viewWithTag(1) as! NSTextField).stringValue = poem.title
                (cell.viewWithTag(2) as! NSTextField).stringValue = poem.content.trimContent()
            }
        case 1:
            if let author = self.currentDataSource[row] as? Author {
                (cell as! RecTableCellView).authorCell.stringValue = author.name
                (cell as! RecTableCellView).titleLabel.stringValue = author.name
                (cell as! RecTableCellView).descLabel.stringValue = author.desc.trimContent()
                if let image = NSImage(contentsOfURL: NSURL(string: "http://so.gushiwen.org/authorImg/\(author.pinyin).jpg")!) {
                    (cell as! RecTableCellView).iconImage.image = image
                    //(cell as! RecTableCellView).iconImage.layer?.cornerRadius = 22
                }
            }
        case 2:
            if let poem = self.currentDataSource[row] as? Poem {
                (cell.viewWithTag(1) as! NSTextField).stringValue = poem.title
                (cell.viewWithTag(2) as! NSTextField).stringValue = poem.content.trimContent()
            }
        default:
            print("wrong path!")
        }
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if tableView.numberOfSelectedRows <= 0 || tableView.selectedRow >= currentDataSource.count{
            return
        }
        switch segementControl.selectedSegment {
        case 0:
            if let data = currentDataSource[tableView.selectedRow] as? Poem {
                let poem = DBManager.sharedManager.queryPoem(data.index)
                NSNotificationCenter.defaultCenter().postNotificationName(kShowPoemNotification, object: nil, userInfo: ["poem":poem])
            }
        case 1:
            if let data = currentDataSource[tableView.selectedRow] as? Author {
                NSNotificationCenter.defaultCenter().postNotificationName(kShowAuthorNotification, object: nil, userInfo: ["author":data])
            }
        case 2:
            if let data = currentDataSource[tableView.selectedRow] as? NSDictionary {
                let poem = DBManager.sharedManager.queryPoemWithRecommand(data)
                NSNotificationCenter.defaultCenter().postNotificationName(kShowPoemNotification, object: nil, userInfo: ["poem":poem])
            }
        default:
            println("xxx")
        }
        
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 75
    }
}

