//
//  StudentsTableView.swift
//  OnTheMap
//
//  Created by AMJAD - on 13/03/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import UIKit

class StudentsTableView: HeaderVC , UITableViewDataSource , UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    
//    var studentsList = [StudentLocation()]
    var students = StudentLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        getJsonFromUrl()
        tableView.rowHeight = 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        print("count return : \(StudentLocation.studentsList.count)")
        return StudentLocation.studentsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! studentTableViewCell
        
        var student : StudentLocation = StudentLocation.studentsList[indexPath.row]
        print("student name : \(student.firstName)")
        
        cell.name.text = "\(student.firstName ?? " ")  \(student.lastName ?? " ")"
        cell.mediaURL.text = student.mediaURL
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = StudentLocation.studentsList[(indexPath).row].mediaURL
        print("url is: \(String(describing: url))")
        if let url = URL(string: url ?? " ")
        {
            UIApplication.shared.open(url)
        }
        
    }
}
    




