//
//  FlickrModels.swift
//  Awesome Movies
//
//  Created by Mouhammed Ali on 7/4/19.
//  Copyright © 2019 Mouhammed Ali. All rights reserved.
//

import Foundation
class Mainphotos:Decodable {
    var photos = FlickrPhotos()
}
class FlickrPhotos:Decodable {
    var page:Int?
    var pages:Int?
    var photo:[photoItem]?
}
class photoItem:Decodable {
    var farm:Int?
    var id:String?
    var owner:String?
    var secret:String?
    var server:String?
    var title:String?
    func getPhoto()->String{
        return "https://farm\(farm ?? 0).staticflickr.com/\(server ?? "")/\(id ?? "")_\(secret ?? "").jpg"
    }
}
