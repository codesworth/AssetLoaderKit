//
//  MindValleyPin.swift
//  ExampleApp
//
//  Created by Shadrach Mensah on 02/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import Foundation

typealias MindValleyPins = [MindValleyPin]

let formatForDate = "yyyy-MM-dd'T'HH:mm:ssZ"
struct MindValleyPin:Codable {
    
    
    
    let id:String
    let created_at:String
    let width:Int
    let height:Int
    let color:String
    let likes:Int
    let liked_by_user:Bool
    let user:User
    let urls:PinURLS
    
    let categories: [PinCategory]
    
    var dateCreated:Date{
        let dateFormtter = DateFormatter()
        dateFormtter.dateFormat = formatForDate
        dateFormtter.locale = .init(identifier: "en_US")
        return dateFormtter.date(from: created_at)!
    }
    
    
}


extension MindValleyPin{
    struct PinURLS:Codable {
        
        let raw:String
        let full:String
        let regular:String
        let small:String
        let thumb:String
        
        var rawURL:URL?{
           return URL(string: raw)
        }
        
        var smallUrl:URL?{
            return URL(string: small)
        }
        
        var regularUrl:URL?{
            return URL(string: regular)
        }
        
        var fullUrl:URL?{
            return URL(string: full)
        }
        
    }


    struct PinCategory:Codable {
        let id:Int
        let title:String
        let photo_count:Int
        
    }
}



extension MindValleyPin:Comparable{
    
    static func < (lhs: MindValleyPin, rhs: MindValleyPin) -> Bool {
        return lhs.dateCreated < rhs.dateCreated
    }
    
    static func == (lhs: MindValleyPin, rhs: MindValleyPin) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    
}
