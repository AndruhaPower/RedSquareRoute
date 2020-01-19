//
//  GoogleService.swift
//  RedSquareRoute
//
//  Created by Andrew on 19/01/2020.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps


class GoogleService {
    
    public func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (String) -> ()) {

        let session = URLSession.shared
        let originLocation = String(source.latitude) + "," + String(source.longitude)
        let destinationLocation = String(destination.latitude) + "," + String(destination.longitude)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "maps.googleapis.com"
        urlComponents.path = "/maps/api/directions/json"
        urlComponents.queryItems = [
            URLQueryItem(name: "origin", value: originLocation),
            URLQueryItem(name: "destination", value: destinationLocation),
            URLQueryItem(name: "sensor", value: "false"),
            URLQueryItem(name: "mode", value: "drive"),
            URLQueryItem(name: "key", value: Constants.googleAPIKey)
        ]
        
        guard let url = urlComponents.url else { return }
        

        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in

            guard error == nil else {
                print(error!.localizedDescription)
                return
            }

            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                , let routes = jsonResult["routes"] as? [Any]
                , !routes.isEmpty
                , let route = routes[0] as? [String: Any]
                , let overview_polyline = route["overview_polyline"] as? [String : Any]
                , let polyLineString = overview_polyline["points"] as? String else { return }
            
            completion(polyLineString)
        })
        task.resume()
    }
    
    private func presentErrorAlert() {
        let alert = UIAlertController(title: "Error!", message: "No routes by Driving possible to Red Square", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .destructive, handler: nil)
        alert.addAction(closeAction)
    }
}
