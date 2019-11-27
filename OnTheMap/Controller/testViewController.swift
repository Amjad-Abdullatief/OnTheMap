//
//  testViewController.swift
//  OnTheMap
//
//  Created by AMJAD - on 17/03/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import UIKit

class testViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    var studentsList = [StudentLocation()]
    var students = StudentLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJsonFromUrl()
        name.text = students.firstName
        // Do any additional setup after loading the view.
    }
    
    func getJsonFromUrl(){
        print("##getJsonFromUrl open")
        print("##performPostRequest open")
        
        let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("##URLSession open")
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let blogs = json["results"] as? [[String: Any]] {
                    //                    print("##URLSession blogs ")
//                    self.studentsList.removeAll()
                    for blog in blogs {
                        //var donation=Donations()
                        self.students = self.students.getData(dataJson: blog)
                        //                        if let name = blog["Name"] as? String {print("##Name : \(name)")}
                        
                        print("##firstName = \(self.students.firstName)")
                        
                        
                        self.studentsList.append(self.students)
                        
                    }
                }
            } catch {
                print("##Error deserializing JSON: \(error)")
            }
            
        }
        task.resume()
        
        
    }
    

}
