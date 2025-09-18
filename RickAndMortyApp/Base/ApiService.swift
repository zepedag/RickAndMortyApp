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
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            // If decoding fails, throw a parse error
            if (error as? DecodingError) != nil {
                throw AppError.parseError
            }
            // Else throw the original service error
            throw AppError.serviceError(error: error)
        }
    }
}
