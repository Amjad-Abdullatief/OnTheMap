
//
//  API.swift
//  OnTheMap
//
//  Created by AMJAD - on 14/03/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import Foundation
import UIKit


class API : NSObject {
    private static var userInfo = UserInfo()
    private static var student = StudentLocation()
    var accountKey: String = ""
    var createdAt : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var mapString : String = ""
    var mediaURL : String = ""
    var objectId : String = ""
    var uniqueKey : String = ""
    var updatedAt : String = ""
    
    static let shared = API()

    static func login (_ email : String!, _ password : String!, completion: @escaping (Bool, String, Error?)->()) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                
                completion (false, "", error)
                return
            }
            
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion (false, "", statusCodeError)
                return
            }
            
            if statusCode >= 200  && statusCode < 300 {
                
                
                let range = 5..<data!.count
                let newData = data?.subdata(in: range) /* subset response data! */
                print (String(data: newData!, encoding: .utf8)!)
                
                
                let loginJsonObject = try! JSONSerialization.jsonObject(with: newData!, options: [])
                let loginDictionary = loginJsonObject as? [String : Any]
                let accountDictionary = loginDictionary? ["account"] as? [String : Any]
                let uniqueKey = accountDictionary? ["key"] as? String ?? " "
                completion (true, uniqueKey, nil)
            } else {
                
                completion (false, "", nil)
            }
        }
        
        task.resume()
    }
    
   static func getAllLocations (completion: @escaping ([StudentLocation]?, Error?) -> ()) {
        var request = URLRequest (url: URL (string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) {data, response, error in
            if error != nil {
                completion (nil, error)
                return
            }
            
            //            print (String(data: data!, encoding: .utf8)!)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (nil, statusCodeError)
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])
                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
                let resultsArray = jsonDictionary["results"] as? [[String:Any]]
                guard let array = resultsArray else {return}
                let dataObject = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                let studentsLocations = try! JSONDecoder().decode([StudentLocation].self, from: dataObject)
                
                completion (studentsLocations, nil)
            }
        }
        
        task.resume()
    }


    
    func postStudent(_ student: StudentLocation, completionHandlerPost: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let encoder = JSONEncoder()
        let jsonData: Data
        do {
            jsonData = try encoder.encode(student)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completionHandlerPost(false, error?.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandlerPost(false, error?.localizedDescription)
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                completionHandlerPost(false, error?.localizedDescription)
                return
            }
            do {
                let decoder = JSONDecoder()
                let decodedData = try! decoder.decode(StudentLocation.self, from: data)
                completionHandlerPost(true, nil)
            } catch let error {
                print(error.localizedDescription)
                return
            }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    
    
    func getUser(completionHandlerForGet: @escaping (_ success: Bool, _ student: StudentLocation?, _ errorString: String?) -> Void){
        if accountKey == nil {
            completionHandlerForGet(false, nil, "could not find account key")
            return
        }
        let urlString = "https://onthemap-api.udacity.com/v1/users/\(accountKey)"
        let url = URL(string: urlString)
        print("account key: \(accountKey)")
        print("url is: \(url!)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error
                completionHandlerForGet(false, nil, error?.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandlerForGet(false, nil, error?.localizedDescription)
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                completionHandlerForGet(false, nil, error?.localizedDescription)
                return
            }
            print(String(data: data, encoding: .utf8))
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print("--------------")
            print(String(data: newData, encoding: .utf8))
            do {
                let decoder = JSONDecoder()
                let decodedData = try! decoder.decode(StudentLocation.self, from: newData)
                var student = StudentLocation()
                student.firstName = decodedData.firstName
                student.lastName = decodedData.lastName
                student.uniqueKey = self.accountKey
                completionHandlerForGet(true, student, nil)
            } catch let error {
                print(error.localizedDescription)
                completionHandlerForGet(false, nil, error.localizedDescription)
                return
            }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }

    static func logout(){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            func dispalyError(_ error: String){
                print(error)
            }
            guard (error == nil) else {
                return
            }
            guard let data = data else {
                dispalyError("there is no data")
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                dispalyError("the status code > 2xx")
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
        }
        task.resume()
    }
    
    
   

}

extension StudentsTableView {
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
                    StudentLocation.studentsList.removeAll()
                    for blog in blogs {
                        //var donation=Donations()
                        self.students = self.students.getData(dataJson: blog)
                        StudentLocation.studentsList.append(self.students)
                    }
                }
            } catch {
                print("##Error deserializing JSON: \(error)")
                let alertController = UIAlertController(title: "", message: "No data was returned by the request", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            self.showNames()
        }
        task.resume()
    }
    func showNames(){
        //looing through all the elements of the array
        DispatchQueue.main.async {
            self.tableView.dataSource=self
            self.tableView.reloadData()
            
        }
    }
    
}
