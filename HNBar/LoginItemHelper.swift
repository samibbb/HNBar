//
//  LoginItemHelper.swift
//  HNBar
//
//  Created by James on 2015-07-24.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Foundation

struct LoginItemHelper {
    
    private static var sharedFileList: LSSharedFileList? {
        return LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeUnretainedValue(), nil)?.takeRetainedValue()
    }
    
    private static var exitingItem: LSSharedFileListItem? {
        if let list = sharedFileList {
            let loginItems = LSSharedFileListCopySnapshot(list, nil).takeRetainedValue() as NSArray as! [LSSharedFileListItem]
            for item in loginItems {
                if let itemUrlRef = LSSharedFileListItemCopyResolvedURL(item, 0, nil) {
                    let itemUrl = itemUrlRef.takeRetainedValue() as NSURL
                    if itemUrl.isEqual(NSBundle.mainBundle().bundleURL) {
                        return item
                    }
                }
            }
        }
        
        return nil
    }

    static var launchAtLogin: Bool {
        get {
            return exitingItem != nil
        }
        set {
            if newValue {
                if let list = sharedFileList {
                    LSSharedFileListInsertItemURL(list, kLSSharedFileListItemBeforeFirst.takeUnretainedValue(), nil, nil, NSBundle.mainBundle().bundleURL, nil, nil)
                }
            } else {
                if let list = sharedFileList, item = exitingItem {
                    LSSharedFileListItemRemove(list, item)
                }
            }
        }
    }
}