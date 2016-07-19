//
//  ViewController.swift
//  MyFacebookSample
//
//  Created by Jayant on 19/07/16.
//  Copyright © 2016 Jayant. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var btnFacebook: FBSDKLoginButton!
    @IBOutlet var ivUserProfileImage: UIImageView!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblFirstName: UILabel!
    @IBOutlet var lblLastName: UILabel!
    @IBOutlet var lblTimeZone: UILabel!
    @IBOutlet var lblAge: UILabel!
    
    

    //    MARK: ViewLifeCycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureFacebook()
    }

    //    MARK: FBSDKLoginButtonDelegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil {
            FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"id, name, email, first_name, last_name,  age_range, link, gender, locale, timezone, updated_time, verified, picture.type(large)"]).startWithCompletionHandler { (connection, result, err) -> Void in
            
                if err == nil {
                    let strFirstName: String = (result.objectForKey("first_name") as? String)!
                    let strLastName: String = (result.objectForKey("last_name") as? String)!
                    let strEmail: String = (result.objectForKey("email") as? String)!
                    let strTimeZone: String = (result.objectForKey("locale") as? String)!
                    let strGender: String = (result.objectForKey("gender") as? String)!
                    let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                    
                    self.lblFirstName.text  = "First Name: \(strFirstName)"
                    self.lblLastName.text   = "Last Name: \(strLastName)"
                    self.lblEmail.text      = "EMail: \(strEmail)"
                    self.lblTimeZone.text   = "Locale: \(strTimeZone)"
                    self.lblAge.text        = "Gender: \(strGender)"

                    self.ivUserProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        ivUserProfileImage.image    = nil
        lblFirstName.text           = ""
        lblLastName.text            = ""
        lblAge.text                 = ""
        lblTimeZone.text            = ""
        lblEmail.text               = ""
    }
    
    //    MARK: Other Methods
    
    func configureFacebook()
    {
        btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
        btnFacebook.delegate = self
    }
}

