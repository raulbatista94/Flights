//
//  FlightSearch.swift
//  Flights
//
//  Created by Raul on 28/09/2019.
//  Copyright © 2019 Raul. All rights reserved.
//

struct FlightSearchDTO: Codable {
    let id: String?
    let currency: String?
    let flights: [FlightDTO?]
    
    enum CodingKeys: String, CodingKey {
        case id = "search_id"
        case currency = "currency"
        case flights = "data"
    }
}

struct FlightResults {
    let id: String
    let currency: String
    let flights: [Flight]
    
    init(from flightSearchDTO: FlightSearchDTO) {
        self.id = flightSearchDTO.id ?? ""
        self.currency = flightSearchDTO.currency ?? ""
        self.flights = flightSearchDTO.flights.map { flightDTO in
            guard let flight = flightDTO else { return Flight() }
            return Flight(from: flight)
        }
    }
}
