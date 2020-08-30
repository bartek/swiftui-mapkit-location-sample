//
//  SearchService.swift
//  swiftui-mapkit-location-sample
//
//  Created by Bartek Ciszkowski on 2020-08-21.
//  Copyright © 2020 Bartek Ciszkowski. All rights reserved.
//

import Foundation
import MapKit
import Combine


class SearchService: NSObject, ObservableObject {
    enum LocationStatus: Equatable {
        case idle
        case noResults
        case isSearching
        case error(String)
        case result
    }
    
    @Published var queryFragment: String = ""
    @Published private(set) var status: LocationStatus = .idle
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []
    @Published private(set) var annotations: [MKPointAnnotation] = []

    private var queryCancellable: AnyCancellable?
    private let searchCompleter: MKLocalSearchCompleter!
    
    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
        self.searchCompleter.delegate = self
            
        queryCancellable = $queryFragment
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: { fragment in
                self.status = .isSearching
                if fragment.isEmpty {
                    self.status = .idle
                    self.searchResults = []
                } else {
                    self.searchCompleter.queryFragment = fragment
                }
            })
    }
    
    func setRegion(_ region: MKCoordinateRegion) {
        self.searchCompleter.region = region
    }
    
    func searchForMapItems(for result: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = result
        searchRequest.region = self.searchCompleter.region
              
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                // Handle the error
                return
            }
          
            guard let item = response.mapItems.first else {
                return
            }

            let annotation = MKPointAnnotation()
            annotation.title = item.placemark.title
            annotation.coordinate = item.placemark.coordinate
            annotation.subtitle = ""
            self.annotations = [annotation]
        }
    }
}

extension SearchService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        // The first result is a "Search Nearby" .. and the intent of this application is
        // to pick a single point and annotate + center, so we can omit this result
        self.searchResults = completer.results.filter({ $0.subtitle != "Search Nearby"})
        self.status = completer.results.isEmpty ? .noResults : .result
    
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
}
