//
//  TableVC.swift
//  ListApp
//
//  Created by Suruchi on 14/11/2015.
//  Copyright © 2015 BAPAT. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class TableVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var admobBanner: GADBannerView!
    
    let context : NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var frc: NSFetchedResultsController = NSFetchedResultsController()
    
    func getFechedResultsController() -> NSFetchedResultsController{
        frc = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func listFetchRequest() -> NSFetchRequest{
        let fetchRequest = NSFetchRequest(entityName: "ShopList")
        
        let sortDescriptor = NSSortDescriptor(key:"listname",ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //Display mobile ads here
        admobBanner.adUnitID = "ca-app-pub-3000953524335319/6882684788"
        admobBanner.rootViewController = self
        self.view.addSubview(admobBanner)
        let adRequest: GADRequest = GADRequest()
        adRequest.testDevices = [""]
        admobBanner.loadRequest(adRequest)
        
        
        
        frc = getFechedResultsController()
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch _ {
            // Handle error stored in *error* here
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let numberOfSections = frc.sections?.count
        return numberOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numberOfRowsInSection = frc.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let list = frc.objectAtIndexPath(indexPath) as! ShopList
        

        // Configure the cell...
        cell.textLabel?.text = list.listname
        
        let store  = list.store
        let category  = list.category
        
        cell.detailTextLabel?.text = "Store:\(store) \(category)."
        //set the colot to the Table View cell
        cell.backgroundColor = colorForIndex(indexPath.row)
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let managedObject: NSManagedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject

        do {
            context.deleteObject(managedObject)
            try context.save()
        } catch _ {
            // Handle error stored in *error* here
        }

        
        
        /*if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        } */
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "edit"{
            let cell  = sender as! UITableViewCell
            let listIndexPath = tableView.indexPathForCell(cell)
            let itemController : ListDetailVC = segue.destinationViewController as! ListDetailVC
            let nItem : ShopList = frc.objectAtIndexPath(listIndexPath!) as! ShopList
            
            itemController.nItem = nItem
            
        }
        
    }
    
    // MARK: - Table view delegate
    
    func colorForIndex(index: Int) -> UIColor {

        let itemCount =  frc.sections?[0].numberOfObjects
        print(itemCount)
        let val = (CGFloat(index) / CGFloat(itemCount!)) * 0.7
        return UIColor(red: 0.9, green: val, blue: 0.0, alpha: 1.0)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = colorForIndex(indexPath.row)
    }
    

}
