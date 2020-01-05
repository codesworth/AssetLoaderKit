//
//  User.swift
//  ExampleApp
//
//  Created by Shadrach Mensah on 03/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import Foundation

struct User:Codable {
    let id:String
    let username:String
    let name:String
    let profile_image:ProfileImage
    
    var profileImageUrl:URL?{
        return URL(string: profile_image.medium)
    }
    
    var profileThumbNailUrl:URL?{
        return URL(string: profile_image.small)
    }
    
    var profileImageLargeUrl:URL?{
        return URL(string: profile_image.large)
    }
    
    struct ProfileImage:Codable {
        let small:String
        let medium:String
        let large:String
    }
    
}
