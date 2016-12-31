//
//  UsersTableViewController.swift
//  OnTheMapApp
//
//  Created by radhavaram harika on 12/21/16.
//  Copyright © 2016 Practise. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    var studentLocations = StudentLocations.sharedInstance.studentLocations
    
    @IBOutlet var UsersTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        UsersTableView.delegate = self
//        self.getStudentLocations()
        self.UsersTableView.reloadData()
    }
    
    func setNavigationBar()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",style: UIBarButtonItemStyle.plain,target:self,action: #selector(self.logoutAction))
        let pinButton = UIBarButtonItem(image: UIImage(named: "PinIcon"),style: UIBarButtonItemStyle.plain,target:self,action: #selector(self.pinIconAction))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "RefreshIcon"),style: UIBarButtonItemStyle.plain,target:self,action: #selector(self.refreshAction))
        
        self.navigationItem.rightBarButtonItems = [pinButton,refreshButton]
    }
    
    func getStudentLocations()
    {
            UdacityClient.shareInstance().getStudentLocations(withObjectID: nil) {(results,error) in
                
                if error == nil
                {
                        if let studentResults = results
                        {
                            DispatchQueue.main.async
                            {
                             self.studentLocations = studentResults as! [StudentDetail]
                             self.UsersTableView.reloadData()
                            }
                        }
                }
                else
                {
                    print(error!)
                }
            }
        
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
        self.getStudentLocations()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.studentLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersListCell") as! UsersTableViewCell
        let studentLocation = studentLocations[(indexPath as NSIndexPath).row] as StudentDetail
        
        cell.studentNameLabel.text = "\(studentLocation.firstName ?? "") \(studentLocation.lastName ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let studentLocation = studentLocations[(indexPath as NSIndexPath).row] as StudentDetail
        let urlString = studentLocation.mediaURL!
        let app = UIApplication.shared
        app.open(URL(string: urlString)!, options: [:], completionHandler: nil)

    }


}
