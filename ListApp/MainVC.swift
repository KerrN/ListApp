//
//  MainVC.swift
//  ListApp
//
//  Created by Suruchi on 14/11/2015.
//  Copyright © 2015 BAPAT. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate ).managedObjectContext
    
    var nItem : ShopList? = nil

    @IBOutlet weak var listName: UITextField!
    @IBOutlet weak var store: UITextField!
    @IBOutlet weak var category: UITextField!
    
    @IBOutlet weak var BuyItem: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if nItem != nil{
            listName.text = nItem?.listname
            store.text = nItem?.store
            category.text = nItem?.category
            
            print("viewDidLoad ManinVC")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        print("didReceiveMemoryWarning ManinVC")
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        dismissVC()
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        
        if nItem != nil{
            editItem()
            
        }
        else
        {
            newList()
        }
        print("saveTapped ManinVC")
        dismissVC()
    }
    
    
    func dismissVC (){
        navigationController?.popViewControllerAnimated(true)
    }
    
    func newList(){
        let context = self.context
        let ent =
        NSEntityDescription.entityForName("ShopList", inManagedObjectContext: context)
        
        let nItem = ShopList(entity: ent!, insertIntoManagedObjectContext:context)
        
        nItem.listname = listName.text
        nItem.store = store.text
        nItem.category = category.text
        do {
            try context.save()
        } catch _ {
            // Handle error stored in *error* here
        }
        print("newList ManinVC")
        
    }
    
    func editItem(){
        nItem!.listname = listName.text
        nItem!.store = store.text
        nItem!.category = category.text
        do {
            try context.save()
        } catch _ {
            // Handle error stored in *error* here
        }
        print("editItem ManinVC")
    }
    


}

