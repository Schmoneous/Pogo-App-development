//
//  CustomTabView.swift
//  Humanoid Bot
//
//  Created by Ivebens Eliacin  on 8/6/24.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabBarItems: [(image: String, title: String, font: Font)] = [
          ("gamecontroller", "Interaction", .custom("Poppins-Black", size: 12)),
          ("house.fill", "Bot Page", .custom("Poppins-Black", size: 12)),
          ("person.crop.circle.fill", "Profile", .custom("Poppins-Black", size: 12))
      ]
    
    var body: some View {
        ZStack {
                   RoundedRectangle(cornerRadius: 25.0)
                       .frame(width: 380, height: 80)
                       .foregroundColor(Color(hex: "1A1B1D"))
                       .shadow(radius: 2)
                   
                   HStack {
                       ForEach(0..<tabBarItems.count, id: \.self) { index in
                           Button {
                               tabSelection = index + 1
                           } label: {
                               VStack(spacing: 8) {
                                   Spacer()
                                   
                                   Image(systemName: tabBarItems[index].image)
                                   
                                   Text(tabBarItems[index].title)
                                       .font(tabBarItems[index].font)
                                   
                                   if index + 1 == tabSelection {
                                       RoundedRectangle(cornerRadius: 25.0)
                                           .frame(height: 8)
                                           .foregroundColor(.blue)
                                           .matchedGeometryEffect(id: "SelectedTab", in: animationNamespace)
                                           .offset(y: 3)
                                   } else {
                                       RoundedRectangle(cornerRadius: 25.0)
                                           .frame(height: 8)
                                           .foregroundColor(.clear)
                                           .offset(y: 3)
                                   }
                               }
                               .foregroundColor(index + 1 == tabSelection ? .blue : .gray)
                               .accessibility(label: Text(tabBarItems[index].title))
                           }
                       }
                   }
                   .frame(height: 80)
                   .clipShape(RoundedRectangle(cornerRadius: 25.0))
               }
               .padding(.horizontal)
           }
}

#Preview {
    CustomTabView(tabSelection: .constant(1))
        .previewLayout(.sizeThatFits)
}
