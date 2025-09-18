//
//  ApiService.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 17/09/25.
//

import Foundation

protocol ApíService {
    func getDataFromGetRequest <Response: Codable>(from url: String) async throws -> Response
    
}

class DefaultApiService: ApiService {
    
    func getDataFromGetRequest<Response: Codable>(from url: String) async throws -> Response {
        guard let url = URL(string: url) else {
            
        }
        
    }
}
