//
//  ViewController.swift
//  PokemonGo
//
//  Created by Mateus Marques on 28/05/17.
//  Copyright © 2017 Mateus Marques. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    var gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        // recuperar pokemons
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.recuperarTodosPokemons()
        
        //exibir pokemons
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let cordenadas = self.gerenciadorLocalizacao.location?.coordinate {
                
                let pokemonInficeAleatorio = arc4random_uniform(UInt32(self.pokemons.count))
                let pokemon = self.pokemons[Int(pokemonInficeAleatorio)]
                
                let anotacao = PokemonAnotacao(coordenadas: cordenadas, pokemon: pokemon)
                
                let latAleatoria = (Double(arc4random_uniform(400)) - 200 ) / 100000.0
                let longAleatoria = (Double(arc4random_uniform(400)) - 200 ) / 100000.0
                
                anotacao.coordinate = cordenadas
                
                anotacao.coordinate.latitude += latAleatoria
                anotacao.coordinate.longitude += longAleatoria
                
                self.mapa.addAnnotation(anotacao)
            }
            
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if contador < 3 {
            centralizar()
            contador += 1
        } else {
            gerenciadorLocalizacao.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse && status != .notDetermined {
            let alertController = UIAlertController(title: "Permissão de localização", message: "Para você caçar pokemons precisamos da sua localização", preferredStyle: .alert)
            
            let acaoConfiguracao = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (alertaConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL, options: [:], completionHandler: nil)
                }
            })
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(acaoConfiguracao)
            alertController.addAction(acaoCancelar)
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func centralizar() {
        if let coodenadas = gerenciadorLocalizacao.location?.coordinate {
            let regiao = MKCoordinateRegionMakeWithDistance(coodenadas, 200, 200)
            mapa.setRegion(regiao, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func centralizarJogador(_ sender: Any) {
        centralizar()
    }

    @IBAction func abrirPokedex(_ sender: Any) {
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            anotacaoView.image = #imageLiteral(resourceName: "player")
        } else {
            let pokemon = (annotation as! PokemonAnotacao).pokemon
            
            anotacaoView.image = UIImage.init(named: (pokemon?.nomeImagem)!)
        }
        
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        anotacaoView.frame = frame
        
        return anotacaoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let anotacao = view.annotation
        let pokemon = (anotacao as! PokemonAnotacao).pokemon!
        
        mapView.deselectAnnotation(anotacao, animated: true)
        
        if anotacao is MKUserLocation {
            return
        }
        
        if let coordAnotacao = anotacao?.coordinate {
            let regiao = MKCoordinateRegionMakeWithDistance(coordAnotacao, 200, 200)
            mapa.setRegion(regiao, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.gerenciadorLocalizacao.location?.coordinate {
                if MKMapRectContainsPoint(self.mapa.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    self.coreDataPokemon.salvarPokemon(pokemon: pokemon)
                    self.mapa.removeAnnotation(anotacao!)
                    
                    let alertController = UIAlertController(title: "Parabéns!!!", message: "Você capturou o pokemón: \(pokemon.nome!)", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(ok)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Você não pode capturar", message: "Você precisa se aproximar mais para capturar o \(pokemon.nome!)", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(ok)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

