//
//  MainVC.swift
//  ListApp
//
//  Created by Suruchi on 14/11/2015.
//  Copyright © 2015 BAPAT. All rights reserved.
//

import UIKit
import CoreData


class MainVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate ).managedObjectContext
    
    var nItem : ShopList? = nil
    var Array = ["All","Personal","Work","Today's Reminders"]
    var CategorySelected = 0
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var listName: UITextField!
    @IBOutlet weak var store: UITextField!
    @IBOutlet weak var category: UITextField!
    
    @IBOutlet weak var BuyItem: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        if nItem != nil{
            listName.text = nItem?.listname
            store.text = nItem?.store
            category.text = nItem?.category
            
            //print("viewDidLoad ManinVC")
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Picker
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array[row]
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Array.count // Count nuber of options
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        category.text = Array[row] //Select the text from the Array of srings for options
    }
    //end picker functions
    
    
    @IBAction func cancelTapped(sender: AnyObject) {
        dismissVC()
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        
        if nItem != nil
        {
            editItem()
        }
        else
        {
            newList()
        }
        dismissVC()
    }
    
    
    func dismissVC (){
        //dismis the current view
        navigationController?.popViewControllerAnimated(true)
    }
    
    func newList(){
        let context = self.context
        let ent = NSEntityDescription.entityForName("ShopList", inManagedObjectContext: context)
        let nItem = ShopList(entity: ent!, insertIntoManagedObjectContext:context)
        
        nItem.listname = listName.text
        nItem.store = store.text
        nItem.category = category.text
        do {
            try context.save()
        } catch _ {
        // Handle error stored in *error* here
        }
        //print("newList ManinVC") //Debug msg
        
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

