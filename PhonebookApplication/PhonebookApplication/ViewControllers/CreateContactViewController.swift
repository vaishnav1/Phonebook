//
//  CreateContactViewController.swift
//  PhonebookApplication
//
//  Created by Vaishnav on 08/01/18.
//  Copyright © 2018 Vaishnav. All rights reserved.
//

import UIKit
import CoreData

class CreateContactViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var nameTF:  UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var subView: UIView!
    
    
    //MARK: Variables

    var contact : UserData?
    
    //MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add new contact"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        saveButton.layer.cornerRadius = saveButton.frame.size.height / 2
        
        //MARK: Assign data
        
        if self.contact?.name != nil && self.contact?.phoneNo != nil && self.contact?.userUUID != nil
        {
            nameTF.text = self.contact?.name
            phoneTF.text = self.contact?.phoneNo
            emailTF.text = self.contact?.email
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    
    //MARK: Action Methods
    
    @IBAction func saveClicked() {
        if !(phoneTF.text?.isEmpty)! && !(emailTF.text?.isEmpty)! && !(nameTF.text?.isEmpty)! {
        if validateEmail(value: emailTF.text!) {
            
            if self.contact?.name != nil && self.contact?.phoneNo != nil && self.contact?.userUUID != nil
            {
                
                if PhoneBookCoreData.sharedInstance.updateContact(name: nameTF.text!, phoneNumber: phoneTF.text!, email: emailTF.text!, userID: (self.contact?.userUUID)!)
                {
                    self.view.endEditing(true)
                    let alert = UIAlertController(title: "", message: "Contact updated successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style:.default, handler: {action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    alertController(title: "", message: "Unable to update contact")
                }

            } else {
                
                if PhoneBookCoreData.sharedInstance.createContact(name: nameTF.text!, phoneNumber: phoneTF.text!, email: emailTF.text!)
                {
                    self.view.endEditing(true)
                    let alert = UIAlertController(title: "", message: "Contact saved successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style:.default, handler: {action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    alertController(title: "", message: "Unable to save contact")
                }

            }

         } else {
            alertController(title: "Ok", message: "Please enter valid E-mail id")
        }
    } else {
            alertController(title: "Ok", message: "Please complete all the fields")
   }
}
    
    
    
    //MARK: Email Validation
    
    func validateEmail(value: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            
            return regex.firstMatch(in: value, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, value.count)) != nil
            
        } catch {
            return false
        }
    }
    
    
    //MARK: - Create alert function
    
    func alertController(title: String , message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "Okay", style: .default, handler: {(alert: UIAlertAction!) in
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Dismiss keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }    
}
