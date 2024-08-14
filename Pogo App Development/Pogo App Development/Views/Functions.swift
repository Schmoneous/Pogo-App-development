//
//  Functions.swift
//  Pogo App Development
//
//  Created by Ivebens Eliacin  on 8/13/24.
//


import SwiftUI


struct Functions: View {
    
    @State var bleService = BluetoothService.shared
    
    var body: some View {
        
        VStack{
            Button{
                moveForward()
            } label: {
                VStack{
                    Image(systemName:"arrow.up")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .padding()
                    Text("Move Forward")
                }
            }
            .buttonStyle(.bordered)
            .padding()
            
            
            
            Button{
                moveDown()
            } label: {
                VStack{
                    Image(systemName:"arrow.down")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .padding()
                    Text("Move Forward")
                }
            }
            .buttonStyle(.bordered)
            .padding()
           
            
            Button{
                moveLeft()
            } label: {
                VStack{
                    Image(systemName:"arrow.left")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .padding()
                    Text("Move Forward")
                }
            }
            .buttonStyle(.bordered)
            .padding()
           
            
            
      
        Button{
            moveRight()
        } label: {
            VStack{
                Image(systemName:"arrow.right")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .padding()
                Text("Move Forward")
            }
        }
        .buttonStyle(.bordered)
        .padding()
            
        }
     
}
}

func moveForward(){
    let data = "forward".data(using: .utf8)!
    guard let char = BluetoothService.shared.MovementCharacteristic else{
        print("Could not find Movement Characteristic")
        return
    }
    BluetoothService.shared.POGO_peripheral?.writeValue(data, for: char, type: .withResponse)
}

func moveDown(){
    let data = "down".data(using: .utf8)!
    guard let char = BluetoothService.shared.MovementCharacteristic else{
        print("Could not find Movement Characteristic")
        return
    }
    BluetoothService.shared.POGO_peripheral?.writeValue(data, for: char, type: .withResponse)
}

func moveLeft(){
    let data = "left".data(using: .utf8)!
    guard let char = BluetoothService.shared.MovementCharacteristic else{
        print("Could not find Movement Characteristic")
        return
    }
    BluetoothService.shared.POGO_peripheral?.writeValue(data, for: char, type: .withResponse)
}

func moveRight(){
    let data = "right".data(using: .utf8)!
    guard let char = BluetoothService.shared.MovementCharacteristic else{
        print("Could not find Movement Characteristic")
        return
    }
    BluetoothService.shared.POGO_peripheral?.writeValue(data, for: char, type: .withResponse)
}

#Preview {
    Functions()
}
