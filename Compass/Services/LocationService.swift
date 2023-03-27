//
//  LocationService.swift
//  Compass
//
//  Created by e on 3/17/23.
//

import Foundation
import CoreLocation
import MapKit

final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate  {
    
    @Published var headingDegrees: Double = .zero
    @Published var headingDegreesText: String = 0.text
    
    @Published var userLocation: CLLocation?
    private var alreadySetUserRegion = false
    @Published var userRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    @Published var degreesToUSBank: Double?
    @Published var degreesToTarget: Double?
    @Published var degreesFromTarget: Double?
    
    var targetCoordinates: CLLocationCoordinate2D? {
        didSet {
            setPublishedDegrees()
        }
    }
    
    private var trueHeading: Double = 0
    
    private let rlAddress = "401 Chicago Ave, Minneapolis, MN 55415"
    // Coordinates taken from running usBankCoordinates()
    let usBankCoordinates = CLLocationCoordinate2D(latitude: 44.97346610, longitude: -93.25761160)
    var usBankMapItem: MapItem {
        return MapItem(name: "U.S. Bank Stadium",
                       latitude: usBankCoordinates.latitude,
                       longtitude: usBankCoordinates.longitude)
    }
    
    
    private let locationManager: CLLocationManager
    private let geoCoder = CLGeocoder()
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.setup()
    }
    
    private func setup() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.headingAvailable() {
            locationManager.startUpdatingHeading()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if manager.authorizationStatus == .authorizedAlways ||
                    manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingDegrees = -newHeading.magneticHeading
        // Rounding toward zero removes the decimals which helps avoid Double from rounding up when converting to text.
        let newText = newHeading.magneticHeading.rounded(.towardZero).text + "°"
        self.trueHeading = newHeading.trueHeading
        headingDegreesText = newText
        
        setPublishedDegrees()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = manager.location
        setPublishedDegrees()
        setUserRegion()
    }
}

extension LocationService {
    
    private func usBankCoordinates(completion: @escaping (CLLocation?) -> Void) {
        geoCoder.geocodeAddressString(rlAddress) { placemarks, _ in
            completion(placemarks?.first?.location)
        }
    }
    
    private func setPublishedDegrees() {
        setDegreesToUSBank()
        setDegreesToTarget()
        setDegreesFromTarget()
    }
    
    private func setDegreesToUSBank() {
        self.degreesToUSBank = getDegrees(to: usBankCoordinates)
    }
    
    private func setDegreesToTarget() {
        guard let coords = targetCoordinates else { return }
        self.degreesToTarget = getDegrees(to: coords)
    }
    
    private func setDegreesFromTarget() {
        guard let degreesToTarget = degreesToTarget else { return }
        var newValue = abs(abs(headingDegrees) - degreesToTarget)
        if newValue > 180 {
            newValue = abs(newValue - 360)
        }
        self.degreesFromTarget = newValue
    }
    
    private func getDegrees(to target: CLLocationCoordinate2D) -> Double? {
        
        guard let userLocation = locationManager.location?.coordinate else { return nil }
        
        // if the true heading is West then we want to subtract from true north bearing
        // else if the true heading is East we want to add
        // we are multuplying by -1 because headingDegrees is negative already.
        let degredation = -(headingDegrees + trueHeading)
        let trueNorthBearing = bearing(between: target, point2: userLocation)
        return trueNorthBearing + degredation
    }
    
    private func distance(between point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {
        
        // https://www.movable-type.co.uk/scripts/latlong.html
        
        let earthsRadius: Double =  6371 //km
        let lat1 = point1.latitude * Double.pi/180
        let lat2 = point2.latitude * Double.pi/180
        let deltaLat = (lat2 - lat1) * Double.pi/180
        let deltaLong = (point2.longitude - point1.longitude) * Double.pi/180
        
        let a = sin(deltaLat/2) * sin(deltaLat/2) + cos(lat1) * cos(lat2) * sin(deltaLong/2) * sin(deltaLong/2)
        
        let c = 2 * atan2(a.squareRoot(), (1-a).squareRoot())
        
        return earthsRadius * c
    }
    
    private func bearing(between point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {
        
        // https://www.movable-type.co.uk/scripts/latlong.html
        
        let lat1 = point1.latitude.degreesToRadians
        let long1 = point1.longitude.degreesToRadians
        
        let lat2 = point2.latitude.degreesToRadians
        let long2 = point2.longitude.degreesToRadians
        
        let deltaLong = long2 - long1
        
        let y = sin(deltaLong) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLong)
        let degrees = atan2(y, x)
        
        return (degrees.radiansToDegress + 180).truncatingRemainder(dividingBy: 360)
    }
}


extension LocationService {
    func getMapItems(for address: String, completion: @escaping ([MKMapItem]) -> Void) {
        
        let request = MKLocalSearch.Request()
        
        guard let coords = locationManager.location?.coordinate else { return }

        let region = MKCoordinateRegion.init(center: coords,
                                             latitudinalMeters: 2000,
                                             longitudinalMeters: 2000)
        
        request.naturalLanguageQuery = address
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            completion(response.mapItems)
        }
    }
}

extension LocationService {
    func setUserRegion() {
        if let location = userLocation,
            !alreadySetUserRegion
        {
            self.alreadySetUserRegion = true
            self.userRegion = MKCoordinateRegion(center: location.coordinate,
                                                 latitudinalMeters: 500,
                                                 longitudinalMeters: 500)
            return
        }
    }
}


