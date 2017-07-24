//
//  ViewController.swift
//  TestingTeam
//
//  Created by Ammad on 21/07/2017.
//  Copyright © 2017 Ammad. All rights reserved.
//

import UIKit
import Alamofire
import RappleProgressHUD

class LoginViewController: UIViewController {
    var apikey : String?
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var apitextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.layer.cornerRadius = 5
        loginView.layer.masksToBounds = true
        LoginButton.layer.cornerRadius = 5
        LoginButton.layer.masksToBounds =  true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginBtnPressed(_ sender: Any) {
        LoginButton.isUserInteractionEnabled = false
        if apitextField.text != "" {
            let attributes = RappleActivityIndicatorView.attribute(style: RappleStyle(rawValue: RappleStyleApple)!, tintColor: .white, screenBG:.init(white: 0.0, alpha: 0.2) , progressBG: .init(white: 0.0, alpha: 0.7), progressBarBG: .lightGray, progreeBarFill: .white)
            RappleActivityIndicatorView.startAnimatingWithLabel("Authenticating...",attributes: attributes)
            let user = apitextField.text!
            let password = "password"
            
            Alamofire.request("https://authenticate.teamwork.com/authenticate.json/\(user)/\(password)")
                .authenticate(user: user, password: password)
                .responseJSON { response in
                    if response.response?.statusCode == 200 {
                        print(response)
                        RappleActivityIndicatorView.stopAnimation()
                        
                        let defaults = UserDefaults.standard
                        defaults.set(true, forKey: "TeamworkLoggedIn")
                        defaults.set(user, forKey: "userapi")
                        DispatchQueue.main.async {
                            defer {self.performSegue(withIdentifier: "gotoActivity", sender: nil) }
                        }
                        
                        //////////
//                        let user = "twp_X8Uw5sYi7NDdb2ekZ4LIERawZRTM"
//                        let password = "password"
//                        
//                        Alamofire.request("https://ammad.teamwork.com/latestActivity.json/\(user)/\(password)")
//                            .authenticate(user: user, password: password)
//                            .responseJSON { response in
//                                print(response)
//                        }
                        ////////
                    }
                    else if response.response?.statusCode == 401 {
                        print("invalid login")
                        RappleActivityIndicatorView.stopAnimation()
                        let alertView = UIAlertController(title: "Authorization Error", message:"Oops! Looks like you had a typo. Re-enter correct API Key.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                            
                        })
                        self.LoginButton.isUserInteractionEnabled = true
                        alertView.addAction(action)
                        self.present(alertView, animated: true, completion: nil)
                    }
            }
        }
        else {
            RappleActivityIndicatorView.stopAnimation()
            LoginButton.isUserInteractionEnabled = true
            let alertView = UIAlertController(title: "Error", message:"API Key is required", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                
            })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
    }
}

