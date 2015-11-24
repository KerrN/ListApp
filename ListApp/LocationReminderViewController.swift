//
//  LocationReminderViewController.swift
//  ListApp
//
//  Created by Guanghui Ji on 22/11/2015.
//  Copyright © 2015 BAPAT. All rights reserved.
//

import UIKit

import EventKit
import CoreLocation


class LocationReminderViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet var locationText: UITextField!
    var appDelegate: AppDelegate?
    var locationManager: CLLocationManager = CLLocationManager()
    //var locationManager: CLLocationManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setLocationReminder(sender: AnyObject) {
        
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if appDelegate!.eventStore == nil {
            appDelegate!.eventStore = EKEventStore()
            appDelegate!.eventStore!.requestAccessToEntityType(EKEntityType.Reminder, completion:
                {(granted, error) in
                    if !granted
                    {
                        print("Access to store not granted")
                        print(error!.localizedDescription)
                    }
                    else
                    {
                        print("Access granted")
                    }
            })
            
        }
        
        if (appDelegate!.eventStore != nil) {
            //locationManager.startUpdatingLocation()
            locationManager.requestLocation()
            }
        }
    



 func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
    
     locationManager.stopUpdatingLocation()
    
     let reminder = EKReminder(eventStore: appDelegate!.eventStore!)
     reminder.title = locationText.text!
     reminder.calendar =
         appDelegate!.eventStore!.defaultCalendarForNewReminders()
    
     let location = EKStructuredLocation(title: "Current Location")
     location.geoLocation = locations.last
    
     let alarm = EKAlarm()
    
     alarm.structuredLocation = location
     alarm.proximity = EKAlarmProximity.Leave
    
     reminder.addAlarm(alarm)
    
//     var error: NSError?
//    
//     appDelegate!.eventStore?.saveReminder(reminder,
//         commit: true, error: &error)
//    
//     if error != nil {
//         print("Reminder failed with error \(error?.localizedDescription)")
//      }
    do {
        try appDelegate?.eventStore?.saveReminder(reminder, commit: true)
        print(3)
    } catch let error as NSError{
    
        print("Reminder failed with error \(error.localizedDescription)")
    }
    
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(" Failed to get location \(error.localizedDescription)")
    }
}
