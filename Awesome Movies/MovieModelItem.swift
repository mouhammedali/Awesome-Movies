//
//  MovieModelItem.swift
//  Awesome Movies
//
//  Created by Mouhammed Ali on 6/28/19.
//  Copyright © 2019 Mouhammed Ali. All rights reserved.
//

import Foundation
struct MovieModelItem: Decodable {
    var title:String?
    var year:Int?
    var cast:[String]?
    var genres:[String]?
    var rating:Double?
}
struct MovieModel:Decodable {
    var movies:[MovieModelItem]?
}
