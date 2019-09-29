//
//  Route.swift
//  Flights
//
//  Created by Raul on 28/09/2019.
//  Copyright © 2019 Raul. All rights reserved.
//

struct RouteDTO: Codable {
    var id: String?
    var cityFrom: String?
    var cityTo: String?
    var arrivalTime: Double?
    var departureTime: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case cityFrom = "cityFrom"
        case cityTo = "cityTo"
        case arrivalTime = "aTimeUTC"
        case departureTime = "dTimeUTC"
    }
}

struct Route {
    var id: String
    var cityFrom: String
    var cityTo: String
    var arrivalTime: Double
    var departureTime: Double
    
    init(from routeDTO: RouteDTO) {
        self.id = routeDTO.id ?? ""
        self.cityFrom = routeDTO.cityFrom ?? ""
        self.cityTo = routeDTO.cityTo ?? ""
        self.arrivalTime = routeDTO.arrivalTime ?? 0
        self.departureTime = routeDTO.departureTime ?? 0
    }
}
