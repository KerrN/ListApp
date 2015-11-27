//
//  reminderViewController.swift
//  ListApp
//
//  Created by Connie on 22/11/2015.
//

import UIKit
import EventKit
import iAd

class reminderViewController: UIViewController {

    //Declairation of variables for UI component
    @IBOutlet var reminderText: UITextField!
    @IBOutlet var myDatePicker: UIDatePicker!
    
    //For store a reference to the application delegate
    var appDelegate: AppDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get selected list name from previous view and put it in the textField.
        reminderText.text = selectedList
        self.canDisplayBannerAds = true

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   // The action of click "Set reminder", verifies that access to the event store has not already been obtained and, in the event that it has not, requests access to the reminder calendars. If access is denied a message is reported to the console. If access is granted, a second method named createReminder is called.
    @IBAction func setReminder(sender: AnyObject) {
        // Declair a instance of AppDelegate
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
            do { try self.createReminder()
            } catch {
            
                print(error)

            }
        }
        
        
    }
    
    // Create a defaut reminder and a alarm added, save to eventStore.
    func createReminder() throws {
        
        guard let eventStore = appDelegate?.eventStore else {
            let error: NSError = NSError(domain: "com.mycompany.myapp", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Unable to get event store from app delegate"
                ])
            throw error
        }
        
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = reminderText.text!
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        let date = myDatePicker.date
        
        
        let alarm = EKAlarm(absoluteDate: date)
        
        reminder.addAlarm(alarm)
        
        print(alarm)
        
        try eventStore.saveReminder(reminder, commit: true)

    }
    

}
