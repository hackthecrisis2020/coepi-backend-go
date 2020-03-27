//
//  Utils.swift
//  coepiiosdemo
//
//  Created by Rodney Witcher on 3/26/20.
//  Copyright © 2020 coepi. All rights reserved.
//

import Foundation

let CENKeyLifetimeInSeconds: Int = 7*86400
let CENLifetimeInSeconds: Int = 1*60 //TODO: revert back to 15*60

func roundedTimestamp(ts : Int) -> Int {
    let epoch = ts / CENKeyLifetimeInSeconds
    return epoch * CENKeyLifetimeInSeconds
}
