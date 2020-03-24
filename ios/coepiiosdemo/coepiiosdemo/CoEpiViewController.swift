//
//  ViewController.swift
//  coepiiosdemo
//
//  Created by Rodney Witcher on 3/24/20.
//  Copyright © 2020 coepi. All rights reserved.
//

import UIKit
import CoreBluetooth

class CoEpiViewController: UIViewController, CentralDelegate, PeripheralDelegate {
    func onDiscovered(peripheral: CBPeripheral) {
        
    }
    
    func onCentralContact(_ contact: Contact) {
        
    }
    
    func onPeripheralStateChange(description: String) {
        
    }
    
    func onPeripheralContact(_ contact: Contact) {
        
    }
    

    var coepiCentral: Central!
    var coepiPeripheral: Peripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        coepiCentral = Central(delegate: self)
        coepiPeripheral = Peripheral(delegate: self)
    }
}

