//
//  PopoverWindow.swift
//  HNBar
//
//  Created by James on 2015-07-20.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class PopoverWindow: NSWindow {
    
    // MARK: Forwarded properties
    var arrowX: CGFloat {
        get { return popoverContainerView.arrowX }
        set { popoverContainerView.arrowX = newValue }
    }
    
    var arrowWidth: CGFloat {
        get { return popoverContainerView.arrowWidth }
        set { popoverContainerView.arrowWidth = newValue }
    }
    
    var arrowHeight: CGFloat {
        get { return popoverContainerView.arrowHeight }
        set { popoverContainerView.arrowHeight = newValue }
    }
    
    var cornerRadius: CGFloat {
        get { return popoverContainerView.cornerRadius }
        set { popoverContainerView.cornerRadius = newValue }
    }
    
    var borderWidth: CGFloat {
        get { return popoverContainerView.borderWidth }
        set { popoverContainerView.borderWidth = newValue }
    }
    
    var borderColor: NSColor {
        get { return popoverContainerView.borderColor }
        set { popoverContainerView.borderColor = newValue }
    }
    
    var popoverBackgroundColor: NSColor! {
        get { return popoverContainerView.backgroundColor }
        set { popoverContainerView.backgroundColor = newValue }
    }
    
    // MARK: Properties
    private var popoverContainerView = PopoverContainerView()
    
    var popoverContentView: NSView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            if let popoverContentView = popoverContentView {
                let bounds = NSRect(origin: NSZeroPoint, size: self.frame.size)
                popoverContentView.frame = contentRectForFrameRect(bounds)
                popoverContentView.autoresizingMask = NSAutoresizingMaskOptions.ViewHeightSizable.union(NSAutoresizingMaskOptions.ViewWidthSizable)
                popoverContainerView.clippingView.addSubview(popoverContentView)
            }
        }
    }
    
    override var canBecomeKeyWindow: Bool {
        return true
    }
    
    // MARK: - Init
    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, `defer` flag: Bool) {
        super.init(contentRect: contentRect, styleMask: NSBorderlessWindowMask, backing: bufferingType, `defer`: flag)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        opaque = false
        backgroundColor = NSColor.clearColor()
        hasShadow = true
        contentView = self.popoverContainerView
    }
    
    // MARK: - Helpers
    override func contentRectForFrameRect(var windowFrame: NSRect) -> NSRect {
        windowFrame.size.height -= arrowHeight
        return NSInsetRect(windowFrame, borderWidth, borderWidth)
    }
    
    override func frameRectForContentRect(var contentRect: NSRect) -> NSRect {
        contentRect.size.height += arrowHeight
        return NSInsetRect(contentRect, -borderWidth, -borderWidth)
    }
}
