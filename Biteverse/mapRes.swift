//
//  mapRes.swift
//  Biteverse
//
//  Created by a. on 2/12/2566 BE.
//

import UIKit
import MapKit
import CoreLocation
class mapRes: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var switchh: UISwitch!
    
    @IBAction func switchh(_ sender: Any) {
        if switchh.isOn{
            overrideUserInterfaceStyle = .dark
        }
        else if switchh.isEnabled{
            overrideUserInterfaceStyle = .light
        }
    }
  
    @IBOutlet weak var mapLo: MKMapView!
    
    
    var latitude: Double = 0
    var longitude: Double = 0
    var annotationTitle: String = ""
    var selectedAnnotation: MKAnnotation!
    var lang=String()
  
    func getAlertTitle() -> String {
            if lang == "th" {
                return "ต้องการให้ช่วยนำทางหรือไม่"
            } else {
                return "Do you need help navigating"
            }
        }

        func getAlertMessage() -> String {
            if lang == "th" {
                return "ถ้าใช่โปรดเลือกoptionที่คุณต้องการ"
            } else {
                return "If yes,select your preferred navigation app"
            }
        }

    
    
    @IBAction func directionss(_ sender: Any) {
        print("Direction button tapped")
        guard let selectedAnnotation = selectedAnnotation else {
            print("error")
            return
        }
        
        getDirections(to: selectedAnnotation.coordinate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            // Alert controller
            let alertController = UIAlertController(title: self?.getAlertTitle(), message: self?.getAlertMessage(), preferredStyle: .actionSheet)
            
            // Apple Maps option
            let appleMapsAction = UIAlertAction(title: NSLocalizedString("Apple Maps", comment: ""), style: .default) { [weak self] _ in
                self?.navigateWithAppleMaps(destination: selectedAnnotation.coordinate)
            }
            alertController.addAction(appleMapsAction)
            
            // Google Maps option
            let googleMapsAction = UIAlertAction(title: NSLocalizedString("Google Maps", comment: ""), style: .default) { [weak self] _ in
                self?.navigateWithGoogleMaps(destination: selectedAnnotation.coordinate)
            }
            alertController.addAction(googleMapsAction)
            
            // Cancel option
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // Show UIAlertController
            self?.present(alertController, animated: true, completion: nil)
        }
    
    }
  
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedAnnotation = view.annotation
    }

    
    //GET DIRECTIONS Draft HEHE
    func getDirections(to destination: CLLocationCoordinate2D) {
        guard let userLocation = mapLo.userLocation.location else {
               print("User location not available.")
               return
           }

           let request = MKDirections.Request()
           request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
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
                self.mapLo.removeOverlays(self.mapLo.overlays)
                self.mapLo.addOverlay(route.polyline, level: .aboveRoads)

                let rect = route.polyline.boundingMapRect
                self.mapLo.setRegion(MKCoordinateRegion(rect), animated: true)
             
                
                }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            if switchh.isOn{
                renderer.strokeColor = UIColor.white
            }
            else if switchh.isEnabled{
                renderer.strokeColor = UIColor.systemBlue
            }
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer()
    }

    // naviagate to apple and gg
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
    // naviagate to apple and gg
 
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          if status == .authorizedWhenInUse {
              showUserLocation()
              
             
          }
      }
    
    
    //SHOW USER LOCATION
    let locationManager = CLLocationManager() //my lo
        let regionMeters:Double=3000
        func centerViewOnUserLocation() {
            if let location = locationManager.location?.coordinate {
                let region = MKCoordinateRegion(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
                mapLo.setRegion(region, animated: true)
            }
        }
        
        func showUserLocation(){
            DispatchQueue.main.async { [weak self] in
                self?.mapLo.showsUserLocation = true
                self?.centerViewOnUserLocation()
                self?.locationManager.startUpdatingLocation()
            }
        }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        mapLo.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        showUserLocation()
      
        
        
        
        // position
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let meters: CLLocationDistance = 1000
        let region = MKCoordinateRegion(center: location, latitudinalMeters: meters, longitudinalMeters: meters)
        mapLo.setRegion(region, animated: true)

        // add annotation and title
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = annotationTitle
        mapLo.addAnnotation(annotation)

        //เด้ง
        mapLo.selectAnnotation(annotation, animated: true)
        
    }
}


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


