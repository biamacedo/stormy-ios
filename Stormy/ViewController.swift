//
//  ViewController.swift
//  Stormy
//
//  Created by Beatriz Macedo on 8/9/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentHumidityLabel: UILabel?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentWeatherSummary: UILabel?
    @IBOutlet weak var refreshButton: UIButton?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    private let forecastAPIKey = "75e43af5d6a0f69e697a7f47f1fa16f5"
    // Rio de Janeiro Coordinates
    let coordinate: (lat: Double, long: Double) = (-22.9122,-43.1750)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        retrieveWeatherForecast()

        /****************** Fetching data asyncronously ***************************************
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
        // Rio de Janeiro Coordinates
        let forecasURL = NSURL(string: "22.9068,43.1729", relativeToURL: baseURL)

        // Use NSURLSession API to fetch data
        // Creating a configuration object
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        // NSURLRequest object
        let request = NSURLRequest(URL: forecasURL!)
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            
        })
        
        dataTask.resume()
        
        // Fetching data syncronously - big no no = Data object to fetch weather data
        //let weatherData = NSData(contentsOfURL: forecasURL!, options: nil, error: nil)
        //println(weatherData)
        
        **************************************************************************************************/

        /****************** Using a Plist with one static location ***************************************
        if  let plistPath = NSBundle.mainBundle().pathForResource("CurrentWeather", ofType: "plist"),
            let weatherDictionary = NSDictionary(contentsOfFile: plistPath),
        let currentWeatherDictionary = weatherDictionary["currently"] as? [String: AnyObject]{
            
            let currentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
            
            currentTemperatureLabel?.text = "\(currentWeather.temperature)º"
            currentHumidityLabel?.text = "\(currentWeather.humidity)%"
            currentPrecipitationLabel?.text = "\(currentWeather.precipProbability)%"
            
        }
        **************************************************************************************************/

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveWeatherForecast() {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getForecast(coordinate.lat, long: coordinate.long){
            (let currently) in
            if let currentWeather = currently {
                // Update UI
                // Using GCD API
                dispatch_async(dispatch_get_main_queue()){
                    // Execute closure
                    // Code that executes on the main thread, because we are adding it to the main thread queue
                    
                    if let temperature = currentWeather.temperature {
                        // When you refer to a stored property from inside a closure
                        // you always have to use the keyword self
                        self.currentTemperatureLabel?.text = "\(temperature)º"
                    }
                    
                    if let humidity = currentWeather.humidity {
                        self.currentHumidityLabel?.text = "\(humidity)%"
                    }
                    
                    if let precipitation = currentWeather.precipProbability {
                        self.currentPrecipitationLabel?.text = "\(precipitation)%"
                    }
                    
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    
                    if let summary = currentWeather.summary {
                        self.currentWeatherSummary?.text = summary
                    }
                    
                    self.toggleRefreshAnimation(false)
                }
            }
        }
    }

    @IBAction func refreshWeather() {
        toggleRefreshAnimation(true)
        retrieveWeatherForecast()
    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton?.hidden = on
        if on {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }
    
    // Used for future error handling
    func errorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Error Message", message: "Error: \(errorMessage)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}