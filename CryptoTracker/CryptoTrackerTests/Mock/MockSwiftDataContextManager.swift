//
//  MockSwiftDataContextManager.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 07/04/26.
//

import Foundation
import SwiftData
@testable import CryptoTracker

final class MockSwiftDataContextManager {
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            container = try ModelContainer(for: Portfolio.self, configurations: configuration)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            debugPrint("Error initializing database container:", error)
        }
    }
}
