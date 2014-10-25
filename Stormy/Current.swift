//
//  Current.swift
//  Stormy
//
//  Created by M on 24.10.14.
//  Copyright (c) 2014 M. All rights reserved.
//

import UIKit

struct Current {
    
    var currentTime: String?
    var temperature: Int?
    var humidity: Double
    var precipProbability: Double
    var summary:  String
    var icon: UIImage?
    
    var timezone: String
    var latitude: Double
    var longitude: Double
    
    init(weatherDictionary: NSDictionary) {

        let currentWeather = weatherDictionary["currently"] as NSDictionary
//        println(weatherDictionary)
        
        humidity = currentWeather["humidity"] as Double
        precipProbability = currentWeather["precipProbability"] as Double
        summary = currentWeather["summary"] as String
        
        timezone = weatherDictionary["timezone"] as String
        latitude = weatherDictionary["latitude"] as Double
        longitude = weatherDictionary["longitude"] as Double
        
        let currentTimeValue = currentWeather["time"] as Int
        currentTime = dateStringFromUnixtime(currentTimeValue)
        
        let temperatureInF = currentWeather["temperature"] as Int
        temperature = fToC(temperatureInF)
        
        let iconString = currentWeather["icon"] as String
        icon = weatherIconFromString(iconString)
    }
    
    func dateStringFromUnixtime(unixtime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixtime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        
        let ruLocale = NSLocale(localeIdentifier: "ru_RU")
        dateFormatter.locale = ruLocale
        
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func weatherIconFromString(stringIcon: String) -> UIImage {
        var imageName:String
        
        switch stringIcon {
            case "clear-day":
                imageName = "clear-day"
            case "clear-night":
                imageName = "clear-night"
            case "rain":
                imageName = "rain"
            case "snow":
                imageName = "snow"
            case "sleet":
                imageName = "sleet"
            case "wind":
                imageName = "wind"
            case "fog":
                imageName = "fog"
            case "cloudy":
                imageName = "cloudy"
            case "partly-cloudy-day":
                imageName = "partly-cloudy"
            case "partly-cloudy-night":
                imageName = "cloudy-night"
            default:
                imageName = "default"
        }
        
        var iconImage = UIImage(named: imageName)
        return iconImage!
    }
    
    func fToC(degreesInF: Int) -> Int {
        return Int(round(Double(degreesInF - 32) / 1.8))
    }
    
}
