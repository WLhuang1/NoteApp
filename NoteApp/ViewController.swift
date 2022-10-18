//
//  ViewController.swift
//  NoteApp
//
//  Created by 黃偉倫 on 2021/4/13.
//  Copyright © 2021 Wei-Lun Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var NotificationMessage: UILabel!
    
    
    var NotifiId : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func ToBasicNoteButton(_ sender: UIButton) {
        print("Go To Basic Note")
    }
    
    
    func handleNotification(_ response: UNNotificationResponse) {
        
        let message = response.notification.request.content.body as! String
        NotificationMessage.text = "New Notification:  \(message)"
        print("received notification message: \(message)")
        
        
        NotifiId = message

        
    }
    
    
    
    
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         
         
         if segue.identifier == "toBasicNoteView" {
            print("Go To Watch Basic Note")
           //  vc.quotationNumber = quotations.count + 1
         }
         
     }
    
    

}

