//
//  Protocols.swift
//  ExampleApp
//
//  Created by Shadrach Mensah on 03/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import Foundation


protocol Identity {
    
    static var Identifier:String {get}
}

extension Identity{
    
    static var Identifier: String{
        return "\(Self.self)"
    }
}
