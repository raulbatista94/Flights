//
//  DataViewController.swift
//  Flights
//
//  Created by Raul on 28/09/2019.
//  Copyright © 2019 Raul. All rights reserved.
//

import UIKit
import Foundation

class DataViewController: UIViewController {

    @IBOutlet weak var destinationLabel: UILabel!
    var dataObject: Flight? = nil
    var currency: String = ""
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var checkMoreButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func openOffer(_ sender: Any) {
        guard let offer = dataObject,
            let url = URL(string: offer.deepLink) else { return }
        UIApplication.shared.open(url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkMoreButton.layer.cornerRadius = 4
        imageView.image = UIImage(named: "notFound") // Initial image in case that we don't find anything.
        guard let destination = dataObject,
            let imageLink = URL(string: "https://images.kiwi.com/photos/600x330/\(destination.mapIdTo).jpg") else { return }
        destinationLabel!.text = "From \(destination.cityFrom) to \(destination.cityTo)"
        priceLabel!.text = "\(destination.price) \(currency)"
        
        let stopCities = destination.route.map { $0.cityTo }
        
        if destination.route.count > 1 {
            detailsLabel!.text = "Only \(destination.route.count) stops \(stopCities) and flight duration only \(destination.flightDuration),\n your depature time is: \(destination.departure.description(with: .current)) and the estimated arrival is \(destination.arrival.description(with: .current))"
        } else {
            detailsLabel!.text = "Direct fligth with duration \(destination.flightDuration),\n Your depature time is: \(destination.departure.description(with: .current)) and the estimated arrival is \(destination.arrival.description(with: .current))"
        }
        
        URLSession.shared.dataTask(with: imageLink) { [weak self] (data, response, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            } else if let receivedData = data {
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: receivedData)
                }
            } else {
                self?.imageView.image = UIImage()
                assertionFailure("Failed to parse data")
            }
        }.resume()
    }
}
