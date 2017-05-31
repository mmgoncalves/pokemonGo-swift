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
        self.criarPokemon(nome: "Abra",         nomeImagem: "abra",         capturado: false)
        self.criarPokemon(nome: "Bellspout",    nomeImagem: "bellsprout",   capturado: false)
        self.criarPokemon(nome: "Bullbasaur",   nomeImagem: "bullbasaur",   capturado: false)
        self.criarPokemon(nome: "Caterpie",     nomeImagem: "caterpie",     capturado: false)
        self.criarPokemon(nome: "Charmander",   nomeImagem: "charmander",   capturado: false)
        self.criarPokemon(nome: "Dratini",      nomeImagem: "dratini",      capturado: false)
        self.criarPokemon(nome: "Eevee",        nomeImagem: "eevee",        capturado: false)
        self.criarPokemon(nome: "Mankey",       nomeImagem: "mankey",       capturado: false)
        self.criarPokemon(nome: "Meowth",       nomeImagem: "meowth",       capturado: false)
        self.criarPokemon(nome: "Pidgey",       nomeImagem: "pidgey",       capturado: false)
        self.criarPokemon(nome: "Pikachu",      nomeImagem: "pikachu-2",    capturado: false)
        self.criarPokemon(nome: "Psyduck",      nomeImagem: "psyduck",      capturado: false)
        self.criarPokemon(nome: "Rattata",      nomeImagem: "rattata",      capturado: false)
        self.criarPokemon(nome: "Snorlax",      nomeImagem: "snorlax",      capturado: false)
        self.criarPokemon(nome: "Squirtle",     nomeImagem: "squirtle",     capturado: false)
        self.criarPokemon(nome: "Venonat",      nomeImagem: "venonat",      capturado: false)
        self.criarPokemon(nome: "Weedle",       nomeImagem: "weedle",       capturado: false)
        self.criarPokemon(nome: "Zubat",        nomeImagem: "zubat",        capturado: false)
        
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
    
    func recuperarPokemonsCapturados(capturado: Bool) -> [Pokemon] {
        let context = self.getContext()
        
        let requisicao = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        requisicao.predicate = NSPredicate(format: "capturado = %@", capturado as CVarArg)
        
        do {
            let pokemons = try context.fetch(requisicao) as [Pokemon]
            
            return pokemons
        }catch {
            
        }
        
        return []
    }
    
    func salvarPokemon(pokemon: Pokemon) {
        let context = self.getContext()
        
        pokemon.capturado = true
        
        do {
            try context.save()
        } catch{}
    }
}
