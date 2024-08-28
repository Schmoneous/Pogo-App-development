//
//  Manual.swift
//  Pogo App Development
//
//  Created by Ivebens Eliacin  on 8/13/24.
//

import SwiftUI
import SwiftUIJoystick

extension JoystickMonitor {
    func sendJoystickPositionViaBluetooth() {
        let bluetoothService = BluetoothService.shared // Directly access the shared instance
        guard let movementCharacteristic = bluetoothService.MovementCharacteristic else {
            print("Could not find Movement Characteristic")
            return
        }

        // Now you can safely use bluetoothService and movementCharacteristic
        let positionString = "XY: (\(xyPoint.x), \(xyPoint.y)), Polar: (degrees: \(polarPoint.degrees), distance: \(polarPoint.distance))"
        let data = positionString.data(using: .utf8)!

        bluetoothService.POGO_peripheral?.writeValue(data, for: movementCharacteristic, type: .withResponse)
    }
}

struct Manual: View {
    
    
    
    
    @State var bleService = BluetoothService.shared
    
    @StateObject private var monitorLocking = JoystickMonitor()
    let widthLocking: CGFloat = 150
    /// For the Custom Joystick example
    @StateObject private var monitorRect = JoystickMonitor()
    let widthRect: CGFloat = 100
    /// For the Custom Joystick example
    @StateObject private var monitorCircle = JoystickMonitor()
    let widthCircle: CGFloat = 130
    
    var body: some View {
        VStack{
                JoystickBuilder(
                    monitor: self.monitorLocking,
                    width: self.widthLocking,
                    shape: .circle,
                    background: {
                        Circle().fill(Color.gray.opacity(0.9))
                                .frame(width: widthLocking, height: widthLocking)
                                    },
                    foreground: {
                        Circle().fill(Color.black)
                                .frame(width: widthLocking / 4, height: widthLocking / 4)
                                },
                    locksInPlace: false)
            Text("Diameter: \(widthLocking)")
            Text("Diameter: \(widthLocking)")
                    Text("XY Point = (x: \(String(format: "%.2f", self.monitorLocking.xyPoint.x)), y: \(String(format: "%.2f", self.monitorLocking.xyPoint.y)))")
                    Text("Polar Point = (radians: \(String(format: "%.2f", self.monitorLocking.polarPoint.degrees)), distance: \(String(format: "%.2f", self.monitorLocking.polarPoint.distance)))")
            
            
          
            }
        }
    }

#Preview {
    Manual()
}
