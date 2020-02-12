//
//  Item.swift
//  Schedule List
//
//  Created by Greg Wu on 11/2/19.
//  Copyright © 2019 Greg Wu. All rights reserved.
//

import Foundation

// Create struct for custom Item list objects

struct Item: Codable {
    var description: String
    var complete: Bool
}
