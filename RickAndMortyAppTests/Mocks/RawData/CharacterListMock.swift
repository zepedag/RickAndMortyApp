//
//  CharacterListMock.swift
//  RickAndMortyAppTests
//
//  Created by Humberto Alejandro Zepeda González on 17/09/25.
//

import Foundation

class CharacterListFake {
    /// Fake response for "https://rickandmortyapi.com/api/character?page=2" endpoint
    static func makeCharacterListJsonFake() -> Data {
        return Data(CharacterListMockData.page2Response.utf8)
    }

    static func makeCharacterListJsonFakeParseError() -> Data {
        return Data(CharacterListMockData.parseErrorResponse.utf8)
    }
}

class SearchCharacterFake {
    /// Fake response for search endpoint
    static func makeSearchCharacterJsonFake() -> Data {
        return Data(SearchCharacterMockData.searchResponse.utf8)
    }

    static func makeCharacterListJsonFakeParseError() -> Data {
        return Data(SearchCharacterMockData.parseErrorResponse.utf8)
    }
}

// MARK: - Mock Data Constants
private enum CharacterListMockData {
    static let page2Response = """
{
    "info": {
        "count": 826,
        "pages": 42,
        "next": "https://rickandmortyapi.com/api/character?page=3",
        "prev": "https://rickandmortyapi.com/api/character?page=1"
    },
    "results": [
        {
            "id": 21,
            "name": "Aqua Morty",
            "status": "unknown",
            "species": "Humanoid",
            "type": "Fish-Person",
            "gender": "Male",
            "origin": {"name": "unknown", "url": ""},
            "location": {"name": "Citadel of Ricks", "url": "https://rickandmortyapi.com/api/location/3"},
            "image": "https://rickandmortyapi.com/api/character/avatar/21.jpeg",
            "episode": ["https://rickandmortyapi.com/api/episode/10", "https://rickandmortyapi.com/api/episode/22"],
            "url": "https://rickandmortyapi.com/api/character/21",
            "created": "2017-11-04T22:39:48.055Z"
        },
        {
            "id": 22,
            "name": "Aqua Rick",
            "status": "unknown",
            "species": "Humanoid",
            "type": "Fish-Person",
            "gender": "Male",
            "origin": {"name": "unknown", "url": ""},
            "location": {"name": "Citadel of Ricks", "url": "https://rickandmortyapi.com/api/location/3"},
            "image": "https://rickandmortyapi.com/api/character/avatar/22.jpeg",
            "episode": ["https://rickandmortyapi.com/api/episode/10", "https://rickandmortyapi.com/api/episode/22", "https://rickandmortyapi.com/api/episode/28"],
            "url": "https://rickandmortyapi.com/api/character/22",
            "created": "2017-11-04T22:41:07.171Z"
        },
        {
            "id": 23,
            "name": "Arcade Alien",
            "status": "unknown",
            "species": "Alien",
            "type": "",
            "gender": "Male",
            "origin": {"name": "unknown", "url": ""},
            "location": {"name": "Immortality Field Resort", "url": "https://rickandmortyapi.com/api/location/7"},
            "image": "https://rickandmortyapi.com/api/character/avatar/23.jpeg",
            "episode": [
                "https://rickandmortyapi.com/api/episode/13",
                "https://rickandmortyapi.com/api/episode/19",
                "https://rickandmortyapi.com/api/episode/21",
                "https://rickandmortyapi.com/api/episode/25",
                "https://rickandmortyapi.com/api/episode/26"
            ],
            "url": "https://rickandmortyapi.com/api/character/23",
            "created": "2017-11-05T08:43:05.095Z"
        },
        {
            "id": 24,
            "name": "Armagheadon",
            "status": "Alive",
            "species": "Alien",
            "type": "Cromulon",
            "gender": "Male",
            "origin": {"name": "Signus 5 Expanse", "url": "https://rickandmortyapi.com/api/location/22"},
            "location": {"name": "Signus 5 Expanse", "url": "https://rickandmortyapi.com/api/location/22"},
            "image": "https://rickandmortyapi.com/api/character/avatar/24.jpeg",
            "episode": ["https://rickandmortyapi.com/api/episode/16"],
            "url": "https://rickandmortyapi.com/api/character/24",
            "created": "2017-11-05T08:48:30.776Z"
        },
        {
            "id": 25,
            "name": "Armothy",
            "status": "Dead",
            "species": "unknown",
            "type": "Self-aware arm",
            "gender": "Male",
            "origin": {"name": "Post-Apocalyptic Earth", "url": "https://rickandmortyapi.com/api/location/8"},
            "location": {"name": "Post-Apocalyptic Earth", "url": "https://rickandmortyapi.com/api/location/8"},
            "image": "https://rickandmortyapi.com/api/character/avatar/25.jpeg",
            "episode": ["https://rickandmortyapi.com/api/episode/23"],
            "url": "https://rickandmortyapi.com/api/character/25",
            "created": "2017-11-05T08:54:29.343Z"
        }
    ]
}
"""

    static let parseErrorResponse = """
{
    "info": {
        "count": false,
        "pages": 42,
        "next": 34,
        "prev": true
    }
}
"""
}

private enum SearchCharacterMockData {
    static let searchResponse = """
{
    "info": {
        "count": 107,
        "pages": 6,
        "next": "https://rickandmortyapi.com/api/character/?page=2&name=rick",
        "prev": null
    },
    "results": [
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "type": "",
            "gender": "Male",
            "origin": {"name": "Earth (C-137)", "url": "https://rickandmortyapi.com/api/location/1"},
            "location": {"name": "Citadel of Ricks", "url": "https://rickandmortyapi.com/api/location/3"},
            "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            "episode": [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2",
                "https://rickandmortyapi.com/api/episode/3",
                "https://rickandmortyapi.com/api/episode/4",
                "https://rickandmortyapi.com/api/episode/5"
            ],
            "url": "https://rickandmortyapi.com/api/character/1",
            "created": "2017-11-04T18:48:46.250Z"
        },
        {
            "id": 8,
            "name": "Adjudicator Rick",
            "status": "Dead",
            "species": "Human",
            "type": "",
            "gender": "Male",
            "origin": {"name": "unknown", "url": ""},
            "location": {"name": "Citadel of Ricks", "url": "https://rickandmortyapi.com/api/location/3"},
            "image": "https://rickandmortyapi.com/api/character/avatar/8.jpeg",
            "episode": ["https://rickandmortyapi.com/api/episode/28"],
            "url": "https://rickandmortyapi.com/api/character/8",
            "created": "2017-11-04T20:03:34.737Z"
        }
    ]
}
"""

    static let parseErrorResponse = """
{
    "info": {
        "count": false,
        "pages": 42,
        "next": 34,
        "prev": true
    }
}
"""
}