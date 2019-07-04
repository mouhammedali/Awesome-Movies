//
//  FlickrApiHelper.swift
//  Awesome Movies
//
//  Created by Mouhammed Ali on 7/1/19.
//  Copyright © 2019 Mouhammed Ali. All rights reserved.
//

import Foundation
import Alamofire

class FlickrApiHelper {
    private let apiKey = "fb8f1ba87906032b4529e546417f2309"
    var isLoading = false
    var isNext = true
    var titleUrlified = ""
    init(title:String) {
        
        self.titleUrlified = (title).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    var flickrPhotos = FlickrPhotos()
    func getImages(completionhandler:@escaping (Int?) -> ()){
        if isLoading {
            return
        }
        isLoading = true
        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(titleUrlified)&page=\(flickrPhotos.page ?? 1)&per_page=30&tags=movie&format=json&nojsoncallback=1"


        Alamofire.request(url, method: .get, parameters:nil , encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse) in
            switch(response.result) {
            case .success(let value):
                print(value)
                do {
                    let mainphotos = try JSONDecoder().decode(Mainphotos.self, from: response.data ?? Data())
                    if self.flickrPhotos.photo?.count == 0 || self.flickrPhotos.photo == nil {
                        self.flickrPhotos = mainphotos.photos
                    }else{
                        self.flickrPhotos.photo = (self.flickrPhotos.photo ?? [photoItem]()) + (mainphotos.photos.photo ?? [photoItem]())
                        self.flickrPhotos.page = mainphotos.photos.page ?? 0
                    }
                    print(self.flickrPhotos.pages)
                    print(mainphotos.photos.page)
                    if (mainphotos.photos.page ?? 0) >= (self.flickrPhotos.pages ?? 1) {
                        self.isNext = false
                    }else{
                        self.flickrPhotos.page = 1 + (self.flickrPhotos.page ?? 1)
                    }
                    
                } catch {
                    print(error)
                    
                }
                
            case .failure(let error):
                print(error)
            }
            completionhandler(response.response?.statusCode)
            self.isLoading = false
        }
    }
}

