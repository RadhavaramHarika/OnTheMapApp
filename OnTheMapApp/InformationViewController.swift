//
//  InformationViewController.swift
//  OnTheMapApp
//
//  Created by radhavaram harika on 12/22/16.
//  Copyright © 2016 Practise. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var informationView: InformationView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.view.addSubview(InformationView(frame: informationView.frame))
    }
   

}

