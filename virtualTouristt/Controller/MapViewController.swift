//
//  MapViewController.swift
//  virtualTouristt
//
//  Created by Jieun Bae on 12/30/20.
//

import UIKit
import MapKit
import CoreData

    class MapViewController: UIViewController, MKMapViewDelegate
    
    {

    var selectedAnnotation: MKAnnotation!
    var pins: [Pin] = []
    @IBOutlet weak var mapView: MKMapView!
    let dataController = DataController(modelName: "virtualTouristt")
    
 

    override func viewDidLoad()
    {
        super.viewDidLoad()
        dataController.load()
      
        mapView.delegate = self
        
        //function to appear pin when we press it long time
        
        let touchPoint = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressHandler(sender:)))
        
        mapView.addGestureRecognizer(touchPoint)
        
        if UserDefaults.standard.bool(forKey: "beforeScreen")
          {
          //holds map at certain region
        
          mapView.region = MKCoordinateRegion( center: CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitude"),
          longitude: UserDefaults.standard.double(forKey: "longitude")), span: MKCoordinateSpan( latitudeDelta: UserDefaults.standard.double(forKey: "latitudeDelta"),
          longitudeDelta: UserDefaults.standard.double(forKey: "longitudeDelta")))
            
          bringOutPins()
            
        }
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        UserDefaults.standard.set(true, forKey: "beforeScreen")
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "latitude")
        UserDefaults.standard.set(mapView.region.center.longitude, forKey: "longitude")
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "latitudeDelta")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "longitudeDelta")
        UserDefaults.standard.synchronize()
  }

  
    @objc func longPressHandler(sender: UILongPressGestureRecognizer)
    {
        
        if sender.state != UIGestureRecognizer.State.began { return }
        let touchLocation = sender.location(in: mapView)
        let location = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        let pin = addPin(loc: location)
        addAnnotation(pin: pin)
  }
        
    
        //bring out all the pins when pressed
        func bringOutPins()
            {
            let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lat", ascending: true)]
            
                if let result = try? dataController.viewContext.fetch(fetchRequest)
                {
                    pins = result
                    for pin in pins
                        {
                        addAnnotation(pin: pin)
                        }
                }
            }
    //adds specified annotation to the map view
            
    func addAnnotation(pin: Pin)
        {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon)
            mapView.addAnnotation(annotation)
        }

        
    func addPin(loc: CLLocationCoordinate2D) -> Pin
            {
            let pin = Pin(context: dataController.viewContext)
            pin.lat = loc.latitude
            pin.lon = loc.longitude
            
            
            pins.append(pin)
            try? dataController.viewContext.save()
            return pin
            }
        
    func searchForPin(loc: CLLocationCoordinate2D) -> Pin?
                {
                  let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
                  fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lat", ascending: true)]
                  fetchRequest.predicate = NSPredicate(format: "lat == %@ AND lon == %@", NSNumber.init(value: loc.latitude),NSNumber.init(value: loc.longitude))
                  if let result = try? dataController.viewContext.fetch(fetchRequest)
                  
                    {
                    
                    return result.first!
                    
                    } else {
                    
                    return nil
                        
                  }
             
            }


        //map view controller to photoviewcontroller segue
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
        {
            
        performSegue(withIdentifier: "nextPage", sender: self)
            
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        
            {
            let connect = segue.destination as! PhotoViewController
            connect.pin = searchForPin(loc: mapView.selectedAnnotations.first!.coordinate)
            connect.dataController = dataController
            }
        }
