//
//  EmptyRowTableView.swift
//  HNBar
//
//  Created by James on 2015-07-23.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class EmptyRowTableView: NSTableView {

    override func drawGridInClipRect(clipRect: NSRect) {
        let lastRowRect = rectOfRow(numberOfRows - 1)
        let contentRect = NSRect(x: 0, y: 0, width: NSWidth(lastRowRect), height: NSMaxY(lastRowRect))
        let newClipRect = NSIntersectionRect(clipRect, contentRect)
        super.drawGridInClipRect(newClipRect)
    }
    
}
