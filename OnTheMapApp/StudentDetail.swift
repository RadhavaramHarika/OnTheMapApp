//
//  StudentLocation.swift
//  OnTheMapApp
//
//  Created by radhavaram harika on 12/20/16.
//  Copyright © 2016 Practise. All rights reserved.
//

import Foundation

struct StudentDetail
{
    let createdAt:String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
    
    init(dictionary: [String:AnyObject])
    {
        createdAt = dictionary[UdacityClient.ResponseKeys.createdAt] != nil ? dictionary[UdacityClient.ResponseKeys.createdAt] as? String:""
        firstName = dictionary[UdacityClient.ResponseKeys.firstName] != nil ? dictionary[UdacityClient.ResponseKeys.firstName] as? String:""
        lastName = dictionary[UdacityClient.ResponseKeys.lastName] != nil ? dictionary[UdacityClient.ResponseKeys.lastName] as? String:""
        latitude = dictionary[UdacityClient.ResponseKeys.latitude] != nil ? dictionary[UdacityClient.ResponseKeys.latitude] as? Double:0
        longitude = dictionary[UdacityClient.ResponseKeys.longitude] != nil ? dictionary[UdacityClient.ResponseKeys.longitude] as? Double:0
        mapString = dictionary[UdacityClient.ResponseKeys.mapString] != nil ? dictionary[UdacityClient.ResponseKeys.mapString] as? String:""
        mediaURL = dictionary[UdacityClient.ResponseKeys.mediaURL] != nil ? dictionary[UdacityClient.ResponseKeys.mediaURL] as? String:""
        objectId = dictionary[UdacityClient.ResponseKeys.objectId] != nil ? dictionary[UdacityClient.ResponseKeys.objectId] as? String:""
        uniqueKey = dictionary[UdacityClient.ResponseKeys.uniqueKey] != nil ? dictionary[UdacityClient.ResponseKeys.uniqueKey] as? String:""
        updatedAt = dictionary[UdacityClient.ResponseKeys.updatedAt] != nil ? dictionary[UdacityClient.ResponseKeys.updatedAt] as? String:""
    
    }
    
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [StudentDetail]
    {
        var studentLocations = StudentLocations.sharedInstance.studentLocations
        
        for eachLocation in results
        {
            studentLocations.append(StudentDetail(dictionary: eachLocation))
        }
        return studentLocations
    }
}

