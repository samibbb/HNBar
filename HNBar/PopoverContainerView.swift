//
//  PopoverContainerView.swift
//  HNBar
//
//  Created by James on 2015-07-20.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class PopoverContainerView: NSView {
    
    var clippingView: NSView!
    
    var arrowX: CGFloat = 0 {
        didSet { self.needsDisplay = true }
    }
    
    var arrowWidth: CGFloat = 23 {
        didSet { self.needsDisplay = true }
    }
    
    var arrowHeight: CGFloat = 12 {
        didSet {
            self.needsDisplay = true
            clippingView.frame = NSRect(x: 0, y: 0, width: NSWidth(self.bounds), height: NSHeight(self.bounds) - arrowHeight)
        }
    }
    
    var cornerRadius: CGFloat = 10 {
        didSet {
            self.needsDisplay = true
            clippingView.layer?.cornerRadius = cornerRadius
        }
    }
    
    var borderWidth: CGFloat = 1 {
        didSet { self.needsDisplay = true }
    }
    
    var borderColor: NSColor = NSColor(calibratedWhite: 0, alpha: 0.3) {
        didSet { self.needsDisplay = true }
    }
    
    var backgroundColor: NSColor = NSColor.whiteColor() {
        didSet { self.needsDisplay = true }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        clippingView = NSView(frame: NSRect(x: 0, y: 0, width: NSWidth(self.bounds), height: NSHeight(self.bounds) - arrowHeight))
        clippingView.autoresizingMask = NSAutoresizingMaskOptions.ViewHeightSizable.union(NSAutoresizingMaskOptions.ViewWidthSizable)
        clippingView.wantsLayer = true
        clippingView.layer?.cornerRadius = cornerRadius
        clippingView.layer?.masksToBounds = true
        self.addSubview(clippingView)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        let contentRect = NSInsetRect(self.bounds, borderWidth, borderWidth)
        let path = NSBezierPath()
        
        path.moveToPoint(NSPoint(x: arrowX, y: NSMaxY(contentRect)))
        path.lineToPoint(NSPoint(x: arrowX + arrowWidth / 2, y: NSMaxY(contentRect) - arrowHeight))
        path.lineToPoint(NSPoint(x: NSMaxX(contentRect) - cornerRadius, y: NSMaxY(contentRect) - arrowHeight))
        
        let topRightCorner = NSPoint(x: NSMaxX(contentRect), y: NSMaxY(contentRect) - arrowHeight)
        path.curveToPoint(NSPoint(x: NSMaxX(contentRect), y: NSMaxY(contentRect) - arrowHeight - cornerRadius), controlPoint1: topRightCorner, controlPoint2: topRightCorner)
        
        path.lineToPoint(NSPoint(x: NSMaxX(contentRect), y: NSMinY(contentRect) + cornerRadius))
        
        let bottomRightCorner = NSPoint(x: NSMaxX(contentRect), y: NSMinY(contentRect))
        path.curveToPoint(NSPoint(x: NSMaxX(contentRect) - cornerRadius, y: NSMinY(contentRect)), controlPoint1: bottomRightCorner, controlPoint2: bottomRightCorner)
        
        path.lineToPoint(NSPoint(x: NSMinX(contentRect) + cornerRadius, y: NSMinY(contentRect)))
        
        path.curveToPoint(NSPoint(x: NSMinX(contentRect), y: NSMinY(contentRect) + cornerRadius), controlPoint1: contentRect.origin, controlPoint2: contentRect.origin)
        
        path.lineToPoint(NSPoint(x: NSMinX(contentRect), y: NSMaxY(contentRect) - arrowHeight - cornerRadius))
        
        let topLeftCorner = NSPoint(x: NSMinX(contentRect), y: NSMaxY(contentRect) - arrowHeight)
        path.curveToPoint(NSPoint(x: NSMinX(contentRect) + cornerRadius, y: NSMaxY(contentRect) - arrowHeight), controlPoint1: topLeftCorner, controlPoint2: topLeftCorner)
        
        path.lineToPoint(NSPoint(x: arrowX - arrowWidth / 2, y: NSMaxY(contentRect) - arrowHeight))
        path.closePath()
        
        path.lineWidth = borderWidth
        borderColor.setStroke()
        path.stroke()
        
        backgroundColor.setFill()
        path.fill()
    }
}