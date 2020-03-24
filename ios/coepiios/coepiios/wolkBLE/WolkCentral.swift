//
//  Central.swift
//  coepiios
//
//  Created by Rodney Witcher on 3/23/20.
//  Copyright © 2020 coepi. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import SwiftUI

struct WolkCentral: UIViewControllerRepresentable {
    typealias UIViewControllerType = Central
    
    let controller = Central(delegate: self)

    func makeUIViewController(context: UIViewControllerRepresentableContext<WolkCentral>) -> Central {
        return controller
    }

    func updateUIViewController(_ uiViewController: Central, context: UIViewControllerRepresentableContext<WolkCentral>) {

    }
    
    class Coordinator: NSObject, CentralDelegate {
        var foo: (Data) -> Void
        init(vc: Central, foo: @escaping (Data) -> Void) {
            self.foo = foo
            super.init()
            vc.delegate = self
        }
        func someDelegateFunction(data: Data) {
            foo()
        }
    }
}

//extension WolkCentral: CBCentralManagerDelegate {
//
//}
