//
//  Program.swift
//  NXT_Programming
//
//  Created by Erick Chong on 11/1/17.
//  Copyright © 2017 LA's BEST. All rights reserved.
//

import UIKit
import RealmSwift

// Time since 0001-01-01 measure in 100-nanosecond intervals to create unique id and for easy sorting
extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

class Program: Object {
    dynamic var name = ""
    dynamic var json = ""
    dynamic var id = UUID().uuidString
    // date indicates the date when the object was first created
    dynamic var date: Int64 = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
