//
//  ViewController.swift
//  ToDoAppRealmYP
//
//  Created by mac on 11/26/23.
//

import UIKit
import RealmSwift

class Contact: Object{
   @Persisted var firstname: String
   @Persisted var lastname: String
    
   convenience init(firstname: String, lastname: String) {
       self.init()
        self.firstname = firstname
        self.lastname = lastname
    }
}

class ViewController: UIViewController {
    var contactArray = [Contact]()

    @IBOutlet weak var contactsTableView: UITableView!
    
    var contact = [Contact]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        
    }


    @IBAction func addContactBtnTapped(_ sender: UIBarButtonItem) {
        //contactConfiguration(isAdd: true, Index: 0)
        let alertController = UIAlertController(title: "Add Contact", message: "Please enter your contact details", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            if let firstname = alertController.textFields?.first?.text,
               let lastname = alertController.textFields?.last?.text{
                print(firstname, lastname)
                let contact = Contact(firstname: firstname, lastname: lastname)
                self.contactArray.append(contact)
                self.contactsTableView.reloadData() // compulsory method.

            }
            if let lastname = alertController.textFields?[1].text{
                print(lastname)
            }

        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addTextField{firstnameField in
            firstnameField.placeholder = "Enter your firstname"
        }
        alertController.addTextField{lastnameField in
            lastnameField.placeholder = "Enter your lastname"

        }


        present(alertController, animated: true)
        alertController.addAction(save)
        alertController.addAction(cancel)
    }
}

extension ViewController{
    func configuration(){
        contactsTableView.dataSource = self // compulsory method.
        contactsTableView.delegate = self  // compulsory method.
        contactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        contactArray = DataBaseHelper.shared.getAllContacts()
    }
    
    func contactConfiguration(isAdd:Bool, Index:Int){
        
        
//            let alertController = UIAlertController(title: "Add Contact", message: "Please enter your contact details", preferredStyle: .alert)
        
        //by using ternary operattor
        let alertController = UIAlertController(title: isAdd ? "Add Contact" : "Update Contact", message: isAdd ? "Please enter your contact detail": "Please update your contact" , preferredStyle: .alert)
        
            //let save = UIAlertAction(title: "Save", style: .default) { _ in
        let save = UIAlertAction(title: isAdd ? "Save" : "Update", style: .default){ _ in
                if let firstname = alertController.textFields?.first?.text,
                   let lastname = alertController.textFields?.last?.text{
                    print(firstname, lastname)
                    let contact = Contact(firstname: firstname, lastname: lastname)
                    if isAdd{
                        self.contactArray.append(contact)
                        DataBaseHelper.shared.saveContact(contact: contact)

                    }else{
                        //self.contactArray[Index] = contact
                        //for update realm data.
                        DataBaseHelper.shared.updateContact(oldContact: self.contactArray[Index], newContact: contact)

                    }
//                    self.contactArray.append(contact)
                   // self.contactArray[indexPath.row] = contact
                    self.contactsTableView.reloadData() // compulsory method.

                }

            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addTextField{firstnameField in
                // first this is simplest method.
//                firstnameField.placeholder = self.contactArray[indexPath.row].firstname
                
                //second method with if else.
//                if isAdd{
//                    firstnameField.placeholder = "Enter your firsttname"
//
//                }else{
//                    firstnameField.placeholder = self.contactArray[Index].firstname
//                }
                
                //third method with contactConfiguration.
                firstnameField.placeholder = isAdd ? "Enter your firstname" : self.contactArray[Index].firstname
            }
            alertController.addTextField{lastnameField in
                // first this is simplest method.
                //lastnameField.placeholder = self.contactArray[indexPath.row].lastname
                
                //second method with if else
//                if isAdd{
//                    lastnameField.placeholder = "Enter your lastname"
//
//                }else{
//                    lastnameField.placeholder = self.contactArray[Index].lastname
//                }
                //third method with contactConfiguration.
                lastnameField.placeholder = self.contactArray[Index].lastname
                

            }


            self.present(alertController, animated: true)
            alertController.addAction(save)
            alertController.addAction(cancel)
        }
        
            


        
        
    
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = contactsTableView.dequeueReusableCell(withIdentifier: "cell") else{
            return UITableViewCell()
        }
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = contactArray[indexPath.row].firstname
        cell.detailTextLabel?.text = contactArray[indexPath.row].lastname
        return cell
        
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit"){ _,_,_ in
            self.contactConfiguration(isAdd: false, Index: indexPath.row)
        }
        edit.backgroundColor = .systemMint
            
           //controller code
            
            let delete = UIContextualAction(style: .destructive, title: "Delete") { _,_,_ in
                print(self.contactArray[indexPath.row])
                DataBaseHelper.shared.deleteContact(contact: self.contactArray[indexPath.row])
                self.contactArray.remove(at: indexPath.row)
                self.contactsTableView.reloadData()
            }
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete, edit])
            return swipeConfiguration
            
            
            
        }
        
        
        
    }
    
    
    
    
    



//            let alertController = UIAlertController(title: "Add Contact", message: "Please enter your contact details", preferredStyle: .alert)
//            let save = UIAlertAction(title: "Save", style: .default) { _ in
//                if let firstname = alertController.textFields?.first?.text,
//                   let lastname = alertController.textFields?.last?.text{
//                    print(firstname, lastname)
//                    let contact = Contact(firstname: firstname, lastname: lastname)
////                    self.contactArray.append(contact)
//                    self.contactArray[indexPath.row] = contact
//                    self.contactsTableView.reloadData() // compulsory method.
//
//                }
//
//            }
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alertController.addTextField{firstnameField in
//                firstnameField.placeholder = self.contactArray[indexPath.row].firstname
//            }
//            alertController.addTextField{lastnameField in
//                lastnameField.placeholder = self.contactArray[indexPath.row].lastname
//
//            }
//
//
//            self.present(alertController, animated: true)
//            alertController.addAction(save)
//            alertController.addAction(cancel)

