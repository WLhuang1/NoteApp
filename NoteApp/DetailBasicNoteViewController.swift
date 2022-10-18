//
//  DetailBasicNoteViewController.swift
//  NoteApp
//
//  Created by 黃偉倫 on 2021/4/14.
//  Copyright © 2021 Wei-Lun Huang. All rights reserved.
//

import UIKit
import CoreData

class DetailBasicNoteViewController: UIViewController {

    var selectNum: Int = 0
    
    var BasicNotes: [NSManagedObject] = []
    
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    var DatePicker = UIDatePicker()
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ContentView: UITextView!
    @IBOutlet weak var PickerField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        
        BasicNotes = fetchNotes()
        
        TitleLabel.text = BasicNotes[selectNum].value(forKey: "title") as! String
        ContentView.text = BasicNotes[selectNum].value(forKey: "content") as! String
       // print(ContentView.text)

        CreateDatePicker()
        
        // Do any additional setup after loading the view.
    }
    
    func fetchNotes() -> [NSManagedObject] {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TypeBasicNote")
    var BasicNotes: [NSManagedObject] = []
    do {

    BasicNotes = try self.managedObjectContext.fetch(fetchRequest)
    } catch {
    print("getPlayers error: \(error)")
    }
        print("Fetch Success!!!")
        return BasicNotes
        
    }
    
    
    //Setting Notification
    
    @IBAction func FastRemind(_ sender: Any) {
        scheduleNotification()
    }
    
    func scheduleNotification () {
        
        let content = UNMutableNotificationContent()
        content.title = "Basic Note of the Day"
        content.body = BasicNotes[selectNum].value(forKey: "title") as! String
       // content.userInfo["id"] = quotation!.id
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: "NowPlusFive", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: {
            (error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
        }
        
        )
        
        print("Notification, \(content.body)")
        
    }
    
    func CreateDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let DoneB = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AfterPickeDate) )
        toolbar.setItems([DoneB], animated: true)
        

        PickerField.inputAccessoryView = toolbar
        PickerField.inputView = DatePicker
        
        DatePicker.datePickerMode = .time

    }
    
    @objc func AfterPickeDate() {
        
        let DateFor = DateFormatter()
        
       // DateFor.dateStyle = .short
        DateFor.timeStyle = .short
        
        PickerField.text = ("Set: \(DateFor.string(from: DatePicker.date))")
        self.view.endEditing(true)
        
        let content = UNMutableNotificationContent()
        content.title = "Basic Note of the Day"
        content.body = BasicNotes[selectNum].value(forKey: "title") as! String
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: DatePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "NowPlusFive", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: {
            (error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
        }
            )
        
      //  print("Notification Success!!! \(DateFor.string(from: DatePicker.date))")
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
