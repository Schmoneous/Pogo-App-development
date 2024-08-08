//
//  CustomButton.swift
//  Humanoid Bot
//
//  Created by Ivebens Eliacin  on 7/30/24.
//

import Foundation
import UIKit
import SwiftUI



class CustomButton: UIButton {
    
    // Initialize with default properties
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    // Function to set up the button's initial properties
    private func setupButton() {
        setTitleColor(.white, for: .normal)
        backgroundColor = .blue
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    // Function to update the button's appearance based on a condition
    func updateAppearance(condition: Bool) {
        backgroundColor = condition ? .orange : .blue
    }
}
