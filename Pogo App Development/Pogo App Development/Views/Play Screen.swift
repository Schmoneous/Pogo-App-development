//
//  Play Screen.swift
//  Pogo App Development
//
//  Created by Ivebens Eliacin  on 8/13/24.
//


import SwiftUI

struct SquareButton<Destination: View>: View {
    let destination: Destination
    let imageName: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 150, height: 150) // Adjust the size as needed
                    .overlay(
                        Image(systemName: imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                    )
                    .foregroundColor(.customBlack)
                    .padding(.horizontal)
            }
        }
    }
}

import SwiftUI

struct Play_Screen: View {
    @State var  isTabViewVisiable: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 20) { // Add spacing between buttons
                        Spacer()
                        
                        // First Button
                        VStack {
                            SquareButton(destination: Manual(), imageName: "gamecontroller.fill")
                            
                            Text("Controller")
                                .foregroundColor(.white)
                                .font(.custom("Poppin-Black", size: 25))
                        }
                        
                        // Second Button
                        VStack {
                            SquareButton(destination: Functions(), imageName: "gearshape.fill")
                            
                            Text("Functions")
                                .foregroundColor(.white)
                                .font(.custom("Poppin-Black", size: 25))
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationBarTitle("Interaction Page")
            
        }
    }
}

#Preview {
    Play_Screen()
}
