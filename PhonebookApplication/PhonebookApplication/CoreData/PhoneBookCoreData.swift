//
//  PhoneBookCoreData.swift
//  PhonebookApplication
//
//  Created by Vaishnav on 10/01/18.
//  Copyright © 2018 Vaishnav. All rights reserved.
//

import UIKit
import CoreData

class PhoneBookCoreData: NSObject {
    
    
    // MARK: - Singleton Object -
    
    static let sharedInstance = PhoneBookCoreData()
    
    
    // MARK: - Core Data stack -
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PhonebookApplication")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support -
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}



extension PhoneBookCoreData
{
    
    //MARK:- Fecth contacts form core data
    
    func fetchContacts() -> [UserData]
    {
        var contacts = [UserData]()
        do
        {
            let fetchRequestForEntityMem = NSFetchRequest<NSFetchRequestResult>(entityName: AppConstants.ENTITY_NAME)
            fetchRequestForEntityMem.returnsObjectsAsFaults = false
            let fetchResults = try persistentContainer.viewContext.fetch(fetchRequestForEntityMem) as! [UserData]
            if fetchResults.count > 0 {
                contacts = fetchResults
            }
        }catch{
            print("Fetch contacts request error = \(error.localizedDescription)")
        }
        return contacts
    }
    
    
    //MARK:- Create contact
    
    func createContact(name : String, phoneNumber : String, email : String) -> Bool
    {
        var isInserted = false
        
        let entityDescription = NSEntityDescription.entity(forEntityName: AppConstants.ENTITY_NAME, in: persistentContainer.viewContext)
        do {
            let uuid = NSUUID().uuidString
            let userEntity = UserData(entity: entityDescription!, insertInto: persistentContainer.viewContext)
            userEntity.setValue(name, forKeyPath: AppConstants.USER_NAME)
            userEntity.setValue(phoneNumber, forKeyPath: AppConstants.USER_PHONE)
            userEntity.setValue(email, forKeyPath: AppConstants.USER_EMAIL)
            userEntity.setValue(uuid, forKeyPath: AppConstants.USER_ID)
            try persistentContainer.viewContext.save()
            isInserted = true
        } catch {
            isInserted = false
            print("Insert user error = \(error.localizedDescription)")
        }
        return isInserted
    }
    
    
    
    //MARK:- Delete contact
    
    func deleteContact(userID : String) -> Bool
    {
        var isDeleted = false
        do
        {
            let fetchRequestForEntityMem = NSFetchRequest<NSFetchRequestResult>(entityName: AppConstants.ENTITY_NAME)
            fetchRequestForEntityMem.returnsObjectsAsFaults = false
            fetchRequestForEntityMem.predicate =  NSPredicate(format: "\(AppConstants.USER_ID) == %@", userID)
            let managedContext = persistentContainer.viewContext
            let fetchResults = try persistentContainer.viewContext.fetch(fetchRequestForEntityMem) as! [UserData]
            if fetchResults.count > 0 {
                let item = fetchResults[0]
                managedContext.delete(item)
                try persistentContainer.viewContext.save()
            }
            isDeleted = true
        }catch{
            isDeleted = false
            print("Delete request error = \(error.localizedDescription)")
        }
        return isDeleted
    }
    
    
    
    
    //MARK:- Update contact
    
    func updateContact(name : String, phoneNumber : String, email : String, userID : String) -> Bool
    {
        var isUpdated = false
        do
        {
            let fetchRequestForEntityMem = NSFetchRequest<NSFetchRequestResult>(entityName: AppConstants.ENTITY_NAME)
            fetchRequestForEntityMem.returnsObjectsAsFaults = false
            fetchRequestForEntityMem.predicate =  NSPredicate(format: "\(AppConstants.USER_ID) == %@", userID)
            let fetchResults = try persistentContainer.viewContext.fetch(fetchRequestForEntityMem) as! [UserData]
            if fetchResults.count > 0 {
                let managedObject : UserData = fetchResults.first!
                managedObject.setValue(name, forKeyPath: AppConstants.USER_NAME)
                managedObject.setValue(phoneNumber, forKeyPath: AppConstants.USER_PHONE)
                managedObject.setValue(email, forKeyPath: AppConstants.USER_EMAIL)
                try persistentContainer.viewContext.save()            }
            isUpdated = true
        }catch{
            isUpdated = false
            print("Update request error = \(error.localizedDescription)")
        }
        return isUpdated
    }
}
