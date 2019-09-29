//
//  RootViewController.swift
//  Flights
//
//  Created by Raul on 28/09/2019.
//  Copyright © 2019 Raul. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController?
    let modelController = ModelController()
    let limit = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        /* This parameters will ensure that every day we get new results. It would be good to check if the results (flights for specific day are more than 5) if not then add other day and save ids to user defaults for example to filter the results the next day. */
        guard let dateFrom = Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            let dateTo = Calendar.current.date(byAdding: .day, value: 7, to: Date()) else { return }
    
        // Parameter flyFrom=49.2-16.61-250km indicates that we are looking for flights in a radius of 250km arround Brno, Czech republic.
        let dataApiURL = "https://api.skypicker.com/flights?v=2&sort=popularity&asc=0&locale=en&daysInDestinationFrom=&daysInDestinationTo=&affilid=&children=0&infants=0&flyFrom=49.2-16.61-250km&to=anywhere&featureName=aggregateResults&dateFrom=\(dateFrom.dateFormatted())&dateTo=\(dateTo.dateFormatted())&typeFlight=oneway&returnFrom=&returnTo=&one_per_date=0&oneforcity=1&wait_for_refresh=0&adults=1&limit=\(limit)&partner=picky"
        
        guard let url = URL(string: dataApiURL) else { return }
        var flightResult: FlightResults? = nil
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("ERROR")
                assertionFailure(error.localizedDescription)
            } else if let receivedData = data {
                do {
                    let flightsResultDTO = try JSONDecoder().decode(FlightSearchDTO.self, from: receivedData)
                    flightResult = FlightResults(from: flightsResultDTO)
                    self.modelController.pageData = flightResult?.flights ?? []
                    self.modelController.currency = flightResult?.currency ?? ""
                    DispatchQueue.main.async {
                        self.setupView()
                    }
                } catch {
                    assertionFailure("Parsing failed")
                }
            } else {
                assertionFailure("Data not received")
            }
        }.resume()
    }

    // MARK: - UIPageViewController delegate methods
    
    func setupView() {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        
        // Make dost visible on white background
        let pageIndicator = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        pageIndicator.tintColor = UIColor(red:0.69, green:0.69, blue:0.69, alpha:1.0)
        pageIndicator.currentPageIndicatorTintColor = UIColor(red:0.24, green:0.68, blue:0.64, alpha:1.0)
        
        let startingViewController: DataViewController = modelController.viewControllerAtIndex(0, storyboard: storyboard!)!
        let viewControllers = [startingViewController]
        pageViewController.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
        
        pageViewController.dataSource = self.modelController
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.view.frame = view.bounds
        
        pageViewController.didMove(toParent: self)
    }

    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
            // We allow only portrait orientation.
            guard let currentViewController = pageViewController.viewControllers?[0] else { return .none }
            let viewControllers = [currentViewController]
            pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: { done in })

            self.pageViewController!.isDoubleSided = false
            return .min
    }

}

