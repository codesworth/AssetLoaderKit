//
//  Cursor.swift
//  AssetLoader
//
//  Created by Shadrach Mensah on 03/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import Foundation


public struct Cursor<Object:Codable>{
    
    public typealias SortOrder = (Object,Object) -> Bool
    let limit:Int
    let sortOrder:SortOrder
    var range:CountableRange<Int>
    
    init(limit:Int,sortOrder:@escaping SortOrder) {
        self.limit = limit
        self.sortOrder = sortOrder
        range = 0..<limit
    }
    
    public mutating func next(){
        range = range.endIndex..<range.endIndex.advanced(by: limit)
    }
    
}
