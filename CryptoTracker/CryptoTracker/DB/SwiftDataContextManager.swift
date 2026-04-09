//
//  SwiftDataContextManager.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 06/04/26.
//

import Foundation
import SwiftData

final class SwiftDataContextManager {

    static let shared = SwiftDataContextManager()
    
    var container: ModelContainer?
    var context : ModelContext?
    
    private init() {
        do {
            container = try ModelContainer(for: Portfolio.self)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            debugPrint("Error initializing database container:", error)
        }
    }
}
