//
//  ViewController.swift
//  Stormy
//
//  Created by Beatriz Macedo on 8/9/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dailyWeather: DailyWeather?{
        didSet {
            configureView()
        }
    }
    
    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var summaryLabel: UILabel?
    @IBOutlet weak var sunriseTimeLabel: UILabel?
    @IBOutlet weak var sunsetTimeLabel: UILabel?
    
    @IBOutlet weak var lowTemperatureLabel: UILabel?
    @IBOutlet weak var highTemperatureLabel: UILabel?
    @IBOutlet weak var precipitationLabel: UILabel?
    @IBOutlet weak var humidiyLabel: UILabel?
    
    func configureView() {
        if let weather = dailyWeather {
            self.title = weather.day
            
            // Update UI with information from the data model
            weatherIcon?.image = weather.largeIcon
            summaryLabel?.text = weather.summary
            sunriseTimeLabel?.text = weather.sunriseTime
            sunsetTimeLabel?.text = weather.sunsetTime
            
            if let lowTemp = weather.minTemperature,
                let highTemp = weather.maxTemperature,
                let rain = weather.precipChance,
                let humidity = weather.humidity {
                    lowTemperatureLabel?.text = "\(lowTemp)º"
                    highTemperatureLabel?.text = "\(highTemp)º"
                    precipitationLabel?.text = "\(rain)%"
                    humidiyLabel?.text = "\(humidity)%"
            }
        }
        
        // Configure nav bar back button
        //Change the font and size of nav bar text
        if let buttonFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0){
            let barButtonAttributesDictionary: [NSObject: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: buttonFont
            ]
            UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributesDictionary, forState: .Normal)
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()

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
    
    /*// Used for future error handling
    func errorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Error Message", message: "Error: \(errorMessage)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }*/
}