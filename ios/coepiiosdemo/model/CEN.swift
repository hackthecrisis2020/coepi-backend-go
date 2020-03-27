/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import CryptoSwift
import RealmSwift

struct CEN : Codable {
    var CEN: String
    var timestamp: Int = Int(Date().timeIntervalSince1970)
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    func generateCEN() -> Data {
        let identifier = UUID()
        let timeIntSince1970 = Date().timeIntervalSince1970
        let thresholdMins: Int = 15
        let thresholdMinsAsSecs:Int = thresholdMins*60

        let currentIntervalTimestamp:Int = (Int(timeIntSince1970)/thresholdMinsAsSecs)*thresholdMinsAsSecs

        var currentIntervalTimestampAsData: Data = String(currentIntervalTimestamp).data(using: .utf8) ?? Data()
        let identifierStringData: Data = identifier.uuidString.data(using: .utf8) ?? Data()

        currentIntervalTimestampAsData.append(identifierStringData)
        return currentIntervalTimestampAsData
    }
    
    static func generateCENData(CENKey : String, currentTs : Int)  -> Data {
        // decode the base64 encoded key
        let decodedCENKey:Data = Data(base64Encoded: CENKey)!
        
        //convert key to [UInt8]
        var decodedCENKeyAsUInt8Array: [UInt8] = []
        decodedCENKey.withUnsafeBytes {
            decodedCENKeyAsUInt8Array.append(contentsOf: $0)
        }
        
        //convert timestamp to [UInt8]
        var tsAsUInt8Array: [UInt8] = []
        [roundedTimestamp(ts: currentTs)].withUnsafeBytes {
            tsAsUInt8Array.append(contentsOf: $0)
        }
        
        //encrypt tsAsUnit8Array using decodedCENKey... using AES
        let encData = try! AES(key: decodedCENKeyAsUInt8Array, blockMode: ECB(), padding: .pkcs5).encrypt(tsAsUInt8Array)
        
        //return Data representation of encodedData
        return NSData(bytes: encData, length: Int(encData.count)) as Data
    }
    
    func insert() {
        let realm = try! Realm()
        let DBCENObject = realm.objects(DBCEN.self).filter("CEN = %@", self.CEN)
        if DBCENObject.count == 0 {
            let newCEN = DBCEN(_cen: self.CEN, _ts: self.timestamp)
            try! realm.write {
                realm.add(newCEN)
            }
        } else {
            print("duplicate entry: skipping")
        }
    }
}
