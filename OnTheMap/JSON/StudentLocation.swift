//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by AMJAD - on 13/03/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import Foundation
import UIKit



struct StudentLocation: Codable {
   static var studentsList = [StudentLocation()]
    var createdAt : String?
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mapString : String?
    var mediaURL : String?
    var objectId : String?
    var uniqueKey : String?
    var updatedAt : String?
    
    func getData( dataJson:[String: Any] ) -> (StudentLocation) {
        var sLocation = StudentLocation()
        sLocation.createdAt = dataJson["createdAt"] as? String ?? ""
        sLocation.firstName = dataJson["firstName"] as? String ?? ""
        sLocation.lastName = dataJson["lastName"] as? String ?? ""
        sLocation.latitude = dataJson["latitude"] as? Double ?? 0.0
        sLocation.longitude = dataJson["longitude"] as? Double ?? 0.0
        sLocation.mapString = dataJson["mapString"] as? String ?? ""
        sLocation.mediaURL = dataJson["mediaURL"] as? String ?? ""
        sLocation.objectId = dataJson["objectId"] as? String ?? ""
        sLocation.uniqueKey = dataJson["uniqueKey"] as? String ?? ""
        sLocation.updatedAt = dataJson["updatedAt"] as? String ?? ""
        
        return sLocation
    }
}


extension StudentLocation {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
}




