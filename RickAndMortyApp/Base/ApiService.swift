//
//  ApiService.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 17/09/25.
//

import Foundation

protocol ApiService {
    func getDataFromGetRequest <Response: Codable>(from url: String) async throws -> Response
    
}

class DefaultApiService: ApiService {
    
    func getDataFromGetRequest<Response: Codable>(from url: String) async throws -> Response {
        guard let url = URL(string: url) else {
            throw AppError.invalidUrl
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    break // Success
                case 408:
                    throw AppError.timeout
                case 500...599:
                    throw AppError.serviceError(error: NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
                default:
                    throw AppError.serviceError(error: NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode)"]))
                }
            }
            
            return try JSONDecoder().decode(Response.self, from: data)
        } catch let error as AppError {
            throw error
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw AppError.networkUnavailable
            case .timedOut:
                throw AppError.timeout
            default:
                throw AppError.serviceError(error: urlError)
            }
        } catch _ as DecodingError {
            throw AppError.parseError
        } catch {
            throw AppError.serviceError(error: error)
        }
    }
}
