//
//  ContactsListViewController.swift
//  PhonebookApplication
//
//  Created by Vaishnav on 08/01/18.
//  Copyright © 2018 Vaishnav. All rights reserved.
//

import UIKit
import CoreData

class ContactsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {

    //MARK: Outlets
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    
    //MARK: Variables

    var contants = [UserData]()
    var filteredContacts = [UserData]()
    var searchActive = false
    let searchBarUsed = UISearchController(searchResultsController: nil)
    
    
    //MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = "Contacts"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.fetchContacts()
    }
    
    //MARK:- Fetch contacts
    func fetchContacts()
    {
        self.contants = PhoneBookCoreData.sharedInstance.fetchContacts()
        self.contactsTableView.reloadData()
    }
    
    
    //MARK: - InitialSetUp
    
    func initialSetup() {
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Contacts"
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.searchBarUsed.delegate = self
        searchBarUsed.searchResultsUpdater = self
        self.navigationItem.searchController = searchBarUsed
        searchBarUsed.searchBar.barTintColor = UIColor.white
        searchBarUsed.searchBar.tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightbarButtonClicked))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.contactsTableView.tableFooterView = UIView()
        searchBarUsed.searchBar.searchBarStyle = .prominent
    }
    
    
    //MARK: Tableview Datasource and Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive
        {
            if self.filteredContacts.count > 0
            {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView = nil
                return self.filteredContacts.count
            } else {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No results found"
                noDataLabel.textColor     = UIColor.darkGray
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
                return 0
            }
        }else{
            if self.contants.count > 0
            {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView = nil
                return self.contants.count
            }else{
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No contacts found"
                noDataLabel.textColor     = UIColor.darkGray
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reUseID = "ContactsCell"
        let theCell = UITableViewCell.init(style: .subtitle, reuseIdentifier: reUseID)
        theCell.selectionStyle = .none
        theCell.imageView?.contentMode = .scaleAspectFit

        if searchActive
        {
            theCell.textLabel?.text = self.filteredContacts[indexPath.row].name
            theCell.detailTextLabel?.text = self.filteredContacts[indexPath.row].phoneNo
            theCell.imageView?.image = UIImage(named: "male")
            return theCell
        }else{
            theCell.textLabel?.text = self.contants[indexPath.row].name
            theCell.detailTextLabel?.text = self.contants[indexPath.row].phoneNo
            theCell.imageView?.image = UIImage(named: "male")
            return theCell
        }
    }
    
    
    

    //MARK: Swipe leading Actions
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let callAction = UIContextualAction(style: .normal, title: "Call") {(action, view, handler) in
            guard let number = URL(string: "tel://" + "\(String(describing: self.contants[indexPath.row].phoneNo!))") else { return }
            UIApplication.shared.open(number)
        }
        callAction.backgroundColor = UIColor(red:0.17, green:0.70, blue:0.44, alpha:1.0)
        let configuration = UISwipeActionsConfiguration(actions:[callAction])
        return configuration
    }
    
    
    //MARK: swipe trailing Actions
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "delete") {(action, view, handler) in
            
            let alert = UIAlertController(title: "Delete..?", message: "Do you want to delete \(String(describing: self.contants[indexPath.row].name!))", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                
                //MARK: - Remove members from a Group
                
                if PhoneBookCoreData.sharedInstance.deleteContact(userID: self.contants[indexPath.row].userUUID!)
                {
                    print("Deleted successfully")
                    self.fetchContacts()
                }else{
                   print("Unable delete contact")
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)        }
            delete.backgroundColor = UIColor(red:0.98, green:0.36, blue:0.27, alpha:1.0)
            let configuration = UISwipeActionsConfiguration(actions: [delete])
            return configuration
    
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreateContactSTBID") as! CreateContactViewController
        nextVC.contact = self.contants[indexPath.row]
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    //MARK: - Functions
    
    @objc func rightbarButtonClicked() {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "CreateContactSTBID") as! CreateContactViewController
        navigationController?.pushViewController(nextVC, animated: true)
    }
}


extension ContactsListViewController : UISearchBarDelegate, UISearchResultsUpdating
{
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        self.searchActive = true
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredContacts = self.contants.filter { contact in
                return (contact.name?.lowercased().contains(searchText.lowercased()))!
            }
            
        } else {
            filteredContacts = contants
        }
        contactsTableView.reloadData()
    }
}
