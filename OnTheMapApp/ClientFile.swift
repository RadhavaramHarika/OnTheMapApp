//
//  ClientFile.swift
//  OnTheMapApp
//
//  Created by radhavaram harika on 12/20/16.
//  Copyright © 2016 Practise. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient
{
    func getSessionID(userName: String, password: String, completionHandlerForSession: @escaping(_ results:AnyObject?,_ error: NSError?) -> Void)
    {
        let jsonBody = "{\"\(jsonBodyKeys.udacityKey)\":{\"\(jsonBodyKeys.userNameKey)\":\"\(userName)\",\"\(jsonBodyKeys.passwordKey)\":\"\(password)\"}}"
        let dict = [jsonBodyKeys.userNameKey:userName,
                    jsonBodyKeys.passwordKey:password]
        let task = taskToPOSTSession(jsonBody:dict) {(results, error) in
            
            if error != nil
            {
                completionHandlerForSession(nil,error)
            }
            else
            {
                
                if let sessionResults = results as? [String:AnyObject]
                {
                    if let accounts = sessionResults[ResponseKeys.account] as? [String:AnyObject]
                    {
                        if let userKey = accounts[ResponseKeys.key] as? String
                        {
                            self.userID = userKey
                        }
                    }
                    if let session = sessionResults[ResponseKeys.session] as? [String:AnyObject]
                    {
                        if let sessionID = session["id"] as? String
                        {
                            self.sessionId = sessionID
                        }
                    }
                    completionHandlerForSession(sessionResults as AnyObject,nil)
                                        
                }
                else
                {
                    completionHandlerForSession(nil,error)
                }
                
            }
        }
    }
    
    
    func deletingSessionId(completionHandlerFordeletingSession:@escaping(_ results:AnyObject?,_ error:NSError?) -> Void)
    {
        let methodString = Methods.session
        
        let task = taskForDELETESessionID(methodString) {(results,error) in
            
            if error != nil
            {
                completionHandlerFordeletingSession(nil,error)
            }
            else
            {
                if let resultedData = results
                {
                    completionHandlerFordeletingSession(resultedData,nil)
                }
                else
                {
                    completionHandlerFordeletingSession(nil,NSError(domain: "deletingSessionId", code: 1, userInfo:[NSLocalizedDescriptionKey:"Could not parse the data"]))
                }
            }
            
        }
    }
    
    func getStudentLocations(parameters: [String:AnyObject]?,completionHandlerForGETStudentLocation: @escaping(_ results: AnyObject?,_ error: NSError?) -> Void)
    {
        let methodString = Methods.parseClass
        let task = taskForGETStudentLocations(method: methodString, parameters: [:]) {(results, error) in
            
            if error != nil
            {
                completionHandlerForGETStudentLocation(nil,error)
            }
            else
            {
                if let studentResults = results?[ResponseKeys.results]
                {
                    let studentLocations = StudentLocation.studentLocationsFromResults(studentResults as! [[String : AnyObject]])
                    completionHandlerForGETStudentLocation(studentLocations as AnyObject?,nil)
                }
                else
                {
                    completionHandlerForGETStudentLocation(nil,NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse the data"]))
                }
            }
            
        }
    }
    
    func postStudentLocation(student: StudentLocation,completionHandlerForPostingStudentLocation:@escaping(_ results: AnyObject?,_ error: NSError?) -> Void)
    {
        let methodString = Methods.parseClass
        let jsonBody = "{\"\(ResponseKeys.uniqueKey)\":\"\(student.uniqueKey)\",\"\(ResponseKeys.firstName)\":\"\(student.firstName)\",\"\(ResponseKeys.lastName):\"\(student.lastName)\",\"\(ResponseKeys.mapString)\":\"\(student.mapString)\",\"\(ResponseKeys.mediaURL)\":\"\(student.mediaURL)\",\"\(ResponseKeys.latitude)\":\"\(student.latitude)\",\"\(ResponseKeys.longitude)\":\"\(student.longitude)\"}"
        let task = taskToPOSTStudentLocation(method: methodString, jsonBody: jsonBody) {(results, error) in
            
            if error != nil
            {
                completionHandlerForPostingStudentLocation(nil,error)
            }
            else
            {
                if let resultedData = results as? [String:AnyObject]
                {
                    completionHandlerForPostingStudentLocation(resultedData as AnyObject?,nil)
                }
                else
                {
                    completionHandlerForPostingStudentLocation(nil,NSError(domain: "postStudentLocation parsing", code: 1,userInfo:[NSLocalizedDescriptionKey: "Could not parse the data"]))
                }
            }
        }
    }
    
    func updateStudentLocation(student: StudentLocation,completionHandlerForUpdatingStudentLocation: @escaping(_ results:AnyObject?,_ error: NSError?) -> Void)
    {
        let methodString = Methods.parseClass+"/\(student.objectId)"
        print(method)
        
        let jsonBody = "{\(ResponseKeys.uniqueKey):\(student.uniqueKey),\(ResponseKeys.firstName):\(student.firstName),\(ResponseKeys.lastName):\(student.lastName),\(ResponseKeys.mapString):\(student.mapString),\(ResponseKeys.mediaURL):\(student.mediaURL),\(ResponseKeys.latitude):\(student.latitude),\(ResponseKeys.longitude):\(student.longitude)}"
        
        let task = taskForPUTStudentLocation(method: methodString, jsonBody: jsonBody) {(results,error) in
            
            if error != nil
            {
                completionHandlerForUpdatingStudentLocation(nil,error)
            }
            else
            {
                if let resultedData = results
                {
                    completionHandlerForUpdatingStudentLocation(resultedData,nil)
                }
                else
                {
                    completionHandlerForUpdatingStudentLocation(nil,NSError(domain: "updateStudentLocation", code:1, userInfo: [NSLocalizedDescriptionKey:"Cannot parse the data"]))
                }
            }
        }
    }
    
    private func convertData(_ data: Data, completionHandlerForConvertData: (_ result:AnyObject?,_ error: NSError?) -> Void)
    {
        var parsedData:[String: AnyObject]! = nil
        do{
            parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
        }
        catch{
            let userInfo = [NSLocalizedDescriptionKey: "Cannot parse the \(data) into json Format"]
            completionHandlerForConvertData(nil,NSError(domain:"convertDataWithCompletionHandler", code:1,userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedData as AnyObject?,nil)
    }
    
}
