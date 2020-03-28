//
//  ViewController.swift
//  coepiiosdemo
//
//  Created by Rodney Witcher on 3/24/20.
//  Copyright © 2020 coepi. All rights reserved.
//

import UIKit
import CoreBluetooth
import RealmSwift

class CoEpiViewController: UIViewController, CentralDelegate, PeripheralDelegate, UITableViewDelegate , UITableViewDataSource {
    var coepiCentral: Central!
    var coepiPeripheral: Peripheral!
    
    var contactList: [CEN]?
    
    @IBOutlet weak var contactListTableView: UITableView!
    
    @IBOutlet weak var SymptomsTextView: UITextView!
    @IBOutlet weak var SubmitSymptomsButton: UIButton!
    @IBOutlet weak var SubmitSymptomsStatusLabel: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ContactTableViewCell"
        guard let contactCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactTableViewCell else {
            fatalError("dequed cell is not an instance of ContactTableViewCell")
        }
        
        print("ContactList Item: \(String(describing: contactList?[indexPath.row].CEN)) as \(String(describing: contactList?[indexPath.row].CEN)), encoding: .utf8))")
        contactCell.CENLabel.text = contactList?[indexPath.row].CEN
        return contactCell
    }
    
    func onDiscovered(peripheral: CBPeripheral) {
        
    }
    
    func onCentralContact(_ contact: CEN) {
        print("onCentralContact with contact \(contact) having id: \(contact.CEN)")
        if contact.insert() {
            contactList?.reverse()
            contactList?.append(contact)
            contactList?.reverse()
        }
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
        
        self.contactList = loadAllCENRecords() ?? []
        SymptomsTextView.layer.borderWidth = 1
    }
    
    @IBAction func ReportSymptoms(_ sender: Any) {
        SubmitSymptomsStatusLabel.text = "Submitting symptoms ..."
        let symptomsText: String = SymptomsTextView.text
        var symptomsTextBase64: String = ""
        if let symptomsTextData = (symptomsText).data(using: String.Encoding.utf8) {
            symptomsTextBase64 = symptomsTextData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            print("symptomsTextData \(symptomsTextData)")
        }
        let currentUUID: String = UUID().uuidString
        let currentTS:Int = Int(Date().timeIntervalSince1970)
        let retrievedCENKeys:[CENKey] = CENKey.getCENKeys(limit: 3) ?? []
        var retrievedCENKeysString: String = ""
        for index in 0..<retrievedCENKeys.count {
            if index != 0 {
                retrievedCENKeysString += ","
            }
            retrievedCENKeysString += base64ToString(b64: retrievedCENKeys[index].cenKey!)
        }
        
        //let encRetrievedCENKeys = (try? JSONEncoder().encode(retrievedCENKeys)) ?? Data()
        let newCENReport = CENReport(CENReportID: currentUUID, report: symptomsTextBase64, reportMimeType: "text", reportTimestamp: currentTS, CENKeys: retrievedCENKeysString, isUser: false)
        if newCENReport.insert() {
            CoEpiAPI().postCENReport(cenreport: newCENReport)
            SubmitSymptomsStatusLabel.text = "Symptoms successfully submitted"
        } else {
            SubmitSymptomsStatusLabel.text = "Error submitting symptoms"
        }
    }
}

