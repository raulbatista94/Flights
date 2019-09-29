//
//  Flight.swift
//  Flights
//
//  Created by Raul on 28/09/2019.
//  Copyright © 2019 Raul. All rights reserved.
//

struct Flight: Equatable {
    static func == (lhs: Flight, rhs: Flight) -> Bool {
        return lhs.id == rhs.id && lhs.cityTo == rhs.cityTo && lhs.cityFrom == rhs.cityFrom
    }
    
    let id: String
    let cityFrom: String
    let cityTo: String
    let flightDuration: String
    let price: Double
    let route: [Route]
    let mapIdTo: String // This is used to get destination image from server.
    let deepLink: String
    
    init(id: String = "Unavailable", cityFrom: String = "Unavailable", cityTo: String = "Unavailable", flightDuration: String = "Unavailable", price: Double = 0.0, route: [Route] = [], mapIdTo: String = "Unavailable", deepLink: String = "") {
        self.id = id
        self.cityFrom = cityFrom
        self.cityTo = cityTo
        self.flightDuration = flightDuration
        self.price = price
        self.route = route
        self.mapIdTo = mapIdTo
        self.deepLink = deepLink
    }
    
    init(from flightDTO: FlightDTO) {
        self.id = flightDTO.id ?? ""
        self.cityFrom = flightDTO.cityFrom ?? ""
        self.cityTo = flightDTO.cityTo ?? ""
        self.flightDuration = flightDTO.flightDuration ?? ""
        self.price = flightDTO.price ?? 0
        self.route = flightDTO.route.map { Route(from: $0!) }
        self.mapIdTo = flightDTO.mapIdTo ?? ""
        self.deepLink = flightDTO.deepLink ?? ""
    }
}

struct FlightDTO: Codable {
    var id: String?
    var cityFrom: String?
    var cityTo: String?
    var flightDuration: String?
    var price: Double?
    var route: [RouteDTO?]
    var mapIdTo: String?
    var deepLink: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case cityFrom = "cityFrom"
        case cityTo = "cityTo"
        case price = "price"
        case flightDuration = "fly_duration"
        case route = "route"
        case mapIdTo = "mapIdto"
        case deepLink = "deep_link"
    }
}
