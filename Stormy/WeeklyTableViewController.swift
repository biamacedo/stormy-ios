//
//  WeeklyTableViewController.swift
//  Stormy
//
//  Created by Beatriz Macedo on 8/16/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit

class WeeklyTableViewController: UITableViewController {
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentTemperatureRangeLabel: UILabel?
    
    private let forecastAPIKey = "75e43af5d6a0f69e697a7f47f1fa16f5"
    // Rio de Janeiro Coordinates
    let coordinate: (lat: Double, long: Double) = (-22.9122,-43.1750)
    
    var weeklyWeather: [DailyWeather] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        retrieveWeatherForecast()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Add any code that modifyes the Weekly View
    func configureView() {
        // Set table view's background view property
        tableView.backgroundView = BackgroundView()
        
        // Set custom height for table view row
        tableView.rowHeight = 64
        
        //Change the font and size of nav bar text
        if let navBarFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0){
            let navBarAttributesDictionary: [NSObject: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: navBarFont
            ]
            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
        
        // Position refresh control above background view
        refreshControl?.layer.zPosition = tableView.backgroundView!.layer.zPosition + 1
        refreshControl?.tintColor = UIColor.whiteColor()
    }
    
    @IBAction func refreshWeather() {
        retrieveWeatherForecast()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDaily" {
            if let indexPath = tableView.indexPathForSelectedRow() {
                let dailyWeather = weeklyWeather[indexPath.row]
                
                (segue.destinationViewController as! ViewController).dailyWeather = dailyWeather
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Forecast"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return weeklyWeather.count
    }
    
    // Reusable Cell Method
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell") as! DailyWeatherTableViewCell
        
        // Setting info to cell
        let dailyWeather = weeklyWeather[indexPath.row]
        if let maxTemp = dailyWeather.maxTemperature {
            cell.temperatureLabel.text = "\(maxTemp)º"
        }
        cell.weatherIcon.image = dailyWeather.icon
        cell.dayLabel.text = dailyWeather.day
        
        return cell
    }
    
    // MARK: - Delegate Methods
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 170/255.0, green: 131/255.0, blue: 224/225.0, alpha: 1.0)
        
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
            header.textLabel.textColor = UIColor.whiteColor()
        }
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        cell?.selectedBackgroundView = highlightView
    }
    
    // MARK: - Weather Fetching
    
    func retrieveWeatherForecast() {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getForecast(coordinate.lat, long: coordinate.long){
            (let forecast) in
            if let weatherForecast = forecast,
                let currentWeather = weatherForecast.currentWeather {
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
                    /*
                    if let humidity = currentWeather.humidity {
                        self.currentHumidityLabel?.text = "\(humidity)%"
                    }*/
                    
                    if let precipitation = currentWeather.precipProbability {
                        self.currentPrecipitationLabel?.text = "Rain: \(precipitation)%"
                    }
                    
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    /*
                    if let summary = currentWeather.summary {
                        self.currentWeatherSummary?.text = summary
                    }*/
                    
                    self.weeklyWeather = weatherForecast.weekly
                    
                    if let highTemp = self.weeklyWeather.first?.maxTemperature,
                        let lowTemp = self.weeklyWeather.first?.minTemperature {
                            self.currentTemperatureRangeLabel?.text = "↑\(highTemp)º↓\(lowTemp)º"
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }

}
