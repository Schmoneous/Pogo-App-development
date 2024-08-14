//
//  BluetoothService .swift
//  Pogo App Development
//
//  Created by Ivebens Eliacin  on 8/12/24.
//

import Foundation
import CoreBluetooth
import os

@Observable
class BluetoothService: NSObject, ObservableObject{
    
    enum PeripheralState{
        case scanning, disconnected, connected, error, connecting
    }
    
    static let shared = BluetoothService()
    private var centralManager: CBCentralManager!
    
    var peripheralState: PeripheralState = .disconnected
    
    var POGO_peripheral:CBPeripheral?
    var MovementCharacteristic: CBCharacteristic?
    //Add peripheral Status for the the button that is going to be on the homeScreen
    
    private override init(){
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        os_log("CBManager initialized")
        
    }
}

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn{
            os_log("CBManager is powered on")
            scanForPeripherals()
        }else{
            os_log("CBManager is powered off")
        }
    }
    
    func scanForPeripherals(){
        os_log("Scanning for peripherals")
        centralManager.scanForPeripherals(withServices: [CBUUID(string:"76e1e4a5-0767-4713-8c2a-42a5cbeb1085")])
        peripheralState = .scanning
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        os_log("Discovered peripheral: %@", peripheral.name ?? "Unnamed")
        
        if POGO_peripheral == nil{
            self.POGO_peripheral = peripheral
            centralManager.stopScan()
            peripheralState = .connecting
            centralManager.connect(peripheral, options: nil)
        }
    }
       
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
           os_log("Connected to peripheral: %@", peripheral.name ?? "Unnamed")
           peripheralState = .connected
        peripheral.delegate = PeripheralManager.shared
        peripheral.discoverServices([CBUUID(string:"76e1e4a5-0767-4713-8c2a-42a5cbeb1085")])
       }
       
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
           os_log("Disconnected from peripheral: %@", peripheral.name ?? "Unnamed")
           peripheralState = .disconnected
       }
    
    
    func connectToRobot() {
        centralManager?.scanForPeripherals(withServices: [CBUUID(string:"76e1e4a5-0767-4713-8c2a-42a5cbeb1085")], options: nil)
     }

     func disconnectRobot() {
         if let POGO_peripheral = POGO_peripheral {
             centralManager?.cancelPeripheralConnection(POGO_peripheral)
         }
     }

}
