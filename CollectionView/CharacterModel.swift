//
//  PersonajeModel.swift
//  CollectionView
//
//  Created by dam2 on 18/12/23.
//

import Foundation

struct CharacterModel: Decodable {
    var name: String
    var species: String
    var image: String
    var status: String
    var gender: String
    var origin: Origin
    var location: Location
    var episode: [String]
}
