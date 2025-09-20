//
//  CharacterListMock.swift
//  RickAndMortyAppTests
//
//  Created by Humberto Alejandro Zepeda González on 17/09/25.
//

import Foundation

// MARK: - Character List Mock Data
class CharacterListFake {
    /// Fake response for character list endpoint
    static func makeCharacterListJsonFake() -> Data {
        return CharacterListMockData.characterListData
    }

    static func makeCharacterListJsonFakeParseError() -> Data {
        return CharacterListMockData.parseErrorData
    }
}

// MARK: - Search Character Mock Data
class SearchCharacterFake {
    /// Fake response for search character endpoint
    static func makeSearchCharacterJsonFake() -> Data {
        return SearchCharacterMockData.searchCharacterData
    }

    static func makeCharacterListJsonFakeParseError() -> Data {
        return SearchCharacterMockData.parseErrorData
    }
}