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
        
        //Change the font and size of nav bar text
        if let navBarFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0){
            let navBarAttributesDictionary: [NSObject: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: navBarFont
            ]
            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Weather Fetching
    
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
                    
                }
            }
        }
    }

}
