//
//  DetailListNoteViewController.swift
//  NoteApp
//
//  Created by 黃偉倫 on 2021/4/21.
//  Copyright © 2021 Wei-Lun Huang. All rights reserved.
//

import UIKit
import CoreData

class DetailListNoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ContentTable: UITableView!
    
    @IBOutlet weak var TitleText: UITextField!
    @IBOutlet weak var PickerField: UITextField!
    
    var selectNum: Int = 0
    
    var ListNoteContent: [String] = []
    
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    var ListNotes: [NSManagedObject] = []
    
    var DatePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TitleText.isUserInteractionEnabled = false
        
        ContentTable.delegate = self
        ContentTable.dataSource = self
        
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        ListNotes = fetchNotes()
        GetListArray()
        CreateDatePicker()

        // Do any additional setup after loading the view.
    }
    
    //CoreData
    func fetchNotes() -> [NSManagedObject] {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TypeListNote")
    var ListNotes: [NSManagedObject] = []
    do {

    ListNotes = try self.managedObjectContext.fetch(fetchRequest)
    } catch {
    print("getPlayers error: \(error)")
    }
        print("Fetch Success!!!")
        return ListNotes
        
    }
    
    func DecodeContent (contentData: NSData) -> [String] {
        let data = try? NSKeyedUnarchiver.unarchiveObject(with: contentData as Data)
        
        let arraydata = data as AnyObject? as! [String]
        
        return arraydata
        
    }
    
    func GetListArray() {
        
        let ListNote = ListNotes[selectNum]
        let Notetitle = ListNote.value(forKey: "title") as? String
        let Notecontent = ListNote.value(forKey: "content") as? NSData
        let ListArray = DecodeContent(contentData: Notecontent!)
        ListNoteContent = ListArray
        
        TitleText.text = Notetitle
        ContentTable.reloadData()
        
    }
    
    //Setting Notification
    
    @IBAction func QuickReminder(_ sender: Any) {
        scheduleNotification()
        
    }
    
    func scheduleNotification () {
        
        let content = UNMutableNotificationContent()
        content.title = "List Note of the Day"
        content.body = ListNotes[selectNum].value(forKey: "title") as! String
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
        content.title = "List of the Day"
        content.body = ListNotes[selectNum].value(forKey: "title") as! String
        
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
    
       
       // MARK: - Table view data source

       func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return ListNoteContent.count
       }

       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "LNCell", for: indexPath) as! ListNoteCell
           
           
           cell.ContentText.text = ListNoteContent[indexPath.row]
        //   cell.detailTextLabel?.text = Notecontent

           // Configure the cell...

           return cell
       }
    

}
