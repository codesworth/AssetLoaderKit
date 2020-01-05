//
//  SizeCalculator.swift
//  ExampleApp
//
//  Created by Shadrach Mensah on 04/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import UIKit


struct SizeCalulator {
    
    let width:CGFloat
    let height:CGFloat
    let standard:CGFloat
    
    var size:CGSize{
        let newHeight = (standard * height) / width
        return CGSize(width: standard, height: newHeight)
    }
    
    init(width:Int,height:Int,standardWidth:CGFloat) {
        self.width = CGFloat(width)
        self.height = CGFloat(height)
        standard = standardWidth
    }

}

