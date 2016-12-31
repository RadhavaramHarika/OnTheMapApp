//
//  MapViewController.swift
//  OnTheMapApp
//
//  Created by radhavaram harika on 12/21/16.
//  Copyright © 2016 Practise. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        mapView.delegate = self
        self.setNavigationBar()
        self.getStudentLocation()
    }
    
    func getStudentLocation()
    {
        var studentLocations = [StudentDetail]()
            UdacityClient.shareInstance().getStudentLocations(withObjectID: nil) {(results,error) in
                
                if error != nil
                {
                    print(error!)
                }
                else
                {
                    DispatchQueue.main.async
                    {
                        if let studentResults = results
                        {
                            studentLocations = studentResults as! [StudentDetail]
                        }
                    }
                }
            }

        var annotations = [MKPointAnnotation]()

        for eachStudent in studentLocations
        {
            let lat = CLLocationDegrees(eachStudent.latitude!)
            let long = CLLocationDegrees(eachStudent.longitude!)
            let studentCoordinate = CLLocationCoordinate2D(latitude: lat,longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = studentCoordinate
            annotation.title = "\(eachStudent.firstName) \(eachStudent.lastName)"
            annotation.subtitle = eachStudent.mediaURL
            
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    func setNavigationBar()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",style: UIBarButtonItemStyle.plain,target:self,action: #selector(self.logoutAction))
        let pinButton = UIBarButtonItem(image: UIImage(named: "PinIcon"),style: UIBarButtonItemStyle.plain,target:self,action: #selector(self.pinIconAction))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "RefreshIcon"),style: UIBarButtonItemStyle.plain,target:self,action: #selector(self.refreshAction))
        
        self.navigationItem.rightBarButtonItems = [pinButton,refreshButton]
    }

    func logoutAction()
    {
        UdacityClient.shareInstance().deletingSessionId() {(results,error) in
            
            if error != nil
            {
                (UIApplication.shared.delegate as! AppDelegate).userID = ""
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func pinIconAction()
    {
        let InfoVc = self.storyboard?.instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController
        self.present(InfoVc,animated: true,completion: nil)
    }
    
    func refreshAction()
    {
        getStudentLocation()
        self.reloadInputViews()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView?.animatesDrop = true
            pinView?.image = UIImage(named: "PinIcon")
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }

}
