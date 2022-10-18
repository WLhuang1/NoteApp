//
//  BasicNoteTableViewController.swift
//  NoteApp
//
//  Created by 黃偉倫 on 2021/4/13.
//  Copyright © 2021 Wei-Lun Huang. All rights reserved.
//

import UIKit
import CoreData

class BasicNoteTableViewController: UITableViewController {
    
    var BasicNotes: [NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        
        BasicNotes = fetchNotes()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //CoreData
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
    
    /*
    func printNote(_ player: NSManagedObject) {
    let notetitle = player.value(forKey: "title") as? String
    let notecontent = player.value(forKey: "content") as? String
    print("Player: quote = \(notetitle!), author = \(notecontent!)")
        
    }
    */
    
    func deleteNote(_ BasicNote: NSManagedObject) {
    managedObjectContext.delete(BasicNote)
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
        return BasicNotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
        
        let BasicNote = BasicNotes[indexPath.row]
        let Notetitle = BasicNote.value(forKey: "title") as? String
        let Notecontent = BasicNote.value(forKey: "content") as? String
        
        cell.textLabel?.text = Notetitle
        cell.detailTextLabel?.text = Notecontent

        // Configure the cell...

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(
                title: "Delete The Note?", message: BasicNotes[indexPath.row].value(forKey: "title") as! String, preferredStyle: .alert
            )
            
            let goAction = UIAlertAction(
                title: "Delete" , style: .destructive, handler: { (action) in
                    
                    self.deleteNote(self.BasicNotes[indexPath.row])
                    self.BasicNotes.remove(at: indexPath.row)

                    
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
        
        
        if segue.identifier == "toAddBasicNote" {
            let vc = segue.destination as! AddBasicNoteViewController
          //  vc.quotationNumber = quotations.count + 1
        }
        
        if segue.identifier == "ToDetailBasicNote" {
            let vc = segue.destination as! DetailBasicNoteViewController
            let index = self.tableView.indexPathForSelectedRow?.row
            
            vc.selectNum = index!
            
      //      print(BasicNotes[index!].value(forKey: "content")!)
            print("To Detail View")
            
          //  vc.quotation = quotations[index!]
        }
    }

    @IBAction func unwindToBasicNoteView(segue: UIStoryboardSegue) {
        let vc = segue.source as! AddBasicNoteViewController
        BasicNotes = fetchNotes()
        self.tableView.reloadData()
        
        
    /*    if let quotation = vc.quotation {
            quotations.append(quotation)
            self.tableView.reloadData()
        }   */
    }
    

}
