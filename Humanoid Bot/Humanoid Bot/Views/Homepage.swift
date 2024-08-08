//
//  Homepage.swift
//  Humanoid Bot
//
//  Created by Ivebens Eliacin  on 8/5/24.
//

import SwiftUI

struct CustomButtonView: View {
    @ObservedObject var bluetoothManager = BlueToothController()
    
    // Dynamic spacing and offset based on the connection status
    var spacing: CGFloat {
        bluetoothManager.isConnected ? -30 : 0  // Adjust this value for more or less space
    }
    
    var offset: CGFloat {
        bluetoothManager.isConnected ? 30: 0 // Adjust this value to move buttons left or right together
    }
    
    var body: some View {
        HStack(spacing: spacing) {  // Use dynamic spacing here
            // Main button to connect or disconnect
            Button(action: {
                withAnimation {
                    if self.bluetoothManager.isConnected {
                        self.bluetoothManager.disconnectRobot()
                    } else {
                        self.bluetoothManager.connectToRobot()
                    }
                }
            }) {
                HStack {
                    Image(self.bluetoothManager.isConnected ? "ConnectedBluetooth" : "bluetooth-signal")
                        .foregroundColor(.white)
                    Text(self.bluetoothManager.isConnected ? "Connected to Bot" : "Please Connect to The Bot")
                        .foregroundColor(.white)
                }
                .padding()
                .background(self.bluetoothManager.isConnected ? Color.blue : Color.orange)
                .cornerRadius(10)
            }
            .frame(width: 200, height: 50)

            // Conditional button that appears when connected
            if self.bluetoothManager.isConnected {
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
        .offset(x: offset)  // Apply the same offset to the whole HStack
        .animation(.easeInOut(duration: 0.5), value: self.bluetoothManager.isConnected)
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
