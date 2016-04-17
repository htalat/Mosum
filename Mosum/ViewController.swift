//
//  ViewController.swift
//  Mosum
//
//  Created by Hassan Talat on 4/10/16.
//  Copyright © 2016 Buff Apps. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var lblLocation: UILabel!
    var manager: CLLocationManager!
    var geocoder: CLGeocoder!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var days = [Day]()
    @IBOutlet weak var lblCityStateCountry: UILabel!
    
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblIcon: UILabel!
       
    //MARK: intializations
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        intializations()
        setupTableView()
        getLocation()
    }
    
    
    func intializations() -> Void
    {
        manager = CLLocationManager()
        manager.delegate = self
        geocoder = CLGeocoder()
    }
    
    func getLocation() ->Void
    {
        manager.requestLocation()
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }

    func setupTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshButtonPressed(sender: UIBarButtonItem)
    {
        getLocation()
    }
    
    //MARK: weather api call
    func getDailyWeather(location:CLLocation)
    {
        let apiKey = "622b8a123547f8c8602b69ac9cf864ea"
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        let url = "https://api.forecast.io/forecast/\(apiKey)/\(lat),\(long)"
        
        let requestURL: NSURL = NSURL(string: url)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            
            if (statusCode == 200)
            {
                do
                {
                    /*
                    let summary = currently!["summary"] as! String
                    let temperature = currently!["temperature"] as! Double
                    let icon = currently!["icon"] as! String
                    let time = currently!["time"] as! Double
                    //TODO: fill other stuff.
                    dispatch_async(dispatch_get_main_queue(),
                    {
                        self.lblSummary.text = summary
                        self.lblTemperature.text = String(temperature) + " F"
                        self.lblIcon.text = icon
                    })*/
                    
                    if let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary {
                        
                        if let current = json["currently"] as? NSDictionary
                        {
                            let summ = current["summary"] as! String
                            let temp = current["temperature"] as! Double
                            let icn = current["icon"] as! String
                            let tim = current["time"] as! Double
                            
                            dispatch_async(dispatch_get_main_queue(),
                            {
                                            self.lblSummary.text = summ
                                            self.lblTemperature.text = String(temp) + " F"
                                            self.lblIcon.text = icn
                            })
                            
                        }
                        
                        if let daily = json["daily"] as? NSDictionary {
                            
                            
                            
                            if let dailyData = daily["data"] as? NSArray {
                                for d in dailyData{
                                    let str : String = "MAX: \(d["temperatureMax"] as! Double)"
                                    
                                    let _timeSec : Double = d["time"] as! Double
                                    let _time : NSDate =  NSDate(timeIntervalSince1970:_timeSec)
                                    var _temp = d["temperatureMax"] as! Double
                                    _temp =  Double(round(100*_temp)/100)
                                    let _icon = d["icon"] as! String
                                    let _summary = d["summary"] as! String
                                    let day: Day = Day(time:_time,temp: _temp,icon:_icon,summary:_summary)
                                    
                                    dispatch_async(dispatch_get_main_queue(),
                                                   {
                                                   self.days.append(day)
                                                   self.tableView.reloadData()
                                    })
                                }
                            }
                     
                        }
                    }
                    
                  
                    
 
                }catch
                {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        
    
        task.resume()

    
    }

    //MARK: location
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
          
            //print(location)
           // location
            geocoder.reverseGeocodeLocation(location,completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                // Location name
                if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                //print(locationName)
                }
                
                // City
                if let city = placeMark.addressDictionary!["City"] as? NSString {
                   // print(city)
                    self.lblCityStateCountry.text = city as String
                }
                
                // Zip code
                if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                //print(zip)
                }
                
                //State
                if let state = placeMark.addressDictionary!["State"] as? NSString {
                    //print(state)
                }
                
                
                // Country
                if let countrycode = placeMark.addressDictionary!["CountryCode"] as? NSString {
                //print(countrycode)
                }
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let date = NSDate()
                let strDate = dateFormatter.stringFromDate(date)
                self.lblLocation.text = "Last Updated: \(strDate)"
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                
                self.getDailyWeather(location)

            })
            

        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    //MARK: tableView stuff
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell", forIndexPath: indexPath) as! TableViewCell
        
        let row = indexPath.row
        
        cell.summary?.text = days[row].summary
        cell.temperature?.text = String(days[row].temperature)
        var i = days[row].icon
        cell.icon.image = UIImage(named:days[row].icon)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = days[row].time
        cell.time?.text = dateFormatter.stringFromDate(strDate)
        return cell
    }

}

