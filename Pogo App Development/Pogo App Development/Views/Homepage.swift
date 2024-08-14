//
//  Homepage.swift
//  Pogo App Development
//
//  Created by Ivebens Eliacin  on 8/13/24.
//

import SwiftUI

struct CustomButtonView: View {
    @ObservedObject var bluetoothService = BluetoothService.shared
    
    var body: some View {
        HStack {
            // Main button to connect or disconnect
            Button(action: {
                withAnimation {
                    if self.bluetoothService.peripheralState == .connected {
                        self.bluetoothService.disconnectRobot()
                    } else {
                        self.bluetoothService.connectToRobot()
                    }
                }
            }) {
                HStack {
                    Image(bluetoothService.peripheralState == .connected ? "ConnectedBluetooth" : "bluetooth-signal")
                        .foregroundColor(.white)
                    Text(buttonText)
                        .foregroundColor(.white)
                }
                .padding()
                .background(buttonColor)
                .cornerRadius(10)
            }
            .frame(width: 200, height: 50)
            
            // Conditional button that appears when connected
            if self.bluetoothService.peripheralState == .connected {
                Button(action: {
                    // Action for the new button
                    print("Sending command to robot...")
                }) {
                    Image("AI Essentials Icon Set")
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                .frame(width: 200, height: 50)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: self.bluetoothService.peripheralState)
    }
    
    // Text displayed on the main button based on the connection state
    var buttonText: String {
        switch bluetoothService.peripheralState {
        case .connected:
            return "Connected to Bot"
        case .scanning:
            return "Scanning..."
        case .disconnected:
            return "Please Connect to The Bot"
        case .error:
            return "Connection Error"
        case .connecting:
            return "Connecting..."
            
        }
    }
    
    var buttonColor: Color {
        switch bluetoothService.peripheralState {
        case .connected:
            return Color.blue
        case .scanning:
            return Color.yellow
        case .disconnected:
            return Color.orange
        case .error:
            return Color.red
        case .connecting:
            return Color.green
        }
    }
}

struct Homepage: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Set the background to black
            
            VStack {
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.white)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
                    .offset(y: -UIScreen.main.bounds.height / 4)
                Spacer()
            }
            
            VStack {
                Text("Pogo Bot")
                    .font(.custom("Poppins-Black", size: 25))
                    .foregroundColor(.black)
                    .padding(.top)
                Spacer()
                
                // Placement of the CustomButtonView inside the VStack
                CustomButtonView()
                    .offset(x: -0 ,y: -330)
                    .frame(width: 10000)
            }
        }
    }
}

#Preview {
    Homepage()
}
