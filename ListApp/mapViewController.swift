//
//  mapViewController.swift
//  ListApp
//
//  Created by Guanghui Ji on 19/11/2015.
//  Copyright © 2015 BAPAT. All rights reserved.
//

import UIKit
import CoreLocation


class mapViewController: UIViewController, CLLocationManagerDelegate{

    var manager:CLLocationManager!

    @IBOutlet var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy - kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        let userLocation:CLLocation = locations[0]

       addressLabel.text =  "\(userLocation.coordinate.latitude) + \(   userLocation.coordinate.longitude)"
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
