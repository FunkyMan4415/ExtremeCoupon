//
//  LoginRegisterViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 18.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LoginRegisterViewController: UIViewController {
    
    @IBOutlet weak var displayNameTextField: RoundedTextField!
    @IBOutlet var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var loginRegisterButton: RoundedButton!
    
    var emailVerificationViewController = EmailVerificationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayNameTextField.isHidden = false
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let viewController = mainStoryboard.instantiateViewController(withIdentifier: "loginViewController")
//        UIApplication.shared.keyWindow?.rootViewController = viewController
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = UserDefaults.standard.object(forKey: "userId") {
            if let currentUser = Auth.auth().currentUser, !currentUser.isAnonymous {
                if !currentUser.isEmailVerified {
                    self.displayEmailVerificationView()
                }
            }
            performSegue(withIdentifier: "HomeSegue", sender: true)
        } else {
            emailVerificationViewController.view.removeFromSuperview()
        }
    }
    
    @IBAction func segmentControllTapped(_ sender: UISegmentedControl) {
        let title = sender.titleForSegment(at: sender.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        displayNameTextField.isHidden = (title == "Login")
    }
    
    
    @IBAction func loginRegisterButtonTapped(_ sender: RoundedButton) {
        guard let email = emailTextField.text, !email.isEmpty else {return }
        guard let password = passwordTextField.text, !password.isEmpty else {return}
        
        if sender.titleLabel?.text == "Login" {
            SVProgressHUD.show(withStatus: "Wird eingeloggt...")
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
                        UserDefaults.standard.set(false, forKey: "EmailVerification")
                        SVProgressHUD.dismiss()
                        
                        if !user.user.isEmailVerified {
                            self.displayEmailVerificationView()
                        }
                        
                        self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                    }
                }
                
                
            }
            
        } else {
            guard let displayName = displayNameTextField.text, !displayName.isEmpty else {return}
            
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
                        user.user.sendEmailVerification(completion: { (error) in
                            if let error = error {
                                print("error \(error.localizedDescription)")
                            }
                        })
                        
                        UserDefaults.standard.set(user.user.uid, forKey: "userId")
                        UserDefaults.standard.set(false, forKey: "EmailVerification")
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = displayName
                        
                        changeRequest?.commitChanges(completion: { (error) in
                            if let error = error {
                                print("WHOOPS \(error.localizedDescription)")
                            }
                        })
                        
                        self.displayEmailVerificationView()
                        self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                    }
                }
            }
        }
    }
    
    
    @IBAction func anonymousLoginButtonTapped(_ sender: UIButton) {
        Auth.auth().signInAnonymously { (user, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let user = user {
                UserDefaults.standard.set(true, forKey: "anonymousLogin")
                UserDefaults.standard.set(user.user.uid, forKey: "userId")
                self.performSegue(withIdentifier: "HomeSegue", sender: nil)
            }
        }
    }
    
    func displayEmailVerificationView() {
        if let window = UIApplication.shared.keyWindow {
            emailVerificationViewController.view.frame = CGRect(x: 0, y: self.view.bounds.maxY - emailVerificationViewController.view.bounds.height - 60, width: self.view.bounds.width, height: 60)
            
            window.addSubview(emailVerificationViewController.view)
            
            emailVerificationViewController.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(isEmailVerified)))
        }
    }
    
    @objc
    func isEmailVerified() {
        if let currentUser = Auth.auth().currentUser {
            currentUser.reload(completion: nil)
            if currentUser.isEmailVerified {
                emailVerificationViewController.view.removeFromSuperview()
                emailVerificationViewController.removeFromParent()
                UserDefaults.standard.set(true, forKey: "EmailVerification")
            }
        }
    }
}
