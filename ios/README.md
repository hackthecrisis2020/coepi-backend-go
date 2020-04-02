iOS Development Readme

Outstanding Questions:
1. Why don't iOS Central running in the background to scan and discover an iOS Peripheral also running in the background

A primary use case for the app is to enables app users to enable or disable on-demand or background scanning for other compatible app users nearby using Bluetooth Low Energy (BLE).  The code as of the writing of this is successfully able to achieve the following, for two iOS phones:

    * iOS Central running in the background scanning for and discovering iOS Peripheral running in the foreground
    * iOS Central running in the foreground scanning for and discovering iOS Peripheral running in the background
    * iOS Central running in the foreground scanning for and discovering iOS Peripheral running in the foreground
    
Note that each phone is acting as both a peripheral and a central.  Also, the application has the "Required Background Modes"  set to include both `bluetooth-central` and `bluetooth-peripheral` as described at: https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html.

As an example of a not working case: On device 1, open the app and keep it in the foreground.  It is advertising and scanning.  Then move it to the background.  (Should still be scanning and broadcasting, per Apple docs). Then, On device 2, open the app and keep it in the foreground.  The logs show that device2, scans and discovers the peripheral on device1, multiple times.  To be specific, it calls the function below multiple times in a 5 minute period:
https://github.com/Co-Epi/coepi-backend-go/blob/iosdev/ios/coepiiosdemo/ble/Central.swift#L282
```
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
```

On a slower interval, device2, also acts as a peripheral and we see it respond to a readValue request from device1.
The logs show that device2 is calling the function below:
https://github.com/Co-Epi/coepi-backend-go/blob/iosdev/ios/coepiiosdemo/ble/Peripheral.swift#L96-L108
```
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
```

After this is confirmed, move device2 to the background and after 15mins+, neither of the two above functions get called.

2. MAJOR: How to get Android Centrals to be able to scan and discover iOS Peripherals 
   * (We have a backup solution, but it would be more ideal to have a more direct/precise solution)
