//
//  StoriesViewController.swift
//  HNBar
//
//  Created by James on 2015-07-20.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class StoriesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    // MARK: - Properties
    var launchAtLogin: Bool {
        get {
            return LoginItemHelper.launchAtLogin
        }
        set {
            LoginItemHelper.launchAtLogin = newValue
        }
    }
    
    // MARK: Private
    private let hackerNewsUrl = "https://news.ycombinator.com"
    
    private var isFetching = false {
        didSet {
            if isFetching {
                progressIndicator.startAnimation(nil)
            } else {
                progressIndicator.stopAnimation(nil)
            }
        }
    }
    private var stories: Array<Story> = []
    private var firebase = Firebase(url: "https://hacker-news.firebaseio.com/v0/")
    
    @IBOutlet private var tableView: NSTableView!
    @IBOutlet private var progressIndicator: NSProgressIndicator!
    
    // MARK: - View lifecycle
    override var nibBundle: NSBundle? {
        return NSBundle.mainBundle()
    }
    
    override var nibName: String? {
        return "StoriesViewController"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.registerNib(NSNib(nibNamed: StoryCell.nibName, bundle: StoryCell.nibBundle), forIdentifier: StoryCell.reuseIdentifier)
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
        tableView.reloadData()
        
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
                    let commentUrlString = "\(self.hackerNewsUrl)/item?id=\(id)";
                    
                    if let url = snapshot.value["url"] as? String where url.characters.count > 0 {
                        urlString = url
                    } else {
                        urlString = commentUrlString
                    }
                    
                    if let url = NSURL(string: urlString), commentUrl = NSURL(string: commentUrlString) {
                        self.stories.append(Story(title: title, author: author, url: url, commentCount: commentCount, commentUrl: commentUrl, score: score, type: type))
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
                    if ++storiesProcessed == ids.count {
                        self.tableView.scrollPoint(NSZeroPoint)
                        self.tableView.reloadData()
                        self.isFetching = false
                    }
                        // error
                })
            }
        }, withCancelBlock: { error in
            self.isFetching = false
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
        
        let cell = tableView.makeViewWithIdentifier(StoryCell.reuseIdentifier, owner: self) as! StoryCell
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
    @IBAction func webButtonClicked(sender: NSButton?) {
        if let url = NSURL(string: hackerNewsUrl) {
            NSWorkspace.sharedWorkspace().openURL(url)
        }
    }
    
    @IBAction func refreshButtonClicked(sender: NSButton?) {
        fetchStories()
    }
}
