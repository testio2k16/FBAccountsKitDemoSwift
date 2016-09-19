//
//  ViewController.swift
//  FBAccountsKitDemoSwift
//
//  Created by testio2k16 on 9/16/16.
//  Copyright © 2016 testio2k16. All rights reserved.
//

import UIKit
import AccountKit

class ViewController: UIViewController {
    //variables
    var accKit: AKFAccountKit!
    
    //IBOutlets
    @IBOutlet var phnoBtn: UIButton!
    @IBOutlet var emailBtn: UIButton!
    
    //IBActions
    //sigin with Phone Number
    @IBAction func phnoBtnOnClick(sender: AnyObject) {
        let inputState: String = NSUUID().UUIDString
        let viewController:AKFViewController = accKit.viewControllerForPhoneLoginWithPhoneNumber(nil, state: inputState)  as! AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        self.presentViewController(viewController as! UIViewController, animated: true, completion: nil)
    }
    
    //signin with Email Id
    @IBAction func emailBtnOnClick(sender: AnyObject) {
        let inputState: String = NSUUID().UUIDString
        let viewController: AKFViewController = accKit.viewControllerForEmailLoginWithEmail(nil, state: inputState)  as! AKFViewController
        self.prepareLoginViewController(viewController)
        self.presentViewController(viewController as! UIViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phnoBtn.addBorder(phnoBtn)
        emailBtn.addBorder(emailBtn)
        //initially accKit is set to nil
        if accKit == nil {
            self.accKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Check if the user is already logged in - if true - show the home screen
        if (accKit.currentAccessToken != nil) {
            accKit.requestAccount{
                (account, error) -> Void in
                print("vals \(account?.accountID)")

            }
            dispatch_async(dispatch_get_main_queue(), {
            let mySB = UIStoryboard(name: "Main", bundle: nil)
            let myVC = mySB.instantiateViewControllerWithIdentifier("HomeScreenViewController") as! HomeScreenViewController
            let myNC = UINavigationController(rootViewController: myVC) 

            self.presentViewController(myNC, animated: false, completion: nil)
            
            })
        }
    }
}

extension ViewController: AKFViewControllerDelegate{
    func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self
        loginViewController.advancedUIManager = nil
        //setting custom theme
        let theme:AKFTheme = AKFTheme.outlineThemeWithPrimaryColor(UIColor(netHex:0xff7200), primaryTextColor: UIColor(white: 1, alpha: 1.0), secondaryTextColor: UIColor(white: 0.3, alpha: 1.0), statusBarStyle: .Default)
        loginViewController.theme = theme
    }
    
    func viewController(viewController: UIViewController!, didCompleteLoginWithAccessToken accessToken: AKFAccessToken!, state: String!) {
        print("Login complete with AccessToken")
    }
    
    func viewController(viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        print("Login complete with AuthorizationCode")
    }
    
    func viewController(viewController: UIViewController!, didFailWithError error: NSError!) {
        print("error \(error)")
    }
    
    func viewControllerDidCancel(viewController: UIViewController!) {
        print("login cancelled")
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIButton {
    func addBorder(btn:UIButton){
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.whiteColor().CGColor
    }
}

