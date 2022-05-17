//
//  ViewController.swift
//  Contry-Boundary
//
//  Created by Roman Zhukov on 17.05.2022.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MKMapViewDelegate {
    let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        mapView.delegate = self
        
        createMapView()
        createPolygonOfCountry()
    }
}

extension MainViewController {
    private func createMapView() {
        
        mapView.frame = CGRect(origin: .zero,
                               size: CGSize(width: UIScreen.main.bounds.width,
                                            height: UIScreen.main.bounds.height))
        
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        view.addSubview(mapView)
    }
    
    private func createPolygonOfCountry() {
        mapView.addOverlay(MKPolygon(coordinates: [CLLocationCoordinate2D(latitude: 4, longitude: 4),
                                                   CLLocationCoordinate2D(latitude: 70, longitude: 80),
                                                   CLLocationCoordinate2D(latitude: 23, longitude: 76),
                                                   CLLocationCoordinate2D(latitude: 11, longitude: 67),
                                                   CLLocationCoordinate2D(latitude: 4, longitude: 4)], count: 5))
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = .red
            return polygonView
        }
        return MKOverlayRenderer()
    }
}
