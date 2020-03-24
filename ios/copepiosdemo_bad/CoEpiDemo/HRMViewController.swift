/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreBluetooth

class HRMViewController: UIViewController, CentralDelegate, PeripheralDelegate {
    
  func onPeripheralStateChange(description: String) {
    
  }
  
  func onPeripheralContact(_ contact: Contact) {
    
  }

  var centralManager: CBCentralManager!
  var coepiCentral: Central!
  var coepiPeripheral: Peripheral!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    coepiCentral = Central(delegate: self)
    coepiPeripheral = Peripheral(delegate: self)
    //centralManager = CBCentralManager(delegate: self, queue: nil)
    
    // Make the digits monospaces to avoid shifting when the numbers change
    
  }

  func onDiscovered(peripheral: CBPeripheral) {
    
  }
  
  func onCentralContact(_ contact: Contact) {
    
  }
  
  func onHeartRateReceived(_ heartRate: Int) {
    //heartRateLabel.text = String(heartRate)
    print("BPM: \(heartRate)")
  }
}

/*
extension HRMViewController: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
      case .unknown:
        print("central.state is .unknown")
      case .resetting:
        print("central.state is .resetting")
      case .unsupported:
        print("central.state is .unsupported")
      case .unauthorized:
        print("central.state is .unauthorized")
      case .poweredOff:
        print("central.state is .poweredOff")
      case .poweredOn:
        print("central.state is .poweredOn")
        let heartRateServiceCBUUID = CBUUID(string: "0x180D")
        let bloodPressureServiceCBUUID = CBUUID(string: "0x1810")
        centralManager.scanForPeripherals(
//          withServices: [CBUUID(string: Uuids.service.uuidString), bloodPressureServiceCBUUID],
          withServices: nil,
          options: [
              CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(booleanLiteral: true)
          ])
      default:
        print("central.state is .default")
        
//        var services = [CBUUID(string: Uuids.service.uuidString)]
//        centralManager.scanForPeripherals(
//          withServices: services,
//          options: [
//              CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(booleanLiteral: true)
//          ])
    }
  }
    
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
    print("discovered something")
    print(peripheral)
  }
}
*/
