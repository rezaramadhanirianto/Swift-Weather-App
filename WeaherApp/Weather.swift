//
//  Weather.swift
//  WeaherApp
//
//  Created by Reza Ramadhan Irianto on 12/03/21.
//

import Foundation

public struct Weather{
    let city: String
    let temperatur: String
    let description: String
    let iconName: String
    
    init(response: APIResponse){
        city = response.name
        temperatur = "\(Int(response.main.temp))"
        description = response.weather.first?.description ?? ""
        iconName = response.weather.first?.iconName ?? ""
    }
}
