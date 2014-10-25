//
//  ViewController.swift
//  Stormy
//
//  Created by M on 23.10.14.
//  Copyright (c) 2014 M. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
//    private var locationManager: CLLocationManager?
    
    private let apiKey = "ae82a4fa74d116e5d2e036df280f0a33"
    private let locationPoints = "37.8267,-122.423"
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var timezoneLabel: UILabel!
    @IBOutlet weak var coodinate2dLabel: UILabel!
    
    @IBOutlet weak var forecastIoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // !!!: http://stackoverflow.com/questions/24063798/cllocation-manager-in-swift-to-get-location-of-user
//        locationManager = CLLocationManager()
//        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager?.delegate = self
//        locationManager?.startUpdatingLocation()
        
        getCurrentWeatherData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        forecastIoLabel.transform = CGAffineTransformMakeRotation(CGFloat(-(M_PI / 2.0)))
        
        //        let viewsLegend = ["label": forecastIoLabel]
        
        // расскоментить эту строку
        // forecastIoLabel.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[label]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["label": forecastIoLabel]))
        
        //        forecastIoLabel.addConstraint(<#constraint: NSLayoutConstraint#>)
    }
    
    func getCurrentWeatherData() -> Void {
        
        // request example: https://api.forecast.io/forecast/ae82a4fa74d116e5d2e036df280f0a33/37.8267,-122.423
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let encodedPoints = locationPoints.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        if let forecastURL = NSURL(string: encodedPoints, relativeToURL: baseURL) {
            
            let sharedSession = NSURLSession.sharedSession()
            let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
                
                if (error == nil) {
                    
                    let dataObject = NSData(contentsOfURL: location)
                    let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                    
                    var currentWeather = Current(weatherDictionary: weatherDictionary)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.temperatureLabel.text = "\(currentWeather.temperature!)"
                        self.iconView.image = currentWeather.icon!
                        self.currentTimeLabel.text = "\(currentWeather.currentTime!)"
                        self.humidityLabel.text = "\(Int(round(currentWeather.humidity * 100)))%"
                        self.precipitationLabel.text = "\(Int(round(currentWeather.precipProbability * 100)))%"
                        self.summaryLabel.text = "\(currentWeather.summary)"
                        
                        self.timezoneLabel.text = currentWeather.timezone
                        self.coodinate2dLabel.text = "\(currentWeather.latitude), \(currentWeather.longitude)"
                        
                        self.refreshButton.hidden = false
                        self.refreshActivityIndicator.stopAnimating()
                        self.refreshActivityIndicator.hidden = true
                    })
                } else {
                    let networkIssueController = UIAlertController(title: "Error", message: "Невозможно получить данные. Ошибка подключения!", preferredStyle: .Alert)
                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    networkIssueController.addAction(okButton)
                    self.presentViewController(networkIssueController, animated: true, completion: nil)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.refreshButton.hidden = false
                        self.refreshActivityIndicator.stopAnimating()
                        self.refreshActivityIndicator.hidden = true
                    })
                }
            })
            downloadTask.resume()
        }
    }
    
    @IBAction func refresh() {
        refreshButton.hidden = true
        refreshActivityIndicator.startAnimating()
        
        getCurrentWeatherData()
    }
    
    // MARK: CLLocationManagerDelegate Methods
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("didUpdateLocations")
        println(locations)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
         println("didFailWithError")
    }
    
}

