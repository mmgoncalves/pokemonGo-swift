//
//  CoreDataPokemon.swift
//  PokemonGo
//
//  Created by Mateus Marques on 29/05/17.
//  Copyright © 2017 Mateus Marques. All rights reserved.
//

import UIKit
import CoreData

class CoreDataPokemon {
    // recuperar o context
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        return context!
    }
    
    // adicionar todos os polemons
    func adicionarTodosPokemons() {
        let context = self.getContext()
        self.criarPokemon(nome: "Mew", nomeImagem: "mew", capturado: false)
        self.criarPokemon(nome: "Meowth", nomeImagem: "meowth", capturado: false)
        
        do {
            try context.save()
        } catch {
            
        }
    }
    
    // criar todos os pokemons
    func criarPokemon(nome: String, nomeImagem: String, capturado: Bool) {
        let context = getContext()
        let pokemon = Pokemon(context: context)
        
        pokemon.nome = nome
        pokemon.nomeImagem = nomeImagem
        pokemon.capturado = capturado
    }
    
    func recuperarTodosPokemons() -> [Pokemon] {
        let context = self.getContext()
        
        do {
            var pokemons = try context.fetch( Pokemon.fetchRequest() ) as! [Pokemon]
            
            if pokemons.count == 0 {
                self.adicionarTodosPokemons()
                pokemons = self.recuperarTodosPokemons()
            }
            
            return pokemons
        }catch {
            
        }
        
        return []
    }
}
