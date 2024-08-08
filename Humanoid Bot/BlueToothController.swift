//
//  BlueToothController.swift
//  Humanoid Bot
//
//  Created by Ivebens Eliacin  on 7/30/24.
//

import Foundation
import CoreBluetooth
import UIKit

let temporaryUUID = UUID().uuidString

class BlueToothController: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isConnected = false
    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral?
    let ROBOT_UUID = CBUUID(string: temporaryUUID) // Replace with your robot's UUID
    let ROBOT_NAME = "YourRobotName" // Replace with your robot's name
    
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var receivedDataLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

//    func connectToRobot() {
//        centralManager?.scanForPeripherals(withServices: [ROBOT_UUID], options: nil)
//    }

//    func disconnectRobot() {
//        if let peripheral = peripheral {
//            centralManager?.cancelPeripheralConnection(peripheral)
//        }
//    }
    
    func connectToRobot() {
          // Simulate a connection
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              print("Connecting to Robot...")
              self.isConnected = true
          }
      }

    func disconnectRobot() {
        // Simulate a disconnection
        DispatchQueue.main.async {
            print("Disconnecting Robot...")
            self.isConnected = false
        }
    }
    
    
    
    @IBAction func connectButtonTapped(_ sender: UIButton) {
        // Start scanning for peripherals
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Identify the robot by name or UUID
        if peripheral.name == ROBOT_NAME || peripheral.identifier.uuidString == ROBOT_UUID.uuidString {
            self.peripheral = peripheral
            centralManager?.stopScan()
            centralManager?.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        updateConnectionStatus()
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        updateConnectionStatus()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                // Discover characteristics for each service
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                // Interact with characteristics
                if characteristic.properties.contains(.write) {
                    // Example: Sending data to the robot
                    let message = "Hello Robot"
                    let data = message.data(using: .utf8)
                    peripheral.writeValue(data!, for: characteristic, type: .withResponse)
                }
                if characteristic.properties.contains(.read) || characteristic.properties.contains(.notify) {
                    // Subscribe to notifications for characteristic
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            let receivedMessage = String(data: data, encoding: .utf8)
            // Update UI with received data
            receivedDataLabel.text = receivedMessage
        }
    }
    
    private func updateConnectionStatus() {
        DispatchQueue.main.async {
            if self.isConnected {
                self.statusLabel.text = "Connected to the robot"
                self.connectButton.backgroundColor = UIColor.orange
            } else {
                self.statusLabel.text = "Not connected to the robot"
                self.connectButton.backgroundColor = UIColor.blue
            }
            
        }
    }
}
