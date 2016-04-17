//
//  Day.swift
//  Mosum
//
//  Created by Hassan Talat on 4/11/16.
//  Copyright © 2016 Buff Apps. All rights reserved.
//

import Foundation

class Day {
    
    var time:NSDate
    var temperature:Double
    var icon:String
    var summary:String
    
    init(time:NSDate,temp:Double,icon:String,summary:String)
    {
        self.time = time
        self.temperature = temp
        self.icon = icon
        self.summary = summary
    }
}