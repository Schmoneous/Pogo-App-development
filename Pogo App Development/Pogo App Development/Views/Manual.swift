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
    @Published var positionString: String = ""  // Display the current joystick position
    private var cancellables = Set<AnyCancellable>()
    
    // Track the last direction sent to the ESP32
    private var currentDirection : JoystickDirection = .neutral
    private var isTouching: Bool = false // Manually track touch state
    
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
        let direction = determineDirection(from: monitorLocking.xyPoint)
        
        // Check if the joystick is being touched (moved away from neutral)
        if monitorLocking.xyPoint != CGPoint(x: 0.5, y: 0.5) {
            isTouching = true
        } else {
            // If it has returned to the neutral position, treat it as not being touched
            if isTouching {
                isTouching = false
                resetJoystickToNeutral()
            }
            return // Skip sending if already neutral
        }
        
        // Send data only if the direction has changed
        if direction != currentDirection {
            sendDirectionToESP32(direction)
            currentDirection = direction // Update the last sent direction
        }
        
        // Update the position string for the UI
        positionString = "XY: (\(self.monitorLocking.xyPoint.x), \(self.monitorLocking.xyPoint.y)), Direction: \(direction.rawValue)"
    }
    
    private func determineDirection(from point: CGPoint) -> JoystickDirection {
        let x = point.x // x ranges from 0 to 1
        let y = point.y // y ranges from 0 to 1
        
        // Check if joystick is in the neutral position (close to the center)
        if x == 0.0 && y == 0.0 {
            return .neutral
        }

        // Determine direction based on positive-only coordinates
        if y > 0.0 && y > x { // Front (upper half of the circle)
            return .front
        } else if y < 0.0 && y < x { // Back (lower half of the circle)
            return .back
        } else if x > 0.0 && x > y { // Right half
            return .right
        } else if x < 0.0 && x < y { // Left half
            return .left
        } else {
            return .error // Optional error state for any unexpected cases
        }
    }
    
    private func sendDirectionToESP32(_ direction: JoystickDirection) {
        let bluetoothService = BluetoothService.shared
        guard let movementCharacteristic = bluetoothService.MovementCharacteristic else {
            print("Could not find Movement Characteristic")
            return
        }

        // Convert the direction to data and send it to the ESP32
        let data = direction.rawValue.data(using: .utf8)!
        bluetoothService.POGO_peripheral?.writeValue(data, for: movementCharacteristic, type: .withResponse)
    }
    
    private func resetJoystickToNeutral() {
        // Reset the joystick to the neutral position
        currentDirection = .neutral
        positionString = "Neutral"
        
        // Send the neutral state to the ESP32
        sendDirectionToESP32(.neutral)
        currentDirection = .neutral // Update last sent direction
    }
}
enum JoystickDirection: String {
    case front = "Front"
    case back = "Back"
    case left = "Left"
    case right = "Right"
    case neutral = "Neutral"
    case error = "Error"// Ensure 'neutral' state is always handled
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
