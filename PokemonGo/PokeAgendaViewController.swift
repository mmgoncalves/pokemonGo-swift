//
//  PokeAgendaViewController.swift
//  PokemonGo
//
//  Created by Mateus Marques on 30/05/17.
//  Copyright © 2017 Mateus Marques. All rights reserved.
//

import UIKit

class PokeAgendaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pokemonsCapturados: [Pokemon] = []
    var pokemonsNaoCapturados: [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let coreData = CoreDataPokemon()
        
        self.pokemonsCapturados = coreData.recuperarPokemonsCapturados(capturado: true)
        self.pokemonsNaoCapturados = coreData.recuperarPokemonsCapturados(capturado: false)
    }

    @IBAction func voltarMapa(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.pokemonsCapturados.count
        } else {
            return self.pokemonsNaoCapturados.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var pokemon: Pokemon
        
        if indexPath.section == 0 {
            pokemon = self.pokemonsCapturados[indexPath.row]
        } else {
            pokemon = self.pokemonsNaoCapturados[indexPath.row]
        }
        
        let celula = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellPokeAgenda")
        
        celula.textLabel?.text = pokemon.nome
        celula.imageView?.image = UIImage(named: pokemon.nomeImagem!)
        
        return celula
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        } else {
            return "Não Capturados"
        }
    }

}
