//
//  PictureNoteTableViewController.swift
//  NoteApp
//
//  Created by 黃偉倫 on 2021/4/23.
//  Copyright © 2021 Wei-Lun Huang. All rights reserved.
//

import UIKit
import CoreData

class PictureNoteTableViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    var PictureNotes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        PictureNotes = fetchNotes()
      //  print("Count \(PictureNotes.count)")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    func deleteNote(_ PictureNote: NSManagedObject) {
    managedObjectContext.delete(PictureNote)
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
        return PictureNotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PNCell", for: indexPath) as! PictureNoteCell
        
        let PictureNote = PictureNotes[indexPath.row]
        let Notetitle = PictureNote.value(forKey: "title") as? String
        let Notecontent = PictureNote.value(forKey: "content") as! Data

        
        cell.TitleLabel.text = Notetitle
        cell.ContentView.image = UIImage(data: Notecontent)
        // Configure the cell...

        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(
                title: "Delete The Note?", message: PictureNotes[indexPath.row].value(forKey: "title") as! String, preferredStyle: .alert
            )
            
            let goAction = UIAlertAction(
                title: "Delete" , style: .destructive, handler: { (action) in
                    
                    self.deleteNote(self.PictureNotes[indexPath.row])
                    self.PictureNotes.remove(at: indexPath.row)

                    
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
        
        
        if segue.identifier == "toAddPictureNote" {
            let vc = segue.destination as! AddPictureNoteViewController
          //  vc.quotationNumber = quotations.count + 1
        }
        
        if segue.identifier == "ToDetailPictureNote" {
            let vc = segue.destination as! DetailPictureNoteViewController
            let index = self.tableView.indexPathForSelectedRow?.row
            
            vc.selectNum = index!
            
      //      print(BasicNotes[index!].value(forKey: "content")!)
            print("To Detail View")
            
          //  vc.quotation = quotations[index!]
        }
    }

    @IBAction func unwindToPictureNoteView(segue: UIStoryboardSegue) {
        let vc = segue.source as! AddPictureNoteViewController
       
        PictureNotes = fetchNotes()
        self.tableView.reloadData()
        
        
    /*    if let quotation = vc.quotation {
            quotations.append(quotation)
            self.tableView.reloadData()
        }   */
    }
    

    

}
