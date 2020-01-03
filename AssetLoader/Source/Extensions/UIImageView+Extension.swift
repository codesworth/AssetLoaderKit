//
//  UIImageView+Extension.swift
//  AssetLoader
//
//  Created by Shadrach Mensah on 03/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import UIKit

extension UIImageView{
    
    func setImage(for url:URL, placeHolder:UIImage? = nil){
        image = placeHolder
        AssetManager().downloadImage(for: url) {[weak self] image, err in
            if let err = err{
                AssetLoaderLogger.log(err: err, in: "UIImageView.setImage(for:) extension")
            }
            self?.image = image
        }
    }
    
}
