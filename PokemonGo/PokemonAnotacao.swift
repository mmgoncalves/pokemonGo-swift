//
//  PokemonAnotacao.swift
//  PokemonGo
//
//  Created by Mateus Marques on 29/05/17.
//  Copyright © 2017 Mateus Marques. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnotacao: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon!
    
    init(coordenadas: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordenadas
        self.pokemon = pokemon
    }
}
