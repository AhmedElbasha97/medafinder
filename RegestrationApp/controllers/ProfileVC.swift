//
//  ProfileVC.swift
//  RegestrationApp
//
//  Created by ahmedelbasha on 4/29/20.
//  Copyright © 2020 ahmedelbasha. All rights reserved.
//

import UIKit
import SQLite
class ProfileVC: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactNumLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutBTN: UIButton!
    let database = DatabaseManager.shared()
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBTN.layer.cornerRadius = 25
            
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.purple
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgrond")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
       database.usersDbConnection()
       database.listUsersTable()
        loadData()
    }
    func loadData(){
   let user = database.getUserData()
        profileImageView.image = UIImage(data: user!.image )
        nameLabel.text = user!.email
        emailLabel.text = user!.name
        contactNumLabel.text = user!.contactNum
        genderLabel.text = user!.gender
        addressLabel.text = user!.address
    }
    
    
    
    @IBAction func logOutBtnPressed(_ sender: UIButton) {
        animationForButtons(sender: sender)
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isSignedIn)
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isSignedUp)
        let signUpVC = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.signUpVC) as! SignUpVC
        self.present(signUpVC, animated: true, completion: nil)
    }
}
