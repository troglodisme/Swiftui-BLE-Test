//
//  BLEDevicesView.swift
//  Swiftui-BLE-Test
//
//  Created by Giulio on 08/11/24.
//

import SwiftUI

struct BLEDevicesView: View {
    @StateObject var bleManager = BLEManager()
    @State private var selectedPeripheral: Peripheral?
    @State private var isSheetPresented = false // New state variable
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("BLE Scanner")
                Spacer()
                if bleManager.isSwitchedOn {
                    Text("Bluetooth is on")
                        .foregroundColor(.green)
                } else {
                    Text("Bluetooth is off, switch it on!")
                        .foregroundColor(.red)
                }
            }
            .padding()
            
//            List {
//                    Section {
//                        Text("First")
//                        Text("Second")
//                        Text("Third")
//                    } header: {
//                        Text("First Section Header")
//                    } footer: {
//                        Text("Eos est eos consequatur nemo autem in qui rerum cumque consequatur natus corrupti quaerat et libero tempora.")
//                    }
//                    
//  
//                }
//                .listStyle(.grouped)
            
            List(bleManager.peripherals) { peripheral in
                
                HStack {
                    Text(peripheral.name)
                    Spacer()
                    Text(String(peripheral.rssi))
                    Button(action: {
                        bleManager.stopScanning() // Stop scanning on selection
                        bleManager.connect(to: peripheral)
                        selectedPeripheral = peripheral
                        isSheetPresented = true // Present the sheet
                    }) {
                        if bleManager.connectedPeripheralUUID == peripheral.id {
                            Text("Connected")
                                .foregroundColor(.green)
                        } else {
                            Text("Connect")
                        }
                    }
                }
            }

            .sheet(isPresented: $isSheetPresented, onDismiss: {
                selectedPeripheral = nil // Reset the selected peripheral
            }) {
                if let peripheral = selectedPeripheral {
                    AdvertisementDataView(peripheral: peripheral, bleManager: bleManager)
                }
            }
            
        }
        .onAppear {
            if bleManager.isSwitchedOn {
                bleManager.startScanning()
            }
        }
    }
}

#Preview {
    BLEDevicesView()
}



struct AdvertisementDataView: View {
    let peripheral: Peripheral
    @ObservedObject var bleManager: BLEManager
    @Environment(\.presentationMode) var presentationMode
    @State private var ledState: Bool = false // Track the LED state locally
    
    var body: some View {
        NavigationView {
            List {
                ForEach(peripheral.advertisementData.keys.sorted(), id: \.self) { key in
                    if let value = peripheral.advertisementData[key] {
                        HStack {
                            Text(key)
                            Spacer()
                            Text("\(value)")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.vertical, 5)
                    }
                }
                // LED Control Toggle
                Toggle(isOn: $ledState) {
                    Text("Write Boolean")
                }
                .onChange(of: ledState) { value in
                    bleManager.toggleLED(on: value) // Control LED of connected peripheral
                }
                
            }
            .navigationTitle(peripheral.name)
            .navigationBarItems(trailing: Button("Disconnect") {
                bleManager.disconnect() // Disconnect the peripheral
                presentationMode.wrappedValue.dismiss() // Close the sheet
            })
        }
    }
}
