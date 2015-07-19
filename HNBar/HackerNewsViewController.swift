//
//  HackerNewsViewController.swift
//  HNBar
//
//  Created by James on 2015-07-19.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class HackerNewsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    struct Story {
        var title: String
        var author: String
        var url: NSURL
        var commentCount: Int
        var score: Int
    }
    
    @IBOutlet var tableView: NSTableView!
    
    private var isFetching = false
    private var stories: Array<Story> = Array()
    private var firebase: Firebase!
    
    override var nibName: String? {
        return "HackerNewsViewController"
    }
    
    override var nibBundle: NSBundle? {
        return NSBundle.mainBundle()
    }
    
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        firebase = Firebase(url: "https://hacker-news.firebaseio.com/v0/")
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        fetchNews()
    }
    
    func fetchNews() {
        if isFetching {
            return
        }
        
        isFetching = true
        stories = []
        
        var storiesProcessed = 0
        
        let storiesRef = firebase.childByAppendingPath("topstories").queryLimitedToNumberOfChildren(50)
        storiesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            let ids = snapshot.value as! [String:Int];
            for id in ids.values {
                let itemRef = self.firebase.childByAppendingPath("item").childByAppendingPath(String(id))
                itemRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    let title = snapshot.value["title"] as! String
                    let author = snapshot.value["by"] as! String
                    let commentCount = snapshot.value["descendants"] as! Int
                    let score = snapshot.value["score"] as! Int
                    
                    var urlString = ""
                    
                    if let url = snapshot.value["url"] as? String {
                         urlString = url
                    } else {
                        urlString = "https://news.ycombinator.com/item?id=\(id)"
                    }
                    
                    if let url = NSURL(string: urlString) {
                        self.stories.append(Story(title: title, author: author, url: url, commentCount: commentCount, score: score))
                    }
                    else {
                        // error
                    }
                    
                    if ++storiesProcessed == ids.count {
                        self.tableView.reloadData()
                    }
                    
                    }, withCancelBlock: { error in
                        // error
                });
            }
            }, withCancelBlock: { error in
                // error
        });
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return stories.count
    }
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return nil
    }
    
}
