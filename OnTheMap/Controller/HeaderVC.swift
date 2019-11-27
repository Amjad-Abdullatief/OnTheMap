//
//  HeaderVC.swift
//  OnTheMap
//
//  Created by AMJAD - on 14/03/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import UIKit

class HeaderVC: UIViewController {

    var studentLocation: [StudentLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocation(_:)))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refresh(_:)))
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout(_:)))
        self.navigationItem.rightBarButtonItems = [add , refresh]
        self.navigationItem.leftBarButtonItem = logout
    }
    
    @objc private func addLocation(_ sender: Any){
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationNC") as! UINavigationController
        self.present(mapVC, animated: true, completion: nil)
    }
    
    @objc private func refresh(_ sender: Any){
        API.getAllLocations { (result, error) in
            guard let result = result else {
                 self.showAlert(title: "Error", message: "No internet connection found")
                return
            }
            guard result.count != 0 else{
                self.showAlert(title: "Error", message: "No pins found")
                return
            }
            self.studentLocation = result
        }
    }
    
     func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }


    
    @objc private func logout(_ sender: Any){
        API.logout()
        self.dismiss(animated: true, completion: nil)
    }
    

}
