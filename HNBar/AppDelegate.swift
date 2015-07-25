//
//  AppDelegate.swift
//  HNBar
//
//  Created by James on 2015-07-19.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let popover = PopoverController()
    private let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    private let storiesViewController = StoriesViewController()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "YCombinatorTemplate")
            button.action = Selector("togglePopover:")
        }
        
        popover.contentViewController = storiesViewController
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: .MinY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.close()
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        }
        else {
            showPopover(sender)
        }
    }

}

