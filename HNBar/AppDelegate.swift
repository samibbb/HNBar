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
    
    let popover = PopoverController()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    let hackerNewsViewController = HackerNewsViewController()
//    let panelController = HackerNewsPanelController()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "YCombinatorTemplate")
            button.action = Selector("togglePopover:")
        }
        
        popover.contentViewController = hackerNewsViewController
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
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

