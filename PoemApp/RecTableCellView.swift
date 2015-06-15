//
//  RecTableCellView.swift
//  PoemApp
//
//  Created by 诺崇 on 15/6/10.
//  Copyright © 2015年 charsunny. All rights reserved.
//

import Cocoa

class RecTableCellView: NSTableCellView {

    @IBOutlet weak var iconImage: NSImageView!
    
    @IBOutlet weak var titleLabel: NSTextField!
    
    @IBOutlet weak var descLabel: NSTextField!
    
    @IBOutlet weak var authorCell: NSTextField!
    
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        iconImage.wantsLayer = true
        iconImage.layer?.masksToBounds = true
    }
    
}
