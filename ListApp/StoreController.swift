//
//  StoreController.swift
//  ListApp
//
//  Created by 040916399 on 25/11/2015.
//  Copyright © 2015 BAPAT. All rights reserved.
//

import UIKit
import MapKit
import CoreData

protocol StoreControllerDelegate {
    func addStoreController(controller: StoreController, didAddCoordinate coordinate: CLLocationCoordinate2D,
        radius: Double, identifier: String, note: String, eventType: EventType)
}

// saving your CLLocation object

let context : NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
var frc: NSFetchedResultsController = NSFetchedResultsController()
var tolistItem = [NSManagedObject]()

class StoreController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate{
   
    //Create connections to UI Items
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var storeSearch: UITextField!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!

    
    //items that match will be stored here
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    //items for tableview are stored here they hold matched items
    var listItems: [String] = []
    
   
    
    var delegate: StoreControllerDelegate!
    
    
    
    @IBAction func nextView(sender: AnyObject) {
    }
    
    
    
    //Action happens when user exits out of search text feild
    @IBAction func storeSearching(sender: AnyObject) {
        sender.resignFirstResponder()
        //Removes or current annotations on the map
        mapView.removeAnnotations(mapView.annotations)
        //Runs search function
        self.performSearch()
    }
    
    
    
    //sets indentifer for cell (I have set it on the UI now may be able to delte this)
    let textCellIdentifier = "cell"
    
    //Intizlizes lat and long. I use them later on to store users location
    var lat = 0.0;
    var long = 0.0;
    
    
    //setting up location manager
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
 
    
    override func viewDidLoad() {
        //Will Run the checklocation function
        checkLocationAuthorizationStatus()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    //Checks if authorized to track user location if not user to. if yes track user location on map
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Checks location updates and changes the variables related to user location - also prints the location for testing purposes
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //this is the place where you get the new location
            lat  = location.coordinate.latitude
            print("\(location.coordinate.latitude)")
            long  = location.coordinate.longitude
            print("\(location.coordinate.longitude)")
            
            let initialLocation = CLLocation(latitude: lat, longitude: long)
            
            //This continiully centers map around location - please remove if you dont want map to be center constinaly around the user.
            centerMapOnLocation(initialLocation)
            
            
        }
        
        
    }
   
    
  // Function for centering map on users location
    func centerMapOnLocation(location: CLLocation) {
        //Sets the region of map shown. Higher number = more zoomed out. Lower number = more zoomed in
          let regionRadius: CLLocationDistance = 800
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    //Search function - preforms local search (Should not search outside of set region if it is working correctly
    //Searches for text user inputs for any local land marks and puts them as annonations on the map
    //Also adds these to listView
    func performSearch() {
        //Removes all current matching items to clear any previous searches - so map is not over filled
        matchingItems.removeAll()
        // set request local search
        let request = MKLocalSearchRequest()
        //Run query equal to user text from text feild
        request.naturalLanguageQuery = self.storeSearch.text
        //Is only around the reguon
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler({(response: MKLocalSearchResponse?, error: NSError?) in
            // if an error occurs ..
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            }
            //If nothing is found
            else if response!.mapItems.count == 0 {
                print("No matches found")
            }
            //If matches are found
            else {
                print("Matches found")
                //For each item is found
                for item in response!.mapItems {
                    
                    //print for testing purposes
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")
                   print("Location = \(item.placemark)")
                    // items to the end of matchingItems array
                    self.matchingItems.append(item as MKMapItem)
                    //Print the ammount of matching items
                    print("Matching items = \(self.matchingItems.count)")
                    //Add item name to it end of listItems array
                    self.listItems.append(item.name!)
                    //Reloads the list
                    //NEED TO CLEAR THIS LIST BEFORE RELOAD AS MUTIPLE SEARCHES WILL CONTINUE TO ADD TO END
                    self.tableView.reloadData()
                    //Create annotation (Markers on map)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    //Adds the create annonation to map
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Shows number of rows in list - is more efficent way to do this with MapView.Count or something simular will try later
        return listItems.count
    }
    
    
    //Get cell info at index
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
       
        let row = indexPath.row
        //Fills cell at index
        cell.textLabel?.text = listItems[row]
        
        return cell
        
        
       
    }
    //On Row selection
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        //print for testing purposes 
        print(listItems[row])
        print(mapView.annotations[row].coordinate)
        
      
       //This save to the model MapLocations
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
                
                let entity =  NSEntityDescription.entityForName("MapLocations",inManagedObjectContext:context)
                let listItem = NSManagedObject(entity: entity!,insertIntoManagedObjectContext:context)
                
                // This will set the values of the MapLocations . Name, Lat and long so can be called later
                listItem.setValue(listItems[row], forKey: "name")
                listItem.setValue(mapView.annotations[row].coordinate.latitude, forKey: "lat")
                listItem.setValue(mapView.annotations[row].coordinate.longitude, forKey: "long")
                
              //printing for lesting
        print(listItem);
                
                //Save but if error print could not
                do{
                    try context.save()
                }catch{
                    print("Could not save \(error)")
                }
                //append the lacal array
        
            }


                
}

    
