//
//  AddBasicNoteViewController.swift
//  NoteApp
//
//  Created by 黃偉倫 on 2021/4/14.
//  Copyright © 2021 Wei-Lun Huang. All rights reserved.
//

import UIKit
import CoreData

class AddBasicNoteViewController: UIViewController {

    var BasicNotes: [NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var TitleText: UITextField!
    @IBOutlet weak var ContentText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        BasicNotes = fetchNotes()

        TitleText.text = ""
        ContentText.text = ""
        
        // Do any additional setup after loading the view.
    }
    
    //Core Data Function
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
    
    func insertNote(notetitle: String, notecontent: String) {
    let BasicNote = NSEntityDescription.insertNewObject(forEntityName:
    "TypeBasicNote", into: self.managedObjectContext)
    BasicNote.setValue(notetitle, forKey: "title")
    BasicNote.setValue(notecontent, forKey: "content")
    appDelegate.saveContext() // In AppDelegate.swift
        
    }
    
    //Buttons
    @IBAction func SaveBasicNote(_ sender: Any) {
        
        if (TitleText.text != "") {
            
            let newtitle = TitleText.text!
            let newcontent = ContentText.text!
            
            insertNote(notetitle: newtitle, notecontent: newcontent)
            
            print ("Add Note Success!!!")
        } else {
            print ("Add Note Fail!!!")
        }
        
        performSegue(withIdentifier: "unwindToBasicNoteView", sender: self)
    }
    
    @IBAction func CancelBasicNote(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindToBasicNoteView", sender: self)
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
