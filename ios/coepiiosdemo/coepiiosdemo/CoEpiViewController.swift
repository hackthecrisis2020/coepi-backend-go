//
//  ViewController.swift
//  coepiiosdemo
//
//  Created by Rodney Witcher on 3/24/20.
//  Copyright © 2020 coepi. All rights reserved.
//

import UIKit
import CoreBluetooth

class CoEpiViewController: UIViewController, CentralDelegate, PeripheralDelegate, UITableViewDelegate , UITableViewDataSource {
    var coepiCentral: Central!
    var coepiPeripheral: Peripheral!
    
    var contactList: [CEN] = [CEN]()
    
    @IBOutlet weak var contactListTableView: UITableView!
    
    @IBOutlet weak var SymptomsTextView: UITextView!
    @IBOutlet weak var SubmitSymptomsButton: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ContactTableViewCell"
        guard let contactCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactTableViewCell else {
            fatalError("dequed cell is not an instance of ContactTableViewCell")
        }
        
        print("ContactList Item: \(contactList[indexPath.row].CEN) as \(contactList[indexPath.row].CEN), encoding: .utf8))")
        contactCell.CENLabel.text = contactList[indexPath.row].CEN
        return contactCell
    }
    
    func onDiscovered(peripheral: CBPeripheral) {
        
    }
    
    func onCentralContact(_ contact: CEN) {
        print("onCentralContact with contact \(contact) having id: \(contact.CEN)")
        contactList.append(contact)
        self.contactListTableView.reloadData()
    }
    
    func onPeripheralStateChange(description: String) {
        
    }
    
    func onPeripheralContact(_ contact: CEN) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        coepiCentral = Central(delegate: self)
        coepiPeripheral = Peripheral(delegate: self)
        
        self.contactListTableView.delegate = self
        self.contactListTableView.dataSource = self
        
        query realm for contactList on load
    }
}

