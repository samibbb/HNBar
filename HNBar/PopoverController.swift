//
//  PopoverController.swift
//  HNBar
//
//  Created by James on 2015-07-20.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class PopoverController: NSObject, NSWindowDelegate {
    
    // MARK: - Public properties
    var openAnimationDuration = 0.15
    var closeAnimationDuration = 0.15
    
    var shown: Bool {
        return popoverWindow.visible
    }
    
    var contentViewController: NSViewController? {
        didSet {
            contentSize = contentViewController?.view.frame.size ?? NSZeroSize
            popoverWindow.popoverContentView = contentViewController?.view
        }
    }
    
    // MARK: Forwarded
    var arrowWidth: CGFloat {
        get { return popoverWindow.arrowWidth }
        set { popoverWindow.arrowWidth = newValue }
    }
    
    var arrowHeight: CGFloat {
        get { return popoverWindow.arrowHeight }
        set { popoverWindow.arrowHeight = newValue }
    }
    
    var cornerRadius: CGFloat {
        get { return popoverWindow.cornerRadius }
        set { popoverWindow.cornerRadius = newValue }
    }
    
    var borderWidth: CGFloat {
        get { return popoverWindow.borderWidth }
        set { popoverWindow.borderWidth = newValue }
    }
    
    var borderColor: NSColor {
        get { return popoverWindow.borderColor }
        set { popoverWindow.borderColor = newValue }
    }
    
    var backgroundColor: NSColor! {
        get { return popoverWindow.popoverBackgroundColor }
        set { popoverWindow.popoverBackgroundColor = newValue }
    }
    
    var contentSize: NSSize = NSZeroSize
    
    // MARK: - Private properties
    private var popoverWindow = PopoverWindow()
    
    // MARK: - Init
    override init() {
        super.init()
        popoverWindow.delegate = self
    }
    
    // MARK - Popover window management
    func showRelativeToRect(positioningRect: NSRect, ofView positioningView: NSView, preferredEdge: NSRectEdge) {
        if shown {
            return
        }
        
        if let window = positioningView.window {
            let frameInWindow = positioningView.convertRect(positioningRect, toView: nil)
            let presentingFrameInScreen = window.convertRectToScreen(frameInWindow)
            
            let contentRect = NSRect(origin: NSZeroPoint, size: contentSize)
            var windowFrame = popoverWindow.frameRectForContentRect(contentRect)
            windowFrame.origin = NSPoint(x: NSMidX(presentingFrameInScreen) - floor(windowFrame.size.width / 2), y: NSMinY(presentingFrameInScreen) - windowFrame.size.height)
            
            popoverWindow.alphaValue = 0
            popoverWindow.setFrame(windowFrame, display: true)
            NSApp.activateIgnoringOtherApps(true)
            popoverWindow.makeKeyAndOrderFront(nil)
            
            NSAnimationContext.beginGrouping()
            NSAnimationContext.currentContext().duration = openAnimationDuration
            popoverWindow.animator().alphaValue = 1
            NSAnimationContext.endGrouping()
        }
    }
    
    func close() {
        if !shown {
            return
        }
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = closeAnimationDuration
        popoverWindow.animator().alphaValue = 0
        NSAnimationContext.endGrouping()
        
        self.popoverWindow.orderOut(nil)
    }
    
    // MARK: - NSWindowDelegate
    func windowDidResize(notification: NSNotification) {
        popoverWindow.arrowX = self.contentSize.width / 2
    }
    
    func windowWillClose(notification: NSNotification) {
        self.close()
    }
    
    func windowDidResignKey(notification: NSNotification) {
        self.close()
    }
    
}
