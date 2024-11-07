//  ContentView.swift
//  Swiftui-BLE-Test
//  Created by Giulio on 07/11/24.

import Foundation
import SwiftUI
import CoreBluetooth // Import CoreBluetooth framework for Bluetooth functionalities

struct ContentView: View {
    
    var body: some View {
        BluetoothDevicesView()
    }
}

struct BluetoothDevicesView: View {
    @StateObject var bleManager = BLEManager()
    @State private var selectedPeripheral: Peripheral?

    var body: some View {
        VStack(spacing: 10) {
            Text("Bluetooth Devices")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
            
            List(bleManager.peripherals) { peripheral in
                HStack {
                    Text(peripheral.name)
                    Spacer()
                    Text(String(peripheral.rssi))
                    Button(action: {
                        bleManager.connect(to: peripheral)
                        selectedPeripheral = peripheral // Set the selected peripheral
                    }) {
                        if bleManager.connectedPeripheralUUID == peripheral.id {
                            Text("Connected")
                                .foregroundColor(.green)
                        } else {
                            Text("Connect")
                        }
                    }
                    .sheet(item: $selectedPeripheral) { peripheral in
                        AdvertisementDataView(peripheral: peripheral)
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height / 2)
            
            Spacer()
            
            Text("Status")
                .font(.headline)
            
            if bleManager.isSwitchedOn {
                Text("Bluetooth is switched on")
                    .foregroundColor(.green)
            } else {
                Text("Bluetooth is not switched on")
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            VStack(spacing: 25) {
                Button(action: {
                    if bleManager.isScanning {
                        bleManager.stopScanning()
                    } else {
                        bleManager.startScanning()
                    }
                }) {
                    Text(bleManager.isScanning ? "Stop Scanning" : "Start Scanning")
                }
            }
            .padding()
            
            Spacer()
        }
        .onAppear() {
            if bleManager.isSwitchedOn {
                bleManager.startScanning()
            }
        }
    }
}

#Preview {
    BluetoothDevicesView()
}



struct AdvertisementDataView: View {
    let peripheral: Peripheral
    @Environment(\.presentationMode) var presentationMode

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
            }
            .navigationTitle(peripheral.name)
            .navigationBarItems(trailing: Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
