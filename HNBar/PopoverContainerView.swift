//
//  PopoverContainerView.swift
//  HNBar
//
//  Created by James on 2015-07-20.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class PopoverContainerView: NSView {
    
    private var clippingView: PopoverClippingView!
    
    var arrowX: CGFloat {
        get { return clippingView.arrowX }
        set { clippingView.arrowX = newValue }
    }
    
    var arrowWidth: CGFloat {
        get { return clippingView.arrowWidth }
        set { clippingView.arrowWidth = newValue }
    }
    
    var arrowHeight: CGFloat {
        get { return clippingView.arrowHeight }
        set { clippingView.arrowHeight = newValue }
    }
    
    var cornerRadius: CGFloat {
        get { return clippingView.cornerRadius }
        set { clippingView.cornerRadius = newValue }
    }
    
    var borderWidth: CGFloat {
        get { return clippingView.borderWidth }
        set { clippingView.borderWidth = newValue }
    }
    
    var borderColor: NSColor {
        get { return clippingView.borderColor }
        set { clippingView.borderColor = newValue }
    }
    
    var backgroundColor: NSColor = NSColor.whiteColor() {
        didSet { self.needsDisplay = true }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        clippingView = PopoverClippingView(frame: self.bounds)
        clippingView.autoresizingMask = NSAutoresizingMaskOptions.ViewHeightSizable.union(NSAutoresizingMaskOptions.ViewWidthSizable)
        self.addSubview(clippingView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        backgroundColor.set()
        NSRectFill(dirtyRect)
    }
}

class PopoverClippingView: NSView {
    var path: NSBezierPath? {
        didSet { self.needsDisplay = true }
    }
    
    var arrowX: CGFloat = 0 {
        didSet { self.needsDisplay = true }
    }
    
    var arrowWidth: CGFloat = 23 {
        didSet { self.needsDisplay = true }
    }
    
    var arrowHeight: CGFloat = 12 {
        didSet { self.needsDisplay = true }
    }
    
    var cornerRadius: CGFloat = 10 {
        didSet { self.needsDisplay = true }
    }
    
    var borderWidth: CGFloat = 1 {
        didSet { self.needsDisplay = true }
    }
    
    var borderColor: NSColor = NSColor(calibratedWhite: 0, alpha: 0.75) {
        didSet { self.needsDisplay = true }
    }
    
    func CGPathFromNSBezierPath(nsPath: NSBezierPath) -> CGPath! {
        
        if nsPath.elementCount == 0 {
            return nil
        }
        
        let path = CGPathCreateMutable()
        var didClosePath = false
        
        for i in Range(start: 0, end: nsPath.elementCount) {
            var points = [NSPoint](count: 3, repeatedValue: NSZeroPoint)
            
            switch nsPath.elementAtIndex(i, associatedPoints: &points) {
            case .MoveToBezierPathElement:CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
            case .LineToBezierPathElement:CGPathAddLineToPoint(path, nil, points[0].x, points[0].y)
            case .CurveToBezierPathElement:CGPathAddCurveToPoint(path, nil, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y)
            case .ClosePathBezierPathElement:CGPathCloseSubpath(path)
            didClosePath = true
            }
        }
        
        if !didClosePath {
            CGPathCloseSubpath(path)
        }
        
        return CGPathCreateCopy(path)
    }
    
    override func hitTest(aPoint: NSPoint) -> NSView? {
        return nil
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
        
        let currentContext = NSGraphicsContext.currentContext()?.CGContext;
        CGContextAddRect(currentContext, self.bounds);
        CGContextAddPath(currentContext, CGPathFromNSBezierPath(path));
        CGContextSetBlendMode(currentContext, .Copy);
        NSColor.clearColor().set();
        CGContextEOFillPath(currentContext);
    }
}
