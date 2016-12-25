//
//  ViewController.swift
//  OnTheMapApp
//
//  Created by radhavaram harika on 12/17/16.
//  Copyright © 2016 Practise. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
         super.viewWillAppear(animated)
        setTextFieldProperties(textField: userNameTextField)
        setTextFieldProperties(textField: passwordTextField)
    }
    
    func setTextFieldProperties(textField: UITextField)
    {
        textField.delegate = self
        textField.keyboardType = UIKeyboardType.default
        textField.textAlignment = NSTextAlignment.natural
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }


    @IBAction func facebookLoginPressed(_ sender: Any) {
        
    }
    
    @IBAction func loginPressed(_ sender: Any)
    {
        if Reachability.isConnectedToNetwork()
        {
            UdacityClient.shareInstance().getSessionID(userName: userNameTextField.text!, password: passwordTextField.text!) {(results,error) in
                
                if error == nil
                {
                    DispatchQueue.main.async {
                        let mapVc = self.storyboard?.instantiateViewController(withIdentifier: "UsersTabViewController") as! UITabBarController
                        self.present(mapVc, animated: true, completion: nil)
                    }
                    
                }
                else
                {
                    self.createAlertViewController(title: "On The Map", message: (error?.localizedDescription)!, buttonTitle: "Ok")
                }
            }
        }
        else
        {
            createAlertViewController(title: "On The Map", message: "Make sure yor device is connected to internet", buttonTitle: "Ok")
            
        }
        
        
    }

    @IBAction func signUpPressed(_ sender: Any)
    {
        let app = UIApplication.shared
        app.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!, options: [:], completionHandler: nil)
    }
    
    func createAlertViewController(title:String, message: String, buttonTitle:String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style:UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

