//
//  DataBaseHelper.swift
//  ToDoAppRealmYP
//
//  Created by mac on 11/27/23.
//

import Foundation
import UIKit
import RealmSwift

class DataBaseHelper{
    static let shared = DataBaseHelper()
    private var realm = try! Realm()
    
    // for knowing where is Realm data is stored.
    func getDataBaseURL() -> URL?{
        return Realm.Configuration.defaultConfiguration.fileURL
        
    }
    
    func saveContact(contact: Contact){
        try! realm.write{
            realm.add(contact)
        }
        
    }
    
    func updateContact(oldContact: Contact, newContact: Contact){
        try! realm.write({
            oldContact.firstname = newContact.firstname
            oldContact.lastname = newContact.lastname
            
        })
    }
    
    func deleteContact(contact: Contact){
        try! realm.write({
            realm.add(contact)
        })
        
        
    }
    
    func getAllContacts() -> [Contact]{
        return Array(realm.objects(Contact.self))
    }
  
}
