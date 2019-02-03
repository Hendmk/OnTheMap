//
//  User.swift
//  On The Map
//
//  Created by Hend Alkabani on 27/01/2019.
//  Copyright © 2019 Hend Alkabani. All rights reserved.
//

import Foundation
class User {
    var key: String!
    var firstName: String!
    var lastName: String!
    var latitude: Double!
    var longitude: Double!
    var mapString: String!
    var mediaURL: String!

    func setKey(key: String){
        self.key = key
    }

    func setInformations(firstName: String, lastName: String){
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func clearUser() {
        key = nil
        firstName = nil
        lastName = nil
        latitude = nil
        longitude = nil
        mapString = nil
        mediaURL = nil
    }
}
