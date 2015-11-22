//
//  ListDetailVC.swift
//  ToDoListApp
//
//  Created by Suruchi on 25/08/2015.
//
//

import UIKit
import CoreData


class ListDetailVC: UIViewController,UITableViewDataSource , UIPickerViewDelegate, NSFetchedResultsControllerDelegate
{
 
    let context : NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var frc: NSFetchedResultsController = NSFetchedResultsController()
    var toBuyItem = [NSManagedObject]()
    var checked = [Bool]()
    
    var nItem : ShopList? = nil

    @IBOutlet weak var detailCancle: UIBarButtonItem!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet var txtItem: UITextField!
    @IBOutlet var detailTableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    
    func getFechedResultsController() -> NSFetchedResultsController{
        frc = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func listFetchRequest() -> NSFetchRequest{
        
        let fetchRequest = NSFetchRequest(entityName: "ShopList")
        
        let sortDescriptor = NSSortDescriptor(key:"itemName",ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        frc = getFechedResultsController()
        frc.delegate = self
        
        do {
            
            try frc.performFetch()
        
        } catch _ {
            // Handle error stored in *error* here
        }

    }
    
    //Get data from database
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        //Show the category
        detailTitle.text = nItem?.category
        self.title = nItem?.listname
        
        let shoplistFetchRequest = NSFetchRequest(entityName: "ShopList")
        let primarySortDescriptor = NSSortDescriptor(key: "listname", ascending: true)
        
        shoplistFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let allLists = (try! context.executeFetchRequest(shoplistFetchRequest)) as! [ShopList]
        var tempToBuyItem = [NSManagedObject]()
        
        for list in allLists {
            print(" \n List Name: \(list.listname) Store: \(list.store)")
            if list.listname == nItem?.listname {
                
                for item in list.buyitems!{
                    //print(">> \(item.itemName)");
                    tempToBuyItem.append(item as! BuyItems)
                }
                
            }
        }
        toBuyItem = tempToBuyItem
    }

    
    
    @IBAction func addButton_Click(sender: AnyObject) {
        
        var detailName: String
        detailName = txtItem.text!
        
        if detailName != "" {
        saveItem(detailName)
        txtItem.text = ""
        detailTableView.reloadData()
        }
        
    }
    
    //Add Item to the list
    // Save data into database in local mobile phone
    func saveItem(detailItemName: String) {
 
        // We create a new NSManagedObject for the BuyItems Entity
        let entity =  NSEntityDescription.entityForName("BuyItems",inManagedObjectContext:context)
        let newBuyItem = NSManagedObject(entity: entity!,insertIntoManagedObjectContext:context)
  
        // We then fill the attributes of the new device object
        newBuyItem.setValue(detailItemName, forKey: "itemName")
        newBuyItem.setValue(false, forKey: "completed")
        
        // Finally we attach the person object to the person relationship key of the device object
        let listFetchRequest = NSFetchRequest(entityName: "ShopList")
        let allShopLists = (try! context.executeFetchRequest(listFetchRequest)) as! [ShopList]
        let colesShopList = allShopLists.filter({ (sl: ShopList) -> Bool in
            return sl.listname == nItem?.listname
        }).first
        newBuyItem.setValue(NSSet(array: [colesShopList!]), forKeyPath: "shoplist")
        
        //Save the context
        do{
            try context.save()
        }catch{
            print("Could not save \(error)")
        }
        //append the lacal array
        toBuyItem.append(newBuyItem)
    }
    
    //Delete Item
    func deletItem(detailItemName: String) {
   
        let entity =  NSEntityDescription.entityForName("BuyItems",inManagedObjectContext:context)
        
        let buyItem = NSManagedObject(entity: entity!,insertIntoManagedObjectContext:context)
        
        buyItem.removeObserver(detailItemName, forKeyPath: "itemName")
        

        do{
            try context.save()
        }catch{
            
            print("Could not save \(error)")
        }
        
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return toBuyItem.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        let buyingItem = toBuyItem[indexPath.row]

        cell.textLabel?.text = buyingItem.valueForKey("itemName") as? String
        
        let completed = buyingItem.valueForKey("completed") as! Bool?
        if completed == false{
            cell.textLabel!.text = cell.textLabel!.text!
        }else {// check is true
            cell.textLabel!.text = "\u{2611}" + cell.textLabel!.text!
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        switch editingStyle
        {
            
        case .Delete:
            
            // remove the deleted item from the model
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            
            context.deleteObject(toBuyItem[indexPath.row] as NSManagedObject)
            toBuyItem.removeAtIndex(indexPath.row)
            do{
                try context.save()
            }catch{
                print("Could not save \(error)")
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
        default:
            return
            
        }

    }
    
    
    //Tick selection for buying items
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath)
        {
            
            let buyingItem = toBuyItem[indexPath.row]
            let completed = buyingItem.valueForKey("completed") as! Bool?
            
            if  completed == false
            {
                cell.textLabel!.text =   "\u{2611}" + cell.textLabel!.text!
                buyingItem.setValue(true, forKey: "completed")
                print (buyingItem.valueForKey("completed"))
            }
            else
            {
                cell.accessoryType = .None
                buyingItem.setValue(false, forKey: "completed")
                print (buyingItem.valueForKey("completed"))
            }
            
            do{
                try context.save()
            }catch{
                print("Could not save \(error)")
            }
            tableView.reloadData()
        }    
    }

 
    
    //Cancle on details view
    @IBAction func cancleDetailView(sender: UIBarButtonItem) {
        
        dismissVC()
       // print("cancel")
    }
    
    func dismissVC (){
        navigationController?.popViewControllerAnimated(true)
    }
        
}
