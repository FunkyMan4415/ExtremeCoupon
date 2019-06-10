//
//  ProfileViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 19.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit
import FirebaseAuth

struct Profile {
    var title : String
    var description : String
    var points: String
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var mocked = [Profile]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ProfileCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ReusableCells.profileCell)
        tableView.dataSource = self
        tableView.delegate = self
        
        
        mockupData()
        
    }
    
    
    private func mockupData() {
        let profile1 = Profile(title: "eingereichte Coupons", description: "insgesamt", points: "120")
        let profile2 = Profile(title: "positiv bewertet", description: "durchschnittlich", points: "80 %")
        let profile3 = Profile(title: "negativ bewertet", description: "durchschnittlich", points: "12 %")
        mocked.append(profile1)
        mocked.append(profile2)
        mocked.append(profile3)
        
        
    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error")
        }
        
        if let _ = UserDefaults.standard.object(forKey: "userId") {
            UserDefaults.standard.set(nil, forKey: "userId")
            UserDefaults.standard.set(false, forKey: "onboardingCompleted")
            UserDefaults.standard.set(false, forKey: "anonymousLogin")
            
            self.tabBarController?.view.removeFromSuperview()
            
//            dismiss(animated: true, completion: nil)
        }
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCells.profileCell, for: indexPath) as? ProfileTableViewCell {
            cell.titleLabel.text = mocked[indexPath.row].description
            cell.descriptionLabel.text = mocked[indexPath.row].title
            cell.scoreLabel.text = mocked[indexPath.row].points
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
