//
//  reminderViewController.swift
//  ListApp
//
//  Created by Connie on 22/11/2015.
//

import UIKit
import EventKit

class reminderViewController: UIViewController {

    @IBOutlet var reminderText: UITextField!
    @IBOutlet var myDatePicker: UIDatePicker!
    var appDelegate: AppDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func setReminder(sender: AnyObject) {
        
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
        
        try eventStore.saveReminder(reminder, commit: true)

    }
    
//    func createReminder() {
//        
//        let reminder = EKReminder(eventStore: appDelegate!.eventStore!)
//        
//        reminder.title = reminderText.text!
//        reminder.calendar =
//            appDelegate!.eventStore!.defaultCalendarForNewReminders()
//        let date = myDatePicker.date
//        let alarm = EKAlarm(absoluteDate: date)
//        
//        reminder.addAlarm(alarm)
//        
//        var error: NSError?
//        appDelegate!.eventStore!.saveReminder(reminder,
//            commit: true, error: error)
//        
//        if error != nil {
//            print("Reminder failed with error \(error?.localizedDescription)")
//        }
//    }
    

//    //    Hiding the Keyboard
//     func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        reminderText.endEditing(true)
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
