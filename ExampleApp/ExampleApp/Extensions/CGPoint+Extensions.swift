//
//  CGPoint+Extensions.swift
//  ExampleApp
//
//  Created by Shadrach Mensah on 05/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import Foundation



import UIKit



extension CGPoint:ExpressibleByArrayLiteral{
    
    public typealias ArrayLiteralElement = CGFloat
    
    public init(arrayLiteral elements: CGFloat...) {
        if elements.count > 1{
            self = CGPoint(x: elements.first!, y: elements.last!)
        }else{
            if elements.isEmpty{
                self = CGPoint.zero
            }else{
                self = CGPoint(x: elements.first!, y: elements.first!)
            }
        }
    }
}

extension CGPoint{
    
    

    
    static func -(_ lhs:CGPoint, rhs:CGPoint)->CGPoint{
        return lhs -= rhs
    }
    
    static func +(_ lhs:CGPoint, rhs:CGPoint)->CGPoint{
        return lhs += rhs
    }
    
    static func +=(_ lhs:CGPoint, rhs:CGPoint)->CGPoint{
        return [lhs.x + rhs.x, lhs.y + rhs.y]
    }
    
    static func -=(_ lhs:CGPoint, rhs:CGPoint)->CGPoint{
        return [lhs.x - rhs.x, lhs.y - rhs.y]
    }
    
}

