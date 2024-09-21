//
//  Manual.swift
//  Pogo App Development
//
//  Created by Ivebens Eliacin  on 8/13/24.
//

import SwiftUI
import SwiftUIJoystick
import Combine

class JoystickManager: ObservableObject {
    @Published var monitorLocking = SwiftUIJoystick.JoystickMonitor()
    @Published var positionString: String = ""  // Store the string that will be sent to the ESP32
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        monitorLocking.$xyPoint
            .sink { [weak self] _ in
                self?.updateAndSendJoystickPosition()
            }
            .store(in: &cancellables)
        
        monitorLocking.$polarPoint
            .sink { [weak self] _ in
                self?.updateAndSendJoystickPosition()
            }
            .store(in: &cancellables)
    }
    
    private func updateAndSendJoystickPosition() {
        let bluetoothService = BluetoothService.shared
        guard let movementCharacteristic = bluetoothService.MovementCharacteristic else {
            print("Could not find Movement Characteristic")
            return
        }

        // Update the position string with the latest joystick data
        positionString = "XY: (\(self.monitorLocking.xyPoint.x), \(self.monitorLocking.xyPoint.y)), Polar: (degrees: \(self.monitorLocking.polarPoint.degrees), distance: \(self.monitorLocking.polarPoint.distance))"
        
        // Convert the position string to data and send it via Bluetooth
        let data = positionString.data(using: .utf8)!
        bluetoothService.POGO_peripheral?.writeValue(data, for: movementCharacteristic, type: .withResponse)
    }
}

struct Manual: View {
    @StateObject private var joystickManager = JoystickManager()
    let widthLocking: CGFloat = 150
    
    var body: some View {
        VStack {
            JoystickBuilder(
                monitor: joystickManager.monitorLocking,
                width: widthLocking,
                shape: .circle,
                background: {
                    Circle().fill(Color.gray.opacity(0.9))
                        .frame(width: widthLocking, height: widthLocking)
                },
                foreground: {
                    Circle().fill(Color.black)
                        .frame(width: widthLocking / 4, height: widthLocking / 4)
                },
                locksInPlace: false
            )
            Text("Diameter: \(widthLocking)")
            Text(joystickManager.positionString)
                .padding(.top, 0.0) // Display the same text that is being sent to the ESP32
        }
    }
}

#Preview {
    Manual()
}
