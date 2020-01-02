//
//  NetworkError.swift
//  AssetLoader
//
//  Created by Shadrach Mensah on 01/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import Foundation

struct NetworkError:Error, ExpressibleByStringLiteral {
    
    init(stringLiteral value: String) {
        localizedDescription = value
    }
    var localizedDescription: String
    
    init(_ err:Error?) {
        localizedDescription = err?.localizedDescription ?? "unknown Error occurred"
    }
}
