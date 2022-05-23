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
//        mapView.addOverlay(MKPolygon(coordinates: [CLLocationCoordinate2D(latitude: 4, longitude: 4),
//                                                   CLLocationCoordinate2D(latitude: 70, longitude: 80),
//                                                   CLLocationCoordinate2D(latitude: 23, longitude: 76),
//                                                   CLLocationCoordinate2D(latitude: 11, longitude: 67),
//                                                   CLLocationCoordinate2D(latitude: 4, longitude: 4)], count: 5))
        mapView.addOverlays(parseGeoJSON())
    }
    
    private func parseGeoJSON() -> [MKOverlay] {
        guard let url = Bundle.main.url(forResource: "Map", withExtension: "json") else { return [] }
        
        var geoJSON = [MKGeoJSONObject]()
        
        do {
            let data = try Data(contentsOf: url)
            geoJSON = try MKGeoJSONDecoder().decode(data)
        } catch {
            print(error)
        }
        
        var overlays = [MKOverlay]()
        
        for item in geoJSON {
            if let feature = item as? MKGeoJSONFeature {
                for geo in feature.geometry {
                    if let polygon = geo as? MKMultiPolygon {
                        overlays.append(polygon)
                    }
                }
            }
        }
        
        return overlays
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polygon = overlay as? MKMultiPolygon {
            let polygonView = MKMultiPolygonRenderer(multiPolygon: polygon)
            polygonView.strokeColor = .red
            return polygonView
        }
        return MKOverlayRenderer()
    }
}
