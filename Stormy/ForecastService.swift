//
//  ForecastService.swift
//  Stormy
//
//  Created by Beatriz Macedo on 8/13/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import Foundation

struct ForecastService {
    
    let forecastAPIKey: String
    let forecastBaseURL: NSURL?
    
    init(APIKey: String){
        forecastAPIKey = APIKey
        forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
    }
    
    func getForecast(lat: Double, long: Double, completion: (Forecast? -> Void)){
        if let forecastURL = NSURL(string: "\(lat),\(long)", relativeToURL: forecastBaseURL){
            
            let networkOperation = NetworkOperation(url: forecastURL)
            networkOperation.downloadJSONFromURL{
                (let JSONDictionary) in
                let forecast = Forecast(weatherDictionary: JSONDictionary)
                completion(forecast)
            }
            
        } else {
            println("Could not construct a valid URL")
        }
    }
    
}