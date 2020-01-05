//
//  UIView+Extensions.swift
//  ExampleApp
//
//  Created by Shadrach Mensah on 04/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import UIKit

extension UIView{
    func dropShadow(_ radius:CGFloat = 2.0, color:UIColor = .black, _ opacity:Float = 0.4, _ offset:CGSize = .init(width: 0, height: 4)){
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
    }
    
    func dropCorner(_ radius:CGFloat = 3.0){
        layer.cornerRadius = radius
    }
}
