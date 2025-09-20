//
//  AppError.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 17/09/25.
//

import Foundation

enum AppError: Error {
    case serviceError(error: Error)
    case invalidUrl
    case missingData
    case unExpectedError
    case parseError
    case networkUnavailable
    case timeout
}

extension AppError {
    var errorDescription: String? {
        switch self {
        case .serviceError(let error):
            return NSLocalizedString("\(error.localizedDescription)", comment: "Service error")
        case .invalidUrl:
            return NSLocalizedString("Invalid URL", comment: "Invalid url error")
        case .missingData:
            return NSLocalizedString("Missing data", comment: "Missing data error")
        case .unExpectedError:
            return NSLocalizedString("An unexpected error occurred. Please try again later.", comment: "Unexpected error")
        case .parseError:
            return NSLocalizedString("Data parsing error", comment: "Parse error")
        case .networkUnavailable:
            return NSLocalizedString("No internet connection. Please check your network settings.", comment: "Network unavailable")
        case .timeout:
            return NSLocalizedString("Request timed out. Please try again.", comment: "Timeout error")
        }
    }

    var icon: String {
        switch self {
        case .networkUnavailable:
            return "wifi.slash"
        case .timeout:
            return "clock"
        case .serviceError:
            return "exclamationmark.triangle"
        case .parseError:
            return "doc.text.magnifyingglass"
        case .invalidUrl:
            return "link"
        case .missingData:
            return "tray"
        case .unExpectedError:
            return "questionmark.circle"
        }
    }
}
