//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 25/03/26.
//

import SwiftUI
import SwiftData

@main
struct CryptoTrackerApp: App {
    
    @StateObject private var viewModel = HomeViewModel(
        with: PortfolioDataService(
            container: SwiftDataContextManager.shared.container,
            context: SwiftDataContextManager.shared.context
        )
    )
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(viewModel)
        }
    }
}
