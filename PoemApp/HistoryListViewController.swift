//
//  HistoryListViewController.swift
//  PoemApp
//
//  Created by sunsing on 6/14/15.
//  Copyright (c) 2015 charsunny. All rights reserved.
//

import Cocoa

class HistoryListViewController: NSViewController,NSViewControllerPresentationAnimator {

    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var indicator: NSProgressIndicator!
    
    var historyData:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimation(nil)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: NSURL(string: "http://poetry.duapp.com/his.json")!)) { (data: NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if error == nil {
                if let recData:NSArray = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error:nil) as? NSArray {
                    self.historyData = recData
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                        self.indicator.stopAnimation(nil)
                        self.indicator.removeFromSuperview()
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.indicator.stopAnimation(nil)
                        self.indicator.removeFromSuperview()
                    })
                }
            }
        }
        task.resume()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return historyData.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier("cell", owner: tableView) as! NSTableCellView
        
        if let data = historyData[row] as? NSDictionary {
            (cell.viewWithTag(1) as! NSTextField).stringValue = data["theme"] as! String
            (cell.viewWithTag(2) as! NSTextField).stringValue = data["desc"] as! String
            (cell.viewWithTag(3) as! NSTextField).stringValue = data["date"] as! String
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if tableView.numberOfSelectedRows <= 0 || tableView.selectedRow >= historyData.count{
            return
        }
        if let listvc = self.storyboard?.instantiateControllerWithIdentifier("listvc") as? ListViewController {
            if let data = historyData[tableView.selectedRow] as? NSDictionary {
                listvc.recommandIndex = data["id"] as! Int
                self.presentViewController(listvc, animator: self)
            }
        }
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 110
    }
    
    // MARK: view transation animator 
    func animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        let bottomVC = fromViewController
        let topVC = viewController
        
        // make sure the view has a CA layer for smooth animation
        topVC.view.wantsLayer = true
        
        // set redraw policy
        topVC.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        
        // add view of presented viewcontroller
        bottomVC.view.addSubview(topVC.view)
        // adjust size
        topVC.view.frame = NSRect(origin: NSPoint(x:bottomVC.view.frame.size.width, y: bottomVC.view.frame.origin.y), size: bottomVC.view.frame.size)
        
        // Do some CoreAnimation stuff to present view
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            // fade duration
            context.duration = 0.3
            // animate to alpha 1
            topVC.view.animator().setFrameOrigin(NSPoint(x: 0, y: 0))
            
        }, completionHandler: nil)
    }
    
    func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        let bottomVC = fromViewController
        let topVC = viewController
        
        // make sure the view has a CA layer for smooth animation
        topVC.view.wantsLayer = true
        
        // set redraw policy
        topVC.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        
        // Do some CoreAnimation stuff to present view
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            
            // fade duration
            context.duration = 0.3
            // animate view to alpha 0
            topVC.view.animator().setFrameOrigin(NSPoint(x: bottomVC.view.frame.size.width, y: 0))
            
            }, completionHandler: {
                
                // remove view
                topVC.view.removeFromSuperview()
        })
    }
}
