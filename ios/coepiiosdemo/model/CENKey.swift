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
import CryptoKit
import RealmSwift
import Security

struct CENKey : Codable {
    var timestamp: Int = Int(Date().timeIntervalSince1970)
    var cenKey: String?
    
    //static var cenKey: String = ""
    static var cenKeyTimestamp: Int = 0
    
    static func generateAndStoreCENKey() -> CENKey {
        //Retrieve last cenKey and cenKeyTimestamp from CENKey
        let latestCENKey = getLatestCENKey()
        let curTimestamp = Int(Date().timeIntervalSince1970)
        if ( ( cenKeyTimestamp == 0 ) || ( roundedTimestamp(ts: curTimestamp) > roundedTimestamp(ts: cenKeyTimestamp) ) ) {
            //generate a new AES Key and store it in local storage
            
            //generate base64string representation of key
            let cenKeyString = computeSymmetricKey()
            print("generated symkey: \(cenKeyString)")
            let cenKeyTimestamp = curTimestamp
            
            //Create CENKey and insert/save to Realm
            let newCENKey = CENKey(timestamp: cenKeyTimestamp, cenKey: cenKeyString)
            newCENKey.insert()
            return newCENKey
        } else {
            print("timestamps not different enough to generate new key currentTS \(curTimestamp) cenKeyTimestamp \(cenKeyTimestamp)")
            return latestCENKey!
        }
    }

    static func computeSymmetricKey() -> String? {
        var keyData = Data(count: 32) // 32 bytes === 256 bits
        let keyDataCount = keyData.count
        let result = keyData.withUnsafeMutableBytes {
            (mutableBytes: UnsafeMutablePointer) -> Int32 in
            SecRandomCopyBytes(kSecRandomDefault, keyDataCount, mutableBytes)
        }
        if result == errSecSuccess {
            return keyData.base64EncodedString()
        } else {
            return nil
        }
    }
    
    static func getLatestCENKey() -> CENKey? {
        let realm = try! Realm()
        let cenKeysObject = realm.objects(DBCENKey.self).sorted(byKeyPath: "timestamp", ascending: false)
        if cenKeysObject.count == 0 {
            return nil
        } else {
            self.cenKeyTimestamp = cenKeysObject[0].timestamp
            return CENKey(timestamp: self.cenKeyTimestamp, cenKey: cenKeysObject[0].CENKey)
        }
    }
    
    func insert() {
        let realm = try! Realm()
        let sameObject = realm.objects(DBCENKey.self).filter("timestamp = %@", self.timestamp)
        if sameObject.count > 0 {
            print("Duplicate Entry: NOT inserting CENKey( ts: \(self.timestamp) , cenKey: \(String(describing: self.cenKey))")
        } else {
            let newCENKey = DBCENKey(_ts: self.timestamp, _cenKey: self.cenKey!)
            try! realm.write {
                realm.add(newCENKey)
            }
        }
    }
}
