//
//  NetworkingManager.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 30/03/26.
//

import Foundation

enum NetworkingError: LocalizedError {
    case badURLResponse(url: URL)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .badURLResponse(url: let url):
            return "[‼️] Bad response from URL: \(url)"
        case .unknown:
            return "[‼️] Unknown error occured"
        }
    }
}

actor NetworkingManager {}
