//
//  mapALL.swift
//  Biteverse
//
//  Created by a. on 2/12/2566 BE.
//

import UIKit
import CoreLocation
import MapKit
class mapALL: UIViewController,MKMapViewDelegate, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UNUserNotificationCenterDelegate  {
    
    
    var lang=String()
    
    var selectedAnnotation: MKPointAnnotation?
    @IBOutlet weak var directionss: UIButton!
    
    @IBOutlet weak var cancelDirections: UIButton!
    @IBAction func cancelDirections(_ sender: Any) { //1
        guard let _ = selectedAnnotation else {
            let alertController = UIAlertController(title: "Error", message: "No location selected to cancel", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        mapView.removeOverlays(mapView.overlays)
        selectedAnnotation = nil
        searchTF.text = ""
        searchLo.removeAll()
        tableView.reloadData()
    }
    
    
    @IBAction func directionss(_ sender: Any) {
        guard let selectedAnnotation = selectedAnnotation else {
            let alertController = UIAlertController(title: "Error", message: "Select location first👀", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        getDirections(to: selectedAnnotation.coordinate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            
            // show uicontroller
            let alertController = UIAlertController(title: "Do you need help navigating?", message: "If yes,select your preferred navigation app :", preferredStyle: .actionSheet)
            
            // option apple maps
            let appleMapsAction = UIAlertAction(title: "Apple Maps", style: .default) { [weak self] _ in
                
                self?.navigateWithAppleMaps(destination: selectedAnnotation.coordinate)
            }
            alertController.addAction(appleMapsAction)
            
            // option google maps
            let googleMapsAction = UIAlertAction(title: "Google Maps", style: .default) { [weak self] _ in
                
                self?.navigateWithGoogleMaps(destination: selectedAnnotation.coordinate)
            }
            alertController.addAction(googleMapsAction)
            
            // option cancel
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            //ui alert
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    //NAVIGATE TO AN APP
    func navigateWithGoogleMaps(destination: CLLocationCoordinate2D) {
        let destinationString = "\(destination.latitude),\(destination.longitude)"
        if let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(destinationString)&travelmode=driving") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                showAlertForMapsNotInstalled()
            }
        }
    }
    
    func showAlertForMapsNotInstalled() {
        let alertController = UIAlertController(title: "Error", message: "Google Maps app is not installed.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    func navigateWithAppleMaps(destination: CLLocationCoordinate2D) {
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        destinationMapItem.openInMaps(launchOptions: launchOptions)
    }
    
    
    //GET DIRECTIONS Draft HEHE
    func getDirections(to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("error😰😰: \(error.localizedDescription)")
                return
            }
            
            if let route = response?.routes.first {
                self.mapView.removeOverlays(self.mapView.overlays)
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                showTravelTime(route: route)
                
                
                
            }
            
        }
    }
    //GET DIRECTIONS Draft HEHE
    
    // NOTI TRAVEL TIME
    func showTravelTime(route: MKRoute) {
        let travelTime = route.expectedTravelTime
        let travelTimeMinutes = Int(travelTime / 60)
        print("Expected Travel Time: \(travelTimeMinutes) minutes")
        
        
    }
    
    
    
    
    
    
    //SHOW USER LOCATION
    let regionMeters:Double=3000
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func showUserLocation(){
        DispatchQueue.main.async { [weak self] in
            self?.mapView.showsUserLocation = true
            self?.centerViewOnUserLocation()
            self?.locationManager.startUpdatingLocation()
        }
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    @IBAction func btnSearch(_ sender: Any) {
        searchForLocation()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]() //
    var searchLo = [MKPointAnnotation]()
    let myLocation = CLLocationManager() // my lo
    
    
    //select on map and direct
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation as? MKPointAnnotation else {
            return
        }
        self.selectedAnnotation = selectedAnnotation
        
        let region = MKCoordinateRegion(center: selectedAnnotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        showDirectionss()
    }
    
    func showDirectionss() {
        self.directionss.isHidden = false
        
    }
    
    func hideDirectionss() {
        self.directionss.isHidden = true
    }
    
    
    //Table View START
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchLo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        let annotation = searchLo[indexPath.row]
        cell.textLabel?.text = annotation.title
        if let subtitleName = annotation.subtitle {
            cell.detailTextLabel?.text = "\(annotation.subtitle ?? "") - \(subtitleName)"
        } else {
            cell.detailTextLabel?.text = annotation.subtitle
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let annotation = searchLo[indexPath.row]
        selectedAnnotation = annotation
        
        DispatchQueue.main.async {
            self.mapView.selectAnnotation(annotation, animated: true)
            self.mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300), animated: true)
            
            //hide keyboard
            self.searchTF.becomeFirstResponder()
            
            
            
        }
    }
    
    
    // get directions draftttt
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            if switchLightDark.isOn{
                renderer.strokeColor = UIColor.white
            }
            else if switchLightDark.isEnabled{
                renderer.strokeColor = UIColor.systemBlue
            }
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer()
    }
    // get directions draftttt
    
    
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchForLocation()
    }
    
    // TableView END
    
    
    let locationManager = CLLocationManager() //my lo
    
    
    @objc func hideTableView() {
        view.endEditing(true) //hide keyboard
        tableView.isHidden = true //hide table view
        hideDirectionss()
    }
    
    @IBOutlet weak var switchLightDark: UISwitch!
    @IBAction func switchLightDark(_ sender: Any) {
        if switchLightDark.isOn {
            overrideUserInterfaceStyle = .dark
        } else if switchLightDark.isEnabled{
            overrideUserInterfaceStyle = .light
            
        }
    }
    
    // viewDidLoad START
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("mapVC:\(lang)")
        
        overrideUserInterfaceStyle = .light
        
        // hide directionss button first
        hideDirectionss()
        
        //user location
        showUserLocation()
        
        //hide keyboardd
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideTableView))
        mapView.addGestureRecognizer(tapGesture)
        
        
        //location Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        
        
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: 0)
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        
        
        mapView.delegate = self //
        searchTF.delegate = self //
        tableView.delegate = self
        tableView.dataSource = self
        
        
        var plistName: String
        
        if lang == "th" {
            plistName = "LocationsTH"
        } else {
            plistName = "Locations"
        }

        if let path = Bundle.main.path(forResource: plistName, ofType: "plist"),
           let locations = NSDictionary(contentsOfFile: path) as? [String: Any] {
            for (locationKey, locationInfo) in locations {
                if let locationData = locationInfo as? [String: Any],
                   let latitude = locationData["Latitude"] as? Double,
                   let longitude = locationData["Longitude"] as? Double {
                    print("Latitude: \(latitude), Longitude: \(longitude)")
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotation.title = locationKey
                    annotation.subtitle = locationData["Subtitle"] as? String
                    mapView.addAnnotation(annotation)
                    annotations.append(annotation)
                }
            }
        }
        
        let region = MKCoordinateRegion(center: mapView.annotations.first?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(region, animated: true)
        
    }
    // viewDidLoad END
    
    
    func searchForLocation() {
        guard let searchText = searchTF.text?.lowercased() else {
            return
        }
        
        searchLo.removeAll()
        
        for annotation in annotations {
            if let title = annotation.title?.lowercased(),
               let subtitle = annotation.subtitle?.lowercased()  {
                if title.contains(searchText) || subtitle.contains(searchText) {
                    searchLo.append(annotation)
                }
            }
            
            if searchLo.isEmpty {
                let noLo = UILabel()
                noLo.text = "!!! no location found !!!"
                noLo.textColor = UIColor.systemRed
                noLo.textAlignment = .center
                tableView.backgroundView = noLo
                tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: 40)
            } else {
                tableView.backgroundView = nil
                let cellHeight: CGFloat = 50.0
                let tableViewHeight = CGFloat(searchLo.count) * cellHeight
                //hid etbaleview not work
                let maxHeight: CGFloat = 200.0
                let finalTableViewHeight = min(tableViewHeight, maxHeight)
                tableView.frame = CGRect(x: tableView.frame.origin.x, y:
                                            tableView.frame.origin.y, width: tableView.frame.size.width, height: finalTableViewHeight)
                tableView.isHidden = searchLo.isEmpty
                
            }
            
            tableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchForLocation()
        return true
    }
    
    
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view contro#ller.
    }
    */

}
