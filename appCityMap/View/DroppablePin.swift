//
//  DroppablePin.swift
//  appCityMap
//
//  Created by Dante on 2019/10/13.
//  Copyright © 2019 cinderella. All rights reserved.
//

import Foundation
import MapKit

class DroppablePin:NSObject,MKAnnotation{
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate:CLLocationCoordinate2D,identifier:String){
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
    
}
