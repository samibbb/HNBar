//
//  HackerNewsViewController.swift
//  HNBar
//
//  Created by James on 2015-07-20.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class HackerNewsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    private let hackerNewsUrl = "https://news.ycombinator.com"
    
    // MARK: Firebase properties
    private var isFetching = false
    private var stories: Array<Story> = Array()
    private var firebase = Firebase(url: "https://hacker-news.firebaseio.com/v0/")
    
    // MARK: Views
    @IBOutlet private var separatorView: ColorView!
    @IBOutlet private var tableView: NSTableView!
    @IBOutlet private var scrollView: NSScrollView!
    
    // MARK: - View lifecycle
    override var nibBundle: NSBundle? {
        return NSBundle.mainBundle()
    }
    
    override var nibName: String? {
        return "HackerNewsViewController"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorView.backgroundColor = NSColor(colorLiteralRed: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        
        tableView.registerNib(NSNib(nibNamed: "HackerNewsStoryCell", bundle: NSBundle.mainBundle()), forIdentifier: "HackerNewsStoryCell")
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if stories.count == 0 {
            fetchStories()
        }
    }
    
    // MARK: - Story fetching
    func fetchStories() {
        if isFetching {
            return
        }
        
        isFetching = true
        stories = []
        
        var storiesProcessed = 0
        
        let storiesRef = firebase.childByAppendingPath("topstories").queryLimitedToFirst(50)
        storiesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            let ids = snapshot.value as! [Int]
            for id in ids {
                let itemRef = self.firebase.childByAppendingPath("item").childByAppendingPath(String(id))
                itemRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    let title = snapshot.value["title"] as! String
                    let author = snapshot.value["by"] as! String
                    let commentCount = snapshot.value["descendants"] as? Int
                    let score = snapshot.value["score"] as! Int
                    let type = snapshot.value["type"] as! String
                    
                    var urlString = ""
                    
                    if let url = snapshot.value["url"] as? String where url.characters.count > 0 {
                        urlString = url
                    } else {
                        urlString = "\(self.hackerNewsUrl)/item?id=\(id)"
                    }
                    
                    if let url = NSURL(string: urlString) {
                        self.stories.append(Story(title: title, author: author, url: url, commentCount: commentCount, score: score, type: type))
                    }
                    else {
                        // error
                    }
                    
                    if ++storiesProcessed == ids.count {
                        self.tableView.scrollPoint(NSZeroPoint)
                        self.tableView.reloadData()
                        self.isFetching = false
                    }
                    
                    }, withCancelBlock: { error in
                        // error
                })
            }
            }, withCancelBlock: { error in
                self.isFetching = false
                // error
        })
    }
    
    // MARK: - NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return stories.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if row >= stories.count {
            return nil
        }
        
        let cell = tableView.makeViewWithIdentifier("HackerNewsStoryCell", owner: self) as! HackerNewsStoryCell
        cell.populate(stories[row])
        return cell
    }
    
    // MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(notification: NSNotification) {
        let row = tableView.selectedRow
        
        if row < 0 || row >= stories.count {
            return
        }
        
        let story = stories[row]
        NSWorkspace.sharedWorkspace().openURL(story.url)
        tableView.deselectAll(self)
    }
    
    // MARK: - Button handlers
    @IBAction func webButtonClicked(sender: AnyObject?) {
        if let url = NSURL(string: hackerNewsUrl) {
            NSWorkspace.sharedWorkspace().openURL(url)
        }
    }
    
    @IBAction func refreshButtonClicked(sender: AnyObject?) {
        fetchStories()
    }
}
