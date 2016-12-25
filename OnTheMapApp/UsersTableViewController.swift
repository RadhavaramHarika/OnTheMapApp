//
//  UsersTableViewController.swift
//  OnTheMapApp
//
//  Created by radhavaram harika on 12/21/16.
//  Copyright © 2016 Practise. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    var studentLocations = [StudentLocation]()
    
    @IBOutlet var UsersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.dismiss(animated: true, completion: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",style: UIBarButtonItemStyle.plain,target:self,action: #selector(self.logoutAction))
        let pinButton = UIBarButtonItem(image: UIImage(named: "PinIcon"),style: UIBarButtonItemStyle.plain,target:self,action: #selector(self.pinIconAction))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "RefreshIcon"),style: UIBarButtonItemStyle.plain,target:self,action: #selector(self.refreshAction))
        
        self.navigationItem.rightBarButtonItems = [pinButton,refreshButton]
        let methodParameters:[String:AnyObject] = [
            UdacityClient.ParameterKeys.limitKey:UdacityClient.ParameterValues.limitValue as AnyObject,
            UdacityClient.ParameterKeys.skipKey:UdacityClient.ParameterValues.skipValue as AnyObject]
        
    }
    
    func getStudentLocations(params: [String:AnyObject])
    {
        UdacityClient.shareInstance().getStudentLocations(parameters: params as [String : AnyObject]) {(results,error) in
            
            if let students = results
            {
                self.studentLocations = students as! [StudentLocation]
                self.UsersTableView.reloadData()

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
                UdacityClient.shareInstance().userID = ""
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func pinIconAction()
    {
        self.dismiss(animated: true, completion: nil)
        let InfoVc = self.storyboard?.instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController
        self.present(InfoVc,animated: true,completion: nil)
        
    }
    
    func refreshAction()
    {
        let methodParams:[String:AnyObject] = [UdacityClient.ParameterKeys.orderKey:UdacityClient.ParameterValues.orderValue as AnyObject]
        self.getStudentLocations(params: methodParams)
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
        let studentLocation = studentLocations[(indexPath as NSIndexPath).row] as StudentLocation
        
        cell.studentNameLabel.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let studentLocation = studentLocations[(indexPath as NSIndexPath).row] as StudentLocation
        let urlString = studentLocation.mediaURL!
        let app = UIApplication.shared
        app.open(URL(string: urlString)!, options: [:], completionHandler: nil)

    }


}
