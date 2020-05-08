//
//  SignUpVC.swift
//  RegestrationApp
//
//  Created by ahmedelbasha on 4/29/20.
//  Copyright © 2020 ahmedelbasha. All rights reserved.
//

import UIKit
import TextFieldEffects
import SQLite
class SignUpVC: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var contactNumTextField: UITextField!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet var buttons: [UIButton]!
    let database = DatabaseManager.shared()
    var imagePicker: ImagePicker!
    var address: String!
    var comeFromMapScreen: Bool = false
    var image:Data!
    var userr: [String]!
    var userImage: UIImage!
    @IBOutlet weak var addressLabel: UILabel!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttons{
            button.layer.cornerRadius = 25
            
        }
        database.usersDbConnection()
        database.createUsersTable()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.navigationController?.isNavigationBarHidden = true
        genderSwitch.addTarget(self, action: #selector(switchIsChanged), for: .valueChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if comeFromMapScreen{
            addressLabel.text = address
            fullNameTextField.text = userr[0]
            emailTextField.text = userr[1]
            passwordTextField.text = userr[2]
            repasswordTextField.text = userr[2]
            contactNumTextField.text = userr[3]
            profileImageView.image = userImage
            comeFromMapScreen = false
        }
    }
    @objc func switchIsChanged(mySwitch: UISwitch) {
        print(mySwitch.isOn)
    }
    
    
        func genderSwitchCheck() -> String {
        if genderSwitch.isOn {
            return "Female"
        } else {
            return "Male"
        }
    }
   
    private func isValidData() -> Bool {
        if let name = fullNameTextField.text, !name.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let contact = contactNumTextField.text, !contact.isEmpty, let image = profileImageView.image, image != UIImage(named: "user pic") {
           
         self.image = image.jpegData(compressionQuality: 1.0)
         self.image = image.pngData()
         return true
        }
        return false
    }
   
        
    
        
    
    
    
    private func goToSignInScreen() {
        let signInVC = UIStoryboard.init(name: "\(Storyboards.main)", bundle: nil).instantiateViewController(withIdentifier: "\(VCs.signInVC)") as! SignInVC
        self.present(signInVC, animated: true)
    }
    
    
    @IBAction func pickUpYourLocation(_ sender: UIButton) {
      sender.pulsate()
        animationForButtons(sender: sender)
        let MapScreen = UIStoryboard.init(name: "\(Storyboards.main)", bundle: nil).instantiateViewController(withIdentifier: "\(VCs.MapScreen)") as! MapScreen
        MapScreen.user = [fullNameTextField.text!,  emailTextField.text!,  passwordTextField.text!,  contactNumTextField.text!, ]
        MapScreen.userImage = profileImageView.image
        self.present(MapScreen, animated: true)
       
    }
 

    @IBAction func joinBtnPressed(_ sender: UIButton) {
        
        if isValidEmail(candidate: emailTextField.text ?? ""){
            if validpassword(mypassword: passwordTextField.text ?? ""){
                if isValidPhone(phone: contactNumTextField.text ?? ""){
                    if isValidData(){
                       database.insertUsers(dName: fullNameTextField.text!, dEmail: emailTextField.text!, dPassword: passwordTextField.text!, dContactNum: contactNumTextField.text!, dGender: genderSwitchCheck(), dAddress: address!, dPhoto: image)
                     UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isSignedUp)
                        goToSignInScreen()
                        sender.flash()
                    }else{
                        showAlert(title: "some field is missing", massage: "pleaser fill all missing data")
                    }
                }else{
                    showAlert(title: "not a valid phone number", massage: "please put valid phone number")
                }
            }else{
                showAlert(title: "not valid password", massage: "the valid password must contain Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character")
            }
        }else{
            showAlert(title:"it's not valid E-mail", massage: "please put a valid emai")
        }
        sender.shake()
    }
    
    @IBAction func selectPhotoBtnPressed(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
}
extension SignUpVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.profileImageView.image = image
    }
}

