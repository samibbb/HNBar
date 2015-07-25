//
//  Story.swift
//  HNBar
//
//  Created by James on 2015-07-20.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Foundation

struct Story {
    var title: String
    var author: String
    var url: NSURL
    var commentCount: Int?
    var commentUrl: NSURL
    var score: Int
    var type: String
}