//
//  InformationViewController.swift
//  OnTheMapApp
//
//  Created by radhavaram harika on 12/22/16.
//  Copyright © 2016 Practise. All rights reserved.
//

import UIKit
import MapKit

class InformationViewController: UIViewController,UITextFieldDelegate,MKMapViewDelegate {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var findOnMap: UIButton!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var linkTextfield: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var submit: UIButton!
    var coordinates:CLLocationCoordinate2D!

    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        secondView.isHidden = true
        
    }
   
    @IBAction func findOnMapPressed(_ sender: Any) {
        firstView.isHidden = true
        secondView.isHidden = false
        self.setMapView()
    }
    
    func setMapView()
    {
        if cityTextfield.text != nil
        {
            let location = cityTextfield.text
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(location!) {(placeMarks, error) in
                
                if error != nil
                {
                    DispatchQueue.main.async {
                        self.createAlertViewController(title: "Geocoder Error", message: "Could not find location.Please enter a valid location", buttonTitle: "OK")
                        
                    }
                }
                if let placeMark = placeMarks?.first, let location = placeMark.location
                {
                    let mark = MKPlacemark(placemark: placeMark)
                    
                    let placemark: CLPlacemark = placeMark
                    let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                    let pointAnnotation: MKPointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = coordinates
                    self.mapView?.addAnnotation(pointAnnotation)
                    self.mapView?.centerCoordinate = coordinates
                    self.mapView?.camera.altitude = 20000
                    self.coordinates = coordinates
                    
                }
            }
    }
    }
    
    @IBAction func submitPressed(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let studentInfo:[String:AnyObject] = [ UdacityClient.ResponseKeys.uniqueKey:"9999" as AnyObject,
                                               UdacityClient.ResponseKeys.firstName:appDelegate.firstName as AnyObject,
                                               UdacityClient.ResponseKeys.lastName:appDelegate.lastName as AnyObject,
                                               UdacityClient.ResponseKeys.mapString:cityTextfield.text as AnyObject,
                                               UdacityClient.ResponseKeys.mediaURL:linkTextfield.text as AnyObject,
                                               UdacityClient.ResponseKeys.latitude:self.coordinates.latitude.description as AnyObject,
                                               UdacityClient.ResponseKeys.longitude:self.coordinates.longitude.description as AnyObject]
        UdacityClient.shareInstance().getUserData() {(results,error) in
            if error != nil
            {
                print("error")
            }
        }
        UdacityClient.shareInstance().postStudentLocation(json: studentInfo) {(results,error) in
            DispatchQueue.main.async
            {
                if error != nil
                {
                    print(error!)
                }
                if let results = results as? [String:AnyObject]
                {
                    let objectId = results[UdacityClient.ResponseKeys.objectId] as? String
                    print(results[UdacityClient.ResponseKeys.createdAt]!)
                    print(objectId!)
                    (UIApplication.shared.delegate as! AppDelegate).objectID = objectId!
                    
                }
            }
        }
    }
    
    @IBAction func CancelAction(_ sender: Any) {
        self.cityTextfield.text = ""
        self.linkTextfield.text = ""
        secondView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        cityTextfield.placeholder = ""
        linkTextfield.placeholder = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextfield.resignFirstResponder()
        linkTextfield.resignFirstResponder()

        return true
    }
        
    func createAlertViewController(title:String, message: String, buttonTitle:String)
    {
            let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style:UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }

}

