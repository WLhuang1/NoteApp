//
//  AddListNoteViewController.swift
//  NoteApp
//
//  Created by 黃偉倫 on 2021/4/21.
//  Copyright © 2021 Wei-Lun Huang. All rights reserved.
//

import UIKit
import CoreData

class AddListNoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ContentView: UITableView!
    
    @IBOutlet weak var TitleText: UITextField!
    @IBOutlet weak var ContentText: UITextField!
    
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    var ListNotes: [NSManagedObject] = []
    var ListNoteContent: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ContentView.delegate = self
        ContentView.dataSource = self
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        ListNotes = fetchNotes()
        
        // Do any additional setup after loading the view.
    }
    
    //Core Data Function
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
    
    func insertNote(notetitle: String, notecontent: [String]) {
    let ListNote = NSEntityDescription.insertNewObject(forEntityName:
    "TypeListNote", into: self.managedObjectContext)
    let notecontentdata = try? NSKeyedArchiver.archivedData(withRootObject: notecontent, requiringSecureCoding: true)
        
    ListNote.setValue(notetitle, forKey: "title")
    ListNote.setValue(notecontentdata, forKey: "content")
    appDelegate.saveContext() // In AppDelegate.swift
        
    }
    
    //Buttons
    @IBAction func AddContent(_ sender: Any) {
        if ContentText.text != "" {
            ListNoteContent.append(ContentText.text!)
            ContentView.reloadData()
            
            print("Add Success!!")
            
        }
        
        ContentText.text = ""
        
    }
    
    @IBAction func SaveListNote(_ sender: Any) {
        if (TitleText.text != "") {
            
            if ListNoteContent.count != 0 {
            let newtitle = TitleText.text!
            
            insertNote(notetitle: newtitle, notecontent: ListNoteContent)
                
            print ("Add Note Success!!!")
            }
        } else {
            print ("Add Note Fail!!!")
        }
        
        performSegue(withIdentifier: "unwindToListNoteView", sender: self)
        
    }
    
    @IBAction func CancelSaveListNote(_ sender: Any) {
        performSegue(withIdentifier: "unwindToListNoteView", sender: self)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
        
    //    let BasicNote = BasicNotes[indexPath.row]
     //   let Notetitle = BasicNote.value(forKey: "title") as? String
    //    let Notecontent = BasicNote.value(forKey: "content") as? String
        
        cell.textLabel?.text = ListNoteContent[indexPath.row]
     //   cell.detailTextLabel?.text = Notecontent

        // Configure the cell...

        return cell
    }
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(
                title: "Delete The Content?", message: ListNoteContent[indexPath.row], preferredStyle: .alert
            )
            
            let goAction = UIAlertAction(
                title: "Delete" , style: .destructive, handler: { (action) in

                    self.ListNoteContent.remove(at: indexPath.row)

                    
                    // Delete the row from the data source
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    //self.ConfirmDele = true
                    print("Delete Success")
            }
            )
            
            let cancelAction = UIAlertAction(
                title: "Cancel", style: .cancel, handler: { (action) in
                    //self.ConfirmDele = false
                    print("cancel Delete")
            }
            )
            
            alert.addAction(goAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    

}
