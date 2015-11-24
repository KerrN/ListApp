//
//  MenuVC.swift
//  ListApp
//
//  Created by Suruchi on 19/11/2015.
//  Copyright © 2015 BAPAT. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var menuItems:[String] = ["Main","About","Privacy Policy"];
    
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
        mycell.menuItemLabel.text = menuItems[indexPath.row]
        return mycell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch(indexPath.row){
        case 0://Main
            
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TableVC") as! TableVC
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break;
            
        case 1://About
            
            let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutVC") as! AboutVC
            let aboutNavController = UINavigationController(rootViewController: aboutViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController = aboutNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break;
        
        case 2://Privacy
            
            let privacyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PrivacyVC") as! PrivacyVC
            let privacyNavController = UINavigationController(rootViewController: privacyViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController = privacyNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break;
        default:
            //  print("\(menuItems[indexPath.row]) is selected);
            break;
          
            
            
        
        }
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
