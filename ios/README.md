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

Then if either device moves their app back to the foreground, the logs show that each of the functions referenced above get called almost immediately.

2. MAJOR: How to get Android Centrals to be able to scan and discover iOS Peripherals when iOS device is in background
   * iOS devices advertise UUIDs through the value of CBAdvertisementDataServiceUUIDsKey, when in the foreground, however, in the background, they are placed in a special “overflow” area and according to Apple's docs, they can be discovered only by an iOS device that is explicitly scanning for them. (https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html)
   
   Is there any suggested workaround for enabling Android devices to scan for iOS devices when the iOS device is in the background?
   
   The following log line:
   ```
   https://github.com/Co-Epi/app-android/blob/develop/app/src/main/java/org/coepi/android/ble/covidwatch/BLEScanner.kt#L50
   ```
   Returns results that reflect an iOS device when the Android device is in the foreground or background and the iOS device is in the foreground, but as soon as the iOS device is moved to the backgroud, the results are empty ([]).
