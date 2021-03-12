//
//  WeaherAppApp.swift
//  WeaherApp
//
//  Created by Reza Ramadhan Irianto on 12/03/21.
//

import SwiftUI

@main
struct WeaherAppApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let viewModel = WeatherViewModel(weatherService: weatherService)
            WeatherView(viewModel: viewModel)
        }
    }
}
