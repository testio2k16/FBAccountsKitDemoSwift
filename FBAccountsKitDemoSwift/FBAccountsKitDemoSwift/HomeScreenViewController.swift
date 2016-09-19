//
//  HomeScreenViewController.swift
//  FBAccountsKitDemoSwift
//
//  Created by testio2k16 on 9/17/16.
//  Copyright © 2016 testio2k16. All rights reserved.
//

import Foundation
import UIKit
import AccountKit

class HomeScreenViewController: UIViewController {
    
    var accKit: AKFAccountKit!
    
    @IBOutlet weak var accIDLabel: UILabel!
    @IBOutlet weak var signInTypeLabel: UILabel!
    @IBOutlet weak var signInCredentialLabel: UILabel!

    override func viewDidLoad() {
        self.title = "FBAccountsKitDemoSwift"
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex:0xff7200)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(netHex:0xFFFFFF)]
        if accKit == nil {
            
            self.accKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
            accKit.requestAccount{
                (account, error) -> Void in
                
                print(error)
                self.accIDLabel.text = "User Account Id: \((account?.accountID)!)"
                //Check signin with Phone Number or Email
                if account?.phoneNumber?.phoneNumber != nil {
                    self.signInTypeLabel.text = "Sign In Type: Phone Number"
                    self.signInCredentialLabel.text = "Phone Number: \((account!.phoneNumber?.stringRepresentation())!)"
                }
                
                if account?.emailAddress?.characters.count > 0 {
                    self.signInTypeLabel.text = "Sign In Type: Email Id"
                    self.signInCredentialLabel.text = "Email Id: \((account!.emailAddress)!)"
                }
            }
            
        }
    }
    
    @IBAction func logoutOnClick(sender: AnyObject) {
        accKit.logOut()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}
