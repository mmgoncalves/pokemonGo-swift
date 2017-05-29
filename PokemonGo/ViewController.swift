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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        //exibir pokemons
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            
            if let cordenadas = self.gerenciadorLocalizacao.location?.coordinate {
                let anotacao = MKPointAnnotation()
                
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
            anotacaoView.image = #imageLiteral(resourceName: "pikachu-2")  
        }
        
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        anotacaoView.frame = frame
        
        return anotacaoView
    }
}

