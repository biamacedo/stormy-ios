//
//  NetworkOperation.swift
//  Stormy
//
//  Created by Beatriz Macedo on 8/13/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError {
    case NoNetwork
}

class NetworkOperation{
    
    // A lazy stored property is a property whose initial value is not calculated until the first time it is used.
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    typealias JSONDictionaryCompletion = ([String: AnyObject]?) -> Void
    
    init(url: NSURL){
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
        
        let request: NSURLRequest = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            // 1. Check HTTP response for successful GET request
            
            if let httpResponse = response as? NSHTTPURLResponse {
                switch(httpResponse.statusCode){
                case 200:
                    // 2. Create JSON object with data
                    let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject]
                    completion(jsonDictionary)
                    
                default:	
                    println("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                }
            } else {
                println("Error: Not a valid HTTP response")
            }
        }
        
        dataTask.resume()
        
    }
    
}