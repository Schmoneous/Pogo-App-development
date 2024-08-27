//
//  PeripheralManager.swift
//  Pogo App Development
//
//  Created by Ivebens Eliacin  on 8/13/24.
//

import Foundation
import CoreBluetooth
import os

@Observable
class PeripheralManager:NSObject, CBPeripheralDelegate {
    
    static let shared = PeripheralManager()
    private override init() {
        super.init()
    }
    
    //Looks at all the services within the ESP32
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error:  Error?) {
        for service in peripheral.services ?? []{
            peripheral.discoverCharacteristics(nil, for: service)//provides all the characteristics with in that service
        }
    }
    
    //Looks at all the characteristics with in that services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        for characteristic in service.characteristics ?? []{
            BluetoothService.shared.MovementCharacteristic = characteristic
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        //This is for reading values form the ESP32
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        if let error {
            os_log("error writing to peripheral")
        }else{
            os_log("Command Sent")
        }
    }
}
