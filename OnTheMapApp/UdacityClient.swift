//
//  UdacityClient.swift
//  OnTheMapApp
//
//  Created by radhavaram harika on 12/18/16.
//  Copyright © 2016 Practise. All rights reserved.
//

import UIKit
import Foundation

class UdacityClient: NSObject
{
    
    var sharedSession = URLSession.shared
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override init()
    {
        super.init()
    }
    
    func taskToPOSTSession(jsonBody:[String:String], completionHandlerForSessionID:@escaping(_ result:AnyObject?,_ error:NSError?)-> Void) -> URLSessionDataTask
    {
        let userInfo = [jsonBodyKeys.udacityKey:jsonBody]
        var info: Data!
        do{
            info = try JSONSerialization.data(withJSONObject: userInfo, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        catch
        {
            print("Cannot encode the data")
            
        }
        
        let method = Methods.session
        let urlString = Constants.getSessionURL + method
        let sessionURL = URL(string: urlString)
        let request = NSMutableURLRequest(url:sessionURL!)
        request.httpMethod = "POST"
        request.addValue(HttpValues.jsonValue, forHTTPHeaderField: HttpFields.acceptField)
        request.addValue(HttpValues.jsonValue, forHTTPHeaderField: HttpFields.contentTypeField)
        request.httpBody = info /*jsonBody.data(using: String.Encoding.utf8)*/
        
        let task = sharedSession.dataTask(with: request as URLRequest) {(data,response,error) in
            
            if error != nil{
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForSessionID(nil,NSError(domain:"taskToPOSTSession", code: 1, userInfo:userInfo))
            }
            
            guard let data = data else {
                print("Could not find the data")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            self.convertData(newData, completionHandlerForConvertData: completionHandlerForSessionID)
            
        }
        task.resume()
        return task
    }
    
    func taskForGETUsersData(completionHandler: @escaping (_ result: AnyObject?, _ error:NSError?) -> Void)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let urlString = Constants.getSessionURL+Methods.users+"/\(appDelegate.userID)"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let task = sharedSession.dataTask(with: request) {(data,response,error) in
            
            if error != nil
            {
                print("There was an error with the request")
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(nil,NSError(domain:"deleteSessionID", code: 1,userInfo: userInfo))
            }
            else
            {
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else
                {
                    print("The status code is not in order of 2xx")
                    return
                }
                
                print(statusCode)
                guard let data = data else
                {
                    print("Cannot find the user's data")
                    return
                }
                
                let range = Range(uncheckedBounds: (5,data.count))
                let newData = data.subdata(in: range)
                print(NSString(data:newData, encoding:String.Encoding.utf8.rawValue)!)
                self.convertData(newData, completionHandlerForConvertData: completionHandler)
            }
        }
        task.resume()
    }
    
    
    func taskForDELETESessionID(_ method:String,completionHandlerForDELETESession:@escaping (_ results: AnyObject?,_ error: NSError?) -> Void) -> URLSessionDataTask
    {
        let urlString = Constants.getSessionURL + method
        let url = URL(string: urlString) 
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = sharedSession.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForDELETESession(nil,NSError(domain:"deleteSessionID", code: 1,userInfo: userInfo))
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else
            {
                print("The status code is not in order of 2xx")
                return
            }
            
            print(statusCode)
            guard let data = data else
            {
                print("Cannot find the data")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            self.convertData(newData, completionHandlerForConvertData: completionHandlerForDELETESession)
        }
        task.resume()
        return task
    }
    
    func taskForGETStudentLocations(withObjectID: String?,completionHandlerForGetStudentLocation: @escaping(_ results: AnyObject?,_ error: NSError?) -> Void) -> URLSessionDataTask
    {
        var request:NSMutableURLRequest!
        let parametersMethod:[String:AnyObject] = [ParameterKeys.limitKey:ParameterValues.limitValue as AnyObject,
                                                   ParameterKeys.orderKey:ParameterValues.orderValue as AnyObject]
        if withObjectID != nil
        {
            request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(withObjectID)%22%7D")!)
        }
        else
        {
//            request = NSMutableURLRequest(url: URL(string:"https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
            request = NSMutableURLRequest(url: urlFromParameters(parametersMethod, withPathExtension: nil))
  
        }
        request.addValue(HttpValues.parseAppID, forHTTPHeaderField: HttpFields.parseAppIDKey)
        request.addValue(HttpValues.parseRestApi, forHTTPHeaderField: HttpFields.parseRestAPIKey)
        let task = sharedSession.dataTask(with: request as URLRequest) {(data, response, error) in
            
            if error != nil
            {
                completionHandlerForGetStudentLocation(nil,NSError(domain: "taskForGEtStudentLocation", code: 1, userInfo: [NSLocalizedDescriptionKey: error!]))
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else
            {
                print("The status code is not in order of 2xx")
                return
            }
            
            print(statusCode)
            guard let data = data else
            {
                print("Cannot find the data")
                return
            }
            let range = Range(uncheckedBounds: (0,data.count))
            let newData = data.subdata(in: range)
            self.convertData(newData, completionHandlerForConvertData:completionHandlerForGetStudentLocation)
            
        }
        task.resume()
        return task
    }
    
    func taskToPOSTStudentLocation(jsonBody:[String:AnyObject], completionHandlerForPOSTStudentLocation:@escaping(_ results: AnyObject?,_ error:NSError?) -> Void) -> URLSessionDataTask
    {
        let userInfo = jsonBody
        var info: Data!
        do{
            info = try JSONSerialization.data(withJSONObject: userInfo, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        catch
        {
            print("Cannot encode the data")
            
        }
        let request = NSMutableURLRequest(url: urlFromParameters([:],withPathExtension: nil))
        request.httpMethod = "POST"
        request.addValue(HttpValues.parseAppID, forHTTPHeaderField: HttpFields.parseAppIDKey)
        request.addValue(HttpValues.parseRestApi, forHTTPHeaderField:HttpFields.parseRestAPIKey)
        request.addValue(HttpValues.jsonValue, forHTTPHeaderField: HttpFields.contentTypeField)
        request.httpBody = info
        
        let task = sharedSession.dataTask(with: request as URLRequest) {(data,response,error) in
            
            if error != nil
            {
                let userInfo = [NSLocalizedDescriptionKey:error]
                completionHandlerForPOSTStudentLocation(nil,NSError(domain: "taskToPOSTStudentLocation", code: 1, userInfo: userInfo))
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else
            {
                print("The status code is not in order of 2xx")
                return
            }
            
            print(statusCode)
            guard let data = data else
            {
                print("Could not find the data")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            self.convertData(newData, completionHandlerForConvertData: completionHandlerForPOSTStudentLocation)
            
        }
        task.resume()
        return task
    }
    
    func taskForPUTStudentLocation(method:String, jsonBody:String, completionHandlerForPUTStudentLocation: @escaping(_ results:AnyObject?,_ error:NSError?) -> Void) -> URLSessionDataTask
    {
        let request = NSMutableURLRequest(url: urlFromParameters([:], withPathExtension: method))
        request.httpMethod = "PUT"
        request.addValue(HttpValues.parseAppID, forHTTPHeaderField: HttpFields.parseAppIDKey)
        request.addValue(HttpValues.parseRestApi, forHTTPHeaderField: HttpFields.parseRestAPIKey)
        request.addValue(HttpValues.jsonValue, forHTTPHeaderField: HttpFields.contentTypeField)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = sharedSession.dataTask(with: request as URLRequest) {(data, response, error) in
            
            if error != nil
            {
                completionHandlerForPUTStudentLocation(nil,NSError(domain:"taskForPUTStudentLocation", code: 1,userInfo:[NSLocalizedDescriptionKey: error]))
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else
            {
                print("The status code is not in order of 2xx")
                return
            }
            
            print(statusCode)
            guard let data = data else
            {
                print("Cannot find the data")
                return
            }
            
            let range = Range(uncheckedBounds: (5,data.count))
            let newData = data.subdata(in: range)
            completionHandlerForPUTStudentLocation(newData as AnyObject,nil)
            self.convertData(newData, completionHandlerForConvertData: completionHandlerForPUTStudentLocation)
        }
        task.resume()
        
        return task
    }
    
    private func urlFromParameters(_ parameters:[String:AnyObject]?, withPathExtension:String? = nil) -> URL
    {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key,value) in parameters!
        {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        print(components.url!)
        return components.url!
    }
    
    private func convertData(_ data: Data, completionHandlerForConvertData: (_ result:AnyObject?,_ error: NSError?) -> Void)
    {
        var parsedData:AnyObject!
        do{
            parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            if JSONSerialization.isValidJSONObject(parsedData)
            {
                completionHandlerForConvertData(parsedData,nil)
            }
        }
        catch{
            let userInfo = [NSLocalizedDescriptionKey: "Cannot parse the \(data) into json Format"]
            completionHandlerForConvertData(nil,NSError(domain:"convertDataWithCompletionHandler", code:1,userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedData,nil)
    }

    
    class func shareInstance() -> UdacityClient
    {
        struct SingleTon
        {
            static let sharedInstance = UdacityClient()
        }
        return SingleTon.sharedInstance
    }
 
}
