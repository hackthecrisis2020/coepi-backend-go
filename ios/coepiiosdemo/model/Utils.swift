//
//  Utils.swift
//  coepiiosdemo
//
//  Created by Rodney Witcher on 3/26/20.
//  Copyright © 2020 coepi. All rights reserved.
//

import Foundation

let CENKeyLifetimeInSeconds: Int = 2*60 //TODO: revert back to 7*86400
let CENLifetimeInSeconds: Int = 1*60 //TODO: revert back to 15*60

func roundedTimestamp(ts : Int) -> Int {
    return Int(ts / CENKeyLifetimeInSeconds)*CENKeyLifetimeInSeconds
}

func base64ToString(b64: String) -> String {
    let decodedData = Data(base64Encoded: b64)!
    return decodedData.compactMap { String(format: "%02x", $0) }.joined() //String(data: decodedData, encoding: .utf8)!
}
