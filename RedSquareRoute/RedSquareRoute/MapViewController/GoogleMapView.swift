//
//  GoogleMapView.swift
//  RedSquareRoute
//
//  Created by Andrew on 19/01/2020.
//  Copyright © 2020 Andrew. All rights reserved.
//

import GoogleMaps
import UIKit

class GoogleMapView: UIView {
    
    var map = GMSMapView()
    
    var routeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var getLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        let width = UIScreen.main.bounds.size.width
        
        self.map.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(map)
        
        self.map.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.map.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.map.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.map.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        self.map.addSubview(self.routeButton)
        
        self.routeButton.widthAnchor.constraint(equalToConstant: width*0.45).isActive = true
        self.routeButton.heightAnchor.constraint(equalToConstant: width*0.1).isActive = true
        self.routeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -width*0.25).isActive = true
        self.routeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -width*0.2).isActive = true
        self.configButton(button: self.routeButton, text: "Построить маршрут")
        
        self.map.addSubview(self.getLocationButton)
        
        self.getLocationButton.widthAnchor.constraint(equalToConstant: width*0.45).isActive = true
        self.getLocationButton.heightAnchor.constraint(equalToConstant: width*0.1).isActive = true
        self.getLocationButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: width*0.25).isActive = true
        self.getLocationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -width*0.2).isActive = true
        self.configButton(button: self.getLocationButton, text: "Где я?")
    }
    
    private func configButton(button: UIButton, text: String) {
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0.7
        button.layer.cornerRadius = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
    }
}
