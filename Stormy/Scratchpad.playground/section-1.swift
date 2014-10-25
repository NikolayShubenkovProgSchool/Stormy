// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

let apiKey = "ae82a4fa74d116e5d2e036df280f0a33"
let locationPoints = "55.483376, 37.567537"

let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
let encodedPoints = locationPoints.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

var forecastURL = NSURL(string: encodedPoints, relativeToURL: baseURL)

if let forecastURL = NSURL(string: encodedPoints, relativeToURL: baseURL) {
    let weatherData = NSData(contentsOfURL: forecastURL, options: nil, error: nil)
    println(weatherData)
}
