//
//  MockBluetoothManager.swift
//  Humanoid Bot
//
//  Created by Ivebens Eliacin  on 7/30/24.
//
import Foundation
import CoreBluetooth
import SwiftUI

class MockBluetoothManager: NSObject, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!
    var isConnected = false

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // Simulate a successful connection
            simulateConnection()
        }
    }

    func simulateConnection() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulate a delay in connection
            print("Simulating Bluetooth Device Connection...")
            self.isConnected = true
            // Trigger any actions that should occur on connection
        }
    }

    func disconnect() {
        DispatchQueue.main.async {
            print("Simulating Bluetooth Device Disconnection...")
            self.isConnected = false
            // Handle disconnection
        }
    }
}

class BluetoothDeviceController {
    var bluetoothManager: MockBluetoothManager

    init() {
        bluetoothManager = MockBluetoothManager()
    }

    func connectToDevice() {
        if bluetoothManager.isConnected {
            print("Already connected to the device.")
        } else {
            bluetoothManager.simulateConnection()
        }
    }

    func disconnectFromDevice() {
        bluetoothManager.disconnect()
    }
}

class ObservableBluetoothDeviceController: ObservableObject {
    @Published var bluetoothManager: MockBluetoothManager
    
    init() {
        bluetoothManager = MockBluetoothManager()
    }

    func connectToDevice() {
        bluetoothManager.simulateConnection()
    }

    func disconnectFromDevice() {
        bluetoothManager.disconnect()
    }
}

struct BluetoothConnectionView: View {
    @ObservedObject var deviceController: ObservableBluetoothDeviceController
    
    var body: some View {
        VStack(spacing: 20) {
            Text(deviceController.bluetoothManager.isConnected ? "Connected" : "Disconnected")
                .foregroundColor(deviceController.bluetoothManager.isConnected ? .green : .red)
                .font(.title)
            
            Button(action: {
                if self.deviceController.bluetoothManager.isConnected {
                    self.deviceController.disconnectFromDevice()
                } else {
                    self.deviceController.connectToDevice()
                }
            }) {
                Text(deviceController.bluetoothManager.isConnected ? "Disconnect" : "Connect")
                    .foregroundColor(.white)
                    .padding()
                    .background(deviceController.bluetoothManager.isConnected ? Color.red : Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct BluetoothConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothConnectionView(deviceController: ObservableBluetoothDeviceController())
    }
}
