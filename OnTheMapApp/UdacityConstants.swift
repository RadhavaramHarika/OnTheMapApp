//
//  UdacityConstants.swift
//  OnTheMapApp
//
//  Created by radhavaram harika on 12/19/16.
//  Copyright © 2016 Practise. All rights reserved.
//

import Foundation


extension UdacityClient{
    
    
    struct Constants
    {
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
        static let getSessionURL = "https://www.udacity.com/api"
        
    }
    
    struct  Methods
    {
        static let session = "/session"
        static let parseClass = "classes/StudentLocation"
        static let users = "/users"

    }
    
    struct jsonBodyKeys
    {
        static let udacityKey = "udacity"
        static let userNameKey = "username"
        static let passwordKey = "password"
    }
    
    struct HttpValues
    {
        static let jsonValue = "application/json"
        
        static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let parseRestApi = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct JSONKeys
    {
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
    }
    
    struct HttpFields
    {
        static let acceptField = "Accept"
        static let contentTypeField = "Content-Type"
        
        static let parseAppIDKey = "X-Parse-Application-Id"
        static let parseRestAPIKey = "X-Parse-REST-API-Key"
    }
    
    struct ParameterKeys
    {
        static let limitKey = "limit"
        static let skipKey = "skip"
        static let orderKey = "order"
        
    }
    
    struct ParameterValues
    {
        static let limitValue = "100"
        static let skipValue = "400"
        static let orderValue = "-updatedAt"
    }
    
    
    struct ResponseKeys
    {
        static let results = "results"
        
        static let createdAt = "createdAt"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let updatedAt = "updatedAt"
        
        static let account = "account"
        static let registered = "registered"
        static let key = "key"
        
        static let session = "session"
        static let sessionId = "id"
        static let expiration = "expiration"
        
    }
    
}
