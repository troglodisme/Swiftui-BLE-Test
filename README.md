# SwiftUI BLE Test

Learning how to interact with BLE peripherals using SwiftUI and CoreBluetooth

Tested with Adafruit feather esp32 and Arduino BLE led example sketch

https://github.com/arduino-libraries/ArduinoBLE/blob/master/examples/Peripheral/ButtonLED/ButtonLED.ino




# How BLE works

 1. Scan for peripherals and gather advertisement data: The central device (your iOS app) scans for peripherals that are broadcasting advertisement packets (max 31 bytes, only read). It can filter based on data like device name, service UUIDs, RSSI, and manufacturer data to decide whether to connect. 

2. Form a connection with a peripheral: Once a suitable peripheral is found, the central can initiate a connection if needed.  

3. Discover services: After connecting, the central starts service discovery, where it identifies the available services on the peripheral.  

4. Discover characteristics: Once a service of interest is found, the central discovers the characteristics associated with that service, which hold the data or actions.  

5. Read or write characteristic values: The central can then read from or write to characteristics based on the app’s requirements.  

6. Subscribe for notifications (if necessary): Some characteristics can push updates to the central by enabling notifications or indications, which is useful for real-time updates.  

7. Disconnect: Disconnecting when the communication is complete, usually to save power or reset the connection if needed.

# To Do

- [x] 1. Scan for peripherals
- [x] 2. Select and connect to a specific peripheral
- [x] 3. Discover services
- [x] 4. Discover characteristics
- [ ] 5. Display characteristics
- [x] 6. Write boolean value
- [ ] 7. Read values 
- [ ] 8. Subscribe for nofitication
- [x] 9. Disconnect

- [ ] 10. Generalise boolean value (currently fixed to led characteristic)
      

# Resources to explore

https://github.com/StarryInternet/CombineCoreBluetooth

https://learn.adafruit.com/introduction-to-bluetooth-low-energy

https://punchthrough.com/core-bluetooth-basics/

https://www.youtube.com/watch?v=dKUgxZC1y6Q

https://novelbits.io/manage-multiple-ble-peripherals-in-ios-swiftui/

https://medium.com/macoclock/core-bluetooth-ble-swift-d2e7b84ea98e


