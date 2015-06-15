//
//  MainWindowController.swift
//  PoemApp
//
//  Created by 诺崇 on 15/6/10.
//  Copyright © 2015年 charsunny. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController,NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.styleMask |= NSFullSizeContentViewWindowMask
        window?.titleVisibility = .Hidden
        window?.delegate = self
        self.window?.titlebarAppearsTransparent = true
    }

    func windowShouldClose(sender: AnyObject) -> Bool {
        window?.miniaturize(sender)
        return false
    }
}
