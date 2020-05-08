//
//  SignInVC.swift
//  RegestrationApp
//
//  Created by ahmedelbasha on 4/29/20.
//  Copyright © 2020 ahmedelbasha. All rights reserved.
//

import UIKit
import SQLite
class SignInVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
      @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var logInLabel: UILabel!
    let database = DatabaseManager.shared()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   addBackBarButtonOnNavigationBar()
        database.usersDbConnection()
        database.listUsersTable()
        for button in buttons{
            button.layer.cornerRadius = 25
        }
    }
    func addBackBarButtonOnNavigationBar() {
        
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.purple
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
    
        
    }
    private func goToProfileScreen() {
        let profileVC = UIStoryboard.init(name: "\(Storyboards.media)", bundle: nil).instantiateViewController(withIdentifier: "\(VCs.mediaTable)") as! MediaTable
        self.present(profileVC, animated: true)
    }
    
    
    @IBAction func lognInBtnPressed(_ sender: UIButton) {
        if isValidEmail(candidate: emailTextField.text ?? ""){
            if validpassword(mypassword: passwordTextField.text ?? ""){
                if database.userExsits(email: emailTextField.text!, password: passwordTextField.text!){
                   
                        if fieldIsNotEmpty(field: emailTextField.text ?? "") && fieldIsNotEmpty(field: passwordTextField.text ?? ""){
                            goToProfileScreen()
                            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isSignedIn)
                            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isSignedUp)
                            let users = database.getUserData()
                            logInLabel.text = "welcome! \(users!.name ?? "")"
                             logInLabel.font = logInLabel.font.withSize(35)
                            sender.flash()
                        }else{
                            showAlert(title: "please in put your data", massage: "field is empty")
                            
                        }
                    }else{
                        showAlert(title: "your password  or your Email is wrong", massage: "please put your password or yuor email in the correct way")
                    }
               
            }else{
                showAlert(title: "password is not valid", massage: "put  the password you entered under rules you have readit in sign up")
            }
        }else{
            showAlert(title: "E-mail is not valid", massage: "please in put avalid email")
        }
            sender.shake()
        
        }
    }
    

