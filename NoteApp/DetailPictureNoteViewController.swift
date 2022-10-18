//
//  DetailPictureNoteViewController.swift
//  NoteApp
//
//  Created by 黃偉倫 on 2021/4/23.
//  Copyright © 2021 Wei-Lun Huang. All rights reserved.
//

import UIKit
import CoreData

class DetailPictureNoteViewController: UIViewController {

    @IBOutlet weak var TitleText: UITextField!
    @IBOutlet weak var ContentView: UIImageView!
    
    @IBOutlet weak var PickerField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    var PictureNotes: [NSManagedObject] = []
    
    var DatePicker = UIDatePicker()
    
    var selectNum: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TitleText.isUserInteractionEnabled = false
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        PictureNotes = fetchNotes()
        
        let Notecontent = PictureNotes[selectNum].value(forKey: "content") as! Data
        ContentView.image = UIImage(data: Notecontent)
        TitleText.text = PictureNotes[selectNum].value(forKey: "title") as! String
        
        CreateDatePicker()
        
        // Do any additional setup after loading the view.
    }
    
    //Core Data Function
    func fetchNotes() -> [NSManagedObject] {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TypePictureNote")
    var PictureNotes: [NSManagedObject] = []
    do {
    PictureNotes = try self.managedObjectContext.fetch(fetchRequest)
    
    } catch {
    print("getPlayers error: \(error)")
    }
        print("Fetch Success!!!")
        return PictureNotes
        
    }
    
    
    //Buttons
    @IBAction func QuickReminder(_ sender: Any) {
        scheduleNotification()
        
    }
    
    //Notification
    func scheduleNotification () {
        
        let content = UNMutableNotificationContent()
        content.title = "Basic Note of the Day"
        content.body = PictureNotes[selectNum].value(forKey: "title") as! String
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
        content.body = PictureNotes[selectNum].value(forKey: "title") as! String
        
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
