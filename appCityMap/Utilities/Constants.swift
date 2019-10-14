//
//  Constants.swift
//  appCityMap
//
//  Created by Dante on 2019/10/14.
//  Copyright © 2019 cinderella. All rights reserved.
//

import Foundation

let apiKey = "1a7a1a2178e7aec50e7ff314e596561b"

func flickrUrl(forApiKey key:String,withAnnotation annotation:DroppablePin,andNumberOfPhotos number:Int) ->String{
    let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
    print(url)
    return url
    
    
}

