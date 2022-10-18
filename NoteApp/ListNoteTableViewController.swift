//
//  ListNoteTableViewController.swift
//  NoteApp
//
//  Created by 黃偉倫 on 2021/4/21.
//  Copyright © 2021 Wei-Lun Huang. All rights reserved.
//

import UIKit
import CoreData

class ListNoteTableViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    var ListNotes: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        ListNotes = fetchNotes()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    func deleteNote(_ ListNote: NSManagedObject) {
    managedObjectContext.delete(ListNote)
    appDelegate.saveContext()
        
        print("Delete Success!!!")
        
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ListNotes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
        
        let ListNote = ListNotes[indexPath.row]
        let Notetitle = ListNote.value(forKey: "title") as? String
        let Notecontent = ListNote.value(forKey: "content") as? NSData
        let ListArray = DecodeContent(contentData: Notecontent!)
        
        cell.textLabel?.text = Notetitle
        cell.detailTextLabel?.text = "Have \(ListArray.count) cells in the list"

        // Configure the cell...

        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(
                title: "Delete The Note?", message: ListNotes[indexPath.row].value(forKey: "title") as! String, preferredStyle: .alert
            )
            
            let goAction = UIAlertAction(
                title: "Delete" , style: .destructive, handler: { (action) in
                    
                    self.deleteNote(self.ListNotes[indexPath.row])
                    self.ListNotes.remove(at: indexPath.row)

                    
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "toAddListNote" {
            let vc = segue.destination as! AddListNoteViewController
          //  vc.quotationNumber = quotations.count + 1
        }
        
        if segue.identifier == "ToDetailListNote" {
            let vc = segue.destination as! DetailListNoteViewController
            let index = self.tableView.indexPathForSelectedRow?.row
            
            vc.selectNum = index!
            
      //      print(BasicNotes[index!].value(forKey: "content")!)
            print("To Detail View")
            
          //  vc.quotation = quotations[index!]
        }
    }

    @IBAction func unwindToListNoteView(segue: UIStoryboardSegue) {
        let vc = segue.source as! AddListNoteViewController
        ListNotes = fetchNotes()
        self.tableView.reloadData()
        
        
    /*    if let quotation = vc.quotation {
            quotations.append(quotation)
            self.tableView.reloadData()
        }   */
    }
    
    
    
}
