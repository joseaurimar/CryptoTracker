//
//  UIApplication+Extension.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 01/04/26.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
