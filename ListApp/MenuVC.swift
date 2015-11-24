//
//  MenuVC.swift
//  ListApp
//
//  Created by Suruchi on 19/11/2015.
//  Copyright © 2015 BAPAT. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var menuItems:[String] = ["All","Personal","Work","Privacy Policy","About"];
    var lastSelectedIndexPath: NSIndexPath?
    var categorySelection:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return menuItems.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mycell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! menuCustomTableViewCell

        mycell.accessoryType = .None
        mycell.menuItemLabel.text = menuItems[indexPath.row]
        lastSelectedIndexPath = indexPath
        return mycell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        categorySelection = menuItems[indexPath.row]
        switch(indexPath.row)
        {
    
            case 4://About
            
                let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutVC") as! AboutVC
                let aboutNavController = UINavigationController(rootViewController: aboutViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
                appDelegate.centerContainer!.centerViewController = aboutNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break;
        
            case 3://Privacy
            
                let privacyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PrivacyVC") as! PrivacyVC
                let privacyNavController = UINavigationController(rootViewController: privacyViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
                appDelegate.centerContainer!.centerViewController = privacyNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                
            break;
            
            default:
                if indexPath.row != lastSelectedIndexPath!.row
                {
                    let oldCell = tableView.cellForRowAtIndexPath(self.lastSelectedIndexPath!)
                    oldCell?.accessoryType = .None
                
                    let newCell = tableView.cellForRowAtIndexPath(indexPath)
                    newCell?.accessoryType = .Checkmark
                    
                    lastSelectedIndexPath = indexPath
                }
                let mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TableVC") as! TableVC
                let mainNavController = UINavigationController(rootViewController: mainViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.centerContainer!.centerViewController = mainNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)

//                let svc = segue.destinationViewController as! TableVC;
                mainViewController.toPass = self.categorySelection
                //let mycell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! menuCustomTableViewCell
                
            break;
        
        }
    }
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
       // if (segue.identifier == "segueTest")
      //  {
                let svc = segue.destinationViewController as! TableVC;
                svc.toPass = self.categorySelection
                
        //}
    }

}
