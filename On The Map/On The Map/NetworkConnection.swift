//
//  NetworkConnection.swift
//  On The Map
//
//  Created by Hend Alkabani on 27/01/2019.
//  Copyright © 2019 Hend Alkabani. All rights reserved.
//

import Foundation

class NetworkConnection {
    private static var sessionId: String?
    
    static func postTheSession(email: String, password: String, completion: @escaping (String?)->Void){
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                completion("There was an error with your request")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completion("No data was returned by the request!")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    
                    let range = 5..<data.count
                    let newData = data.subdata(in: range) /* subset response data! */
                    
                    if let json = try? JSONSerialization.jsonObject(with: newData, options: []),
                        let obj = json as? [String:Any],
                        let accountObj = obj["account"] as? [String: Any],
                        let sessionObj = obj["session"] as? [String: Any]{
                        
                        AppDelegate.user.setKey(key: accountObj["key"] as! String)
                        self.sessionId = sessionObj["id"] as? String
                        
                        self.getUserInformations(completion: { err in
                            
                        })
                        
                    } else { //Err in parsing data
                        completion("Couldn't parse response")
                        return
                    }
                } else { //Err in given login credintials
                    completion("Provided login credintials didn't match our records")
                    return
                }
            } else { //Request failed to sent
                completion("Check your internet connection")
                return
            }
            completion(nil)
        }
        task.resume()
    }
    
    
    static func getUserInformations(completion: @escaping (String?)->Void) {
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(AppDelegate.user.key ?? "")")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                completion("There was an error with your request")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completion("No data was returned by the request!")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    
                    let range = 5..<data.count
                    let newData = data.subdata(in: range) /* subset response data! */
                    print(String(data: newData, encoding: .utf8)!)
                    if let json = try? JSONSerialization.jsonObject(with: newData, options: []),
                        let obj = json as? [String: AnyObject],
                        let firstName = obj["first_name"] as? String,
                        let lastName = obj["last_name"] as? String {
                        AppDelegate.user.setInformations(firstName: firstName, lastName: lastName)
                        
                    } else { //Err in parsing data
                        completion("Couldn't parse response")
                    }
                } else { //Err in given login credintials
                    completion("Provided login credintials didn't match our records")
                }
                completion(nil)
            }
            
        }
        task.resume()
    }
    
    
    static func getStudentsLocations(completion: @escaping (String?)->Void) {
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            guard (error == nil) else {
                completion("There was an error with your request")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completion("No data was returned by the request!")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                        let obj = json as? [String: AnyObject],
                        let results = obj["results"] as? [[String : Any]] {
                        Locations.studentsInfo = StudentsLocations.Locations(results as [[String : AnyObject]])
                    }
                } else { //Err in given login credintials
                    completion("Provided login credintials didn't match our records")
                }
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    static func putStudentLocation(lat: Double, lon: Double, mapString: String, mediaURL: String, completion: @escaping (String?)->Void){
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(AppDelegate.user.key!)\", \"firstName\": \"\(AppDelegate.user.firstName!)\", \"lastName\": \"\(AppDelegate.user.lastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(lat), \"longitude\": \(lon)}".data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                completion("There was an error with your request")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completion("No data was returned by the request!")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    
                    let range = 5..<data.count
                    let newData = data.subdata(in: range) /* subset response data! */
                    print(String(data: newData, encoding: .utf8)!)
                    
                    
                } else { //Err in parsing data
                    completion("Couldn't parse response")
                }
            } else { //Err in given login credintials
                completion("Provided login credintials didn't match our records")
            }
            
            completion(nil)
        }
        task.resume()
    }
    
    
    
    static func logout(completion: @escaping (String?)->Void){
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                completion("There was an error with your request")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completion("No data was returned by the request!")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    
                    let range = 5..<data.count
                    let newData = data.subdata(in: range) /* subset response data! */
                    print(String(data: newData, encoding: .utf8)!)
                    
                    
                } else { //Err in parsing data
                    completion("Couldn't parse response")
                }
            } else { //Err in given login credintials
                completion("Provided login credintials didn't match our records")
            }
            
            completion(nil)
        }
        task.resume()
    }
    
}
