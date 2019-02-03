//
//  StudentsLocations.swift
//  On The Map
//
//  Created by Hend Alkabani on 28/01/2019.
//  Copyright © 2019 Hend Alkabani. All rights reserved.
//

import Foundation

struct StudentsLocations: Codable {
    var firstName: String!
    var lastName: String!
    var latitude: Double!
    var longitude: Double!
    var mapString: String!
    var mediaURL: String! 
    
    
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
    }
    
    static func Locations(_ results: [[String:AnyObject]]) -> [StudentsLocations] {
        
        var sLocations = [StudentsLocations]()
        
        for result in results {
            sLocations.append(StudentsLocations(dictionary: result))
        }
        return sLocations
    }
    

}
