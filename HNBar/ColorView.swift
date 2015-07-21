//
//  ColorView.swift
//  HNBar
//
//  Created by James on 2015-07-20.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class ColorView: NSView {

    var backgroundColor: NSColor = NSColor.whiteColor() {
        didSet { self.needsDisplay = true }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        backgroundColor.set()
        NSRectFill(dirtyRect)
    }
    
}
