//
//  WeatherServices.swift
//  WeaherApp
//
//  Created by Reza Ramadhan Irianto on 12/03/21.
//

import Foundation
import CoreLocation

public final class WeatherService: NSObject{
    private let locationManager = CLLocationManager()
    private let apiKey = "dea3f5dc426a0b9a94298e284d442238"
    private var completionHandler: ((Weather) -> Void)?
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData(_ completionHandler: @escaping((Weather) -> Void)){
        self.completionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
//    api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    private func makeDataRequest(forCordinates coordinates: CLLocationCoordinate2D){
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(apiKey)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url){
            data, response, error in
            guard error == nil, let data = data else {return}
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data){
                self.completionHandler?(Weather(response: response))
            }
        }.resume()
        
    }
}

extension WeatherService : CLLocationManagerDelegate{
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ){
        guard let location = locations.first else {return}
        makeDataRequest(forCordinates: location.coordinate)
    }
    public func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error){
        print("Something Went Wrong : " + error.localizedDescription)
    }
}

struct APIResponse : Decodable{
    let name: String
    let main: APIMain
    let weather: [APIWeather]
}
struct APIMain: Decodable{
    let temp: Double
}

struct APIWeather: Decodable{
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey{
        case description
        case iconName = "main"
    }
}
