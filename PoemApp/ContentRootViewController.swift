//
//  ContentRootViewController.swift
//  PoemApp
//
//  Created by 诺崇 on 15/6/13.
//  Copyright (c) 2015年 charsunny. All rights reserved.
//

import Cocoa

class ContentRootViewController: NSViewController {
    
    var currentViewController:NSViewController!
    
    var emptyViewController:EmptyViewController!
    
    var contentViewController:ContentViewController!
    
    var authorViewController:AuthorViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        for vc in self.childViewControllers {
            if let vc = vc as? NSViewController {
                if vc is ContentViewController {
                    contentViewController = vc as! ContentViewController
                } else if vc is EmptyViewController {
                    emptyViewController = vc as! EmptyViewController
                } else if vc is AuthorViewController {
                    authorViewController = vc as! AuthorViewController
                }
            }
        }
        currentViewController = emptyViewController
        contentViewController.view.removeFromSuperview()
        authorViewController.view.removeFromSuperview()
    }
    
    func showPoem(poem:Poem) {
        if currentViewController != contentViewController {
            self.contentViewController.showPoem(poem);
            transitionFromViewController(currentViewController, toViewController: contentViewController, options: NSViewControllerTransitionOptions.SlideForward, completionHandler: { () -> Void in
                self.currentViewController = self.contentViewController
            })
        } else {
            contentViewController.showPoem(poem);
        }
    }
    
    func showEmptyView() {
        if currentViewController != emptyViewController {
            emptyViewController.showEmpty()
            transitionFromViewController(currentViewController, toViewController: emptyViewController, options: NSViewControllerTransitionOptions.SlideForward, completionHandler: { () -> Void in
                self.currentViewController = self.emptyViewController
            })
        }
    }
    
}
