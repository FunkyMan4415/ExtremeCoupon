//
//  LoginRegisterViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 18.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginRegisterViewController: UIViewController {
    
    @IBOutlet var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var loginRegisterButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "loginViewController") 
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = UserDefaults.standard.object(forKey: "userId") {
            performSegue(withIdentifier: "HomeSegue", sender: true)
        }
    }
    
    @IBAction func segmentControllTapped(_ sender: UISegmentedControl) {
        loginRegisterButton.setTitle(sender.titleForSegment(at: sender.selectedSegmentIndex), for: .normal)
    }
    
    
    @IBAction func loginRegisterButtonTapped(_ sender: RoundedButton) {
        guard let email = emailTextField.text, !email.isEmpty else {return }
        guard let password = passwordTextField.text, !password.isEmpty else {return}
        
        
        if sender.titleLabel?.text == "Login" {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    if let code = AuthErrorCode(rawValue: error._code) {
                        switch code {
                        case .invalidEmail:
                            Utility.showAlertController(for: self, with: "Ungültige Email", and: "Diese E-Mail Adresse ist ungültig")
                        case .wrongPassword:
                            Utility.showAlertController(for: self, with: "Falsches Password", and: "Das eingegebene Passwort ist nicht korrekt")
                        default:
                            break
                        }
                        print("ERROR: \(#function): \(error.localizedDescription)")
                    }
                }else {
                    if let user = user {
                        UserDefaults.standard.set(user.user.uid, forKey: "userId")
                        self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                    }
                }
                
                
            }
            
        } else {

            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    if let code = AuthErrorCode(rawValue: error._code) {
                        switch code {
                        case .emailAlreadyInUse:
                            Utility.showAlertController(for: self, with: "Email bereits in Benutzung", and: "Die E-Mail Adresse ist bereits in Benutzung")
                        case .weakPassword:
                            Utility.showAlertController(for: self, with: "Schwaches Passwort", and: "Das Passwort das du benutzt ist zu schwach")
                        default:
                            break
                        }
                        print("ERROR: \(#function): \(error.localizedDescription)")
                    }
                    
                } else {
                    if let user = result {
                        UserDefaults.standard.set(user.user.uid, forKey: "userId")
//                        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: ActionCodeSettings().self , completion: nil)
                        self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                    }
                }
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
