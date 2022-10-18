//
//  AddPictureNoteViewController.swift
//  NoteApp
//
//  Created by 黃偉倫 on 2021/4/23.
//  Copyright © 2021 Wei-Lun Huang. All rights reserved.
//

import UIKit
import CoreData

class AddPictureNoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    var PictureNotes: [NSManagedObject] = []
    
    @IBOutlet weak var TitleField: UITextField!
    @IBOutlet weak var ContentView: UIImageView!
    
    @IBOutlet weak var ContentImage: UIImageView!
    
    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        PictureNotes = fetchNotes()
        // Do any additional setup after loading the view.
    }
    
    //Buttons
    @IBAction func SavePictureNote(_ sender: Any) {
        
        if TitleField.text != "" {
            
            if let imageData = ContentView.image?.pngData() {
                self.insertNote(notetitle: TitleField.text!, notecontent: imageData)
                
            } else {
                print("Failed!! Not Picture")
            }
            print ("Save Success!!!")
            
        } else {
            print("Save Failed!!!")
        }
        
        TitleField.text = ""
        
        self.performSegue(withIdentifier: "unwindToPictureNoteView", sender: self)
        
    }
    
    @IBAction func CancelPictureNote(_ sender: Any) {
        print("Cancel Save")
        self.performSegue(withIdentifier: "unwindToPictureNoteView", sender: self)
        
    }
    
    @IBAction func SelectImage(_ sender: Any) {
        selectImageFromLibrary()
        
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
    
    func insertNote(notetitle: String, notecontent: Data) {
    let PictureNote = NSEntityDescription.insertNewObject(forEntityName:
    "TypePictureNote", into: self.managedObjectContext)
        
    PictureNote.setValue(notetitle, forKey: "title")
    PictureNote.setValue(notecontent, forKey: "content")
    appDelegate.saveContext() // In AppDelegate.swift
        
    }
    
    
    
    //ImagePicker
    func selectImageFromLibrary () {
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
            } else {
                print("photo library not available")
                }
        
    }
    
    // UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
    if let image = info[.originalImage] as? UIImage {
            ContentView.image = image
            }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    //Drawing ON picture
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }
      swiped = false
      lastPoint = touch.location(in: ContentView)
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
      // 1
      UIGraphicsBeginImageContext(ContentView.frame.size)
      guard let context = UIGraphicsGetCurrentContext() else {
        return
      }
      ContentView.image?.draw(in: ContentView.bounds)
        
      // 2
      context.move(to: fromPoint)
      context.addLine(to: toPoint)
      
      // 3
      context.setLineCap(.round)
      context.setBlendMode(.normal)
      context.setLineWidth(brushWidth)
      context.setStrokeColor(color.cgColor)
      
      // 4
      context.strokePath()
      
      // 5
      ContentView.image = UIGraphicsGetImageFromCurrentImageContext()
      ContentView.alpha = opacity
      UIGraphicsEndImageContext()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }

      // 6
      swiped = true
      let currentPoint = touch.location(in: ContentView)
      drawLine(from: lastPoint, to: currentPoint)
        
      // 7
      lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      if !swiped {
        // draw a single point
        drawLine(from: lastPoint, to: lastPoint)
      }
        
        /*
      // Merge tempImageView into mainImageView
      UIGraphicsBeginImageContext(ContentView.frame.size)
      ContentView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
      TempView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
      ContentView.image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
        
      TempView.image = nil
        */
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
