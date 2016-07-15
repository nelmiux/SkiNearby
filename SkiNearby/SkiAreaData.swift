//
//  SkiAreaData.swift
//
//  Created by Nelma Perera.
//  Copyright © 2016 Nelma Perera. All rights reserved.
//

import Foundation

protocol SkiAreaDataProtocol {
    
    func responseDataHandler(data: NSDictionary)
    
    func responseError(message: String)
}

class SkiAreaData {
    
    var delegate: ViewController? = nil
    
    func getData(zipcode:String) {
        var url: NSURL?
        
        let postEndpoint: String = "http://api.worldweatheronline.com/free/v2/ski.ashx?key=fc371a731202b57b2edc7a687df17&format=json&includelocation=yes&q=" + zipcode
        
        if NSURL(string: postEndpoint) != nil {
            url = NSURL(string: postEndpoint)
        } else {
            self.delegate!.responseError("Error: cannot create URL")
            return
        }
        
        let urlRequest = NSURLRequest(URL: url!)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
            (data, response, error) in
            guard let responseData = data else {
                self.delegate!.responseError("No nearby ski facilities")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            var returnedData: NSDictionary
            do {
                returnedData = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
                if returnedData["data"]!["error"] is Array<Dictionary<String, String>> {
                    self.delegate!.responseError("No nearby ski facilities")
                    return
                }
                self.delegate!.responseDataHandler(returnedData)
            } catch  {
                self.delegate!.responseError("Error trying to convert data to JSON")
                return
            }
        })
        task.resume()
    }
}

