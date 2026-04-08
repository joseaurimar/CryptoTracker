//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 08/04/26.
//

import SwiftUI

final class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
