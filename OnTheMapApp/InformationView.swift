//
//  InformationView.swift
//  OnTheMapApp
//
//  Created by radhavaram harika on 12/22/16.
//  Copyright © 2016 Practise. All rights reserved.
//

import UIKit
import MapKit

class InformationView: UIView,MKMapViewDelegate
{
    var promptLabel:UILabel = UILabel()
    var customTextView: UITextView = UITextView()
    var buttom: UIButton = UIButton()
    var mapView = MKMapView()
    var submitButtom:UIButton = UIButton()
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    private func developInfoView()
    {
        promptLabel.frame = CGRect(x: 0,y: 0,width: self.frame.width,height: 200)
        promptLabel.backgroundColor = UIColor.clear
        promptLabel.textAlignment = NSTextAlignment.center
        promptLabel.text = "Where are you \n studying \n today?"
        promptLabel.numberOfLines = 0
        promptLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.addSubview(promptLabel)
        
        self.createCustomTextView(frame: CGRect(x: 0,y: promptLabel.frame.height,width: self.frame.width,height: self.frame.height - promptLabel.frame.height))
        
        buttom.frame = CGRect(x: self.frame.width/2 - 50,y: customTextView.frame.height/4 - 20 ,width:100,height: 40)
        buttom.backgroundColor = UIColor.lightText
        buttom.setTitle("Find on the Map", for: .normal)
        buttom.setTitleColor(UIColor.cyan, for: .normal)
        buttom.addTarget(self, action: #selector(findMapAction(sender:)), for: .touchUpInside)
        self.addSubview(buttom)
        self.bringSubview(toFront: buttom)

    }
    
    func createCustomTextView(frame: CGRect)
    {
        customTextView.removeFromSuperview()
        customTextView.frame = frame
        customTextView.textAlignment = NSTextAlignment.center
        customTextView.textColor = UIColor.white
        customTextView.text = ""
        customTextView.backgroundColor = UIColor.blue
        customTextView.isUserInteractionEnabled = true
        self.addSubview(customTextView)

    }
    
    @objc private func findMapAction(sender: UIButton)
    {
        if !customTextView.text.isEmpty
        {
            self.createMapView(locationString: customTextView.text)
        }
    }
    
    func createMapView(locationString: String)
    {
        promptLabel.removeFromSuperview()
        
        self.createCustomTextView(frame: CGRect(x: 0,y: 0,width: self.frame.width,height: 200))
        
        mapView.frame = CGRect(x: 0,y: customTextView.frame.height,width: self.frame.width,height: self.frame.height - customTextView.frame.height)
        
        if !locationString.isEmpty
        {
            let location = locationString
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(location) {(placeMarks, error) in
                
                if let placeMark = placeMarks?.first, let location = placeMark.location
                {
                    let mark = MKPlacemark(placemark: placeMark)
                    
                    var region:MKCoordinateRegion = self.mapView.region
                    region.center = location.coordinate
                    region.span.latitudeDelta/=8.0
                    region.span.longitudeDelta/=8.0
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.addAnnotation(mark)
                    
                }
                
            }
        }
        self.addSubview(mapView)

        submitButtom.frame = CGRect(x: self.frame.width/2 - 50,y: customTextView.frame.height/4 - 20 ,width:100,height: 40)
        submitButtom.backgroundColor = UIColor.lightText
        submitButtom.setTitle("Submit", for: .normal)
        submitButtom.setTitleColor(UIColor.cyan, for: .normal)
        submitButtom.addTarget(self, action: #selector(self.submitAction(sender:)), for: .touchUpInside)
        self.addSubview(submitButtom)
        self.bringSubview(toFront: submitButtom)
    
    }
    
    @objc private func submitAction(sender: UIButton)
    {
        
    }

}
