//
//  ViewController.swift
//  ValidMobile
//
//  Created by Ludwing Badillo on 8/24/19.
//  Copyright © 2019 Ludwing Badillo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passwordName: UITextField!
    @IBOutlet weak var responseText: UITextView!
    @IBOutlet weak var button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        passwordName.delegate = self
        button.isEnabled = false
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func enableButtonFunc() {
        let tmp = userName.text
        let tmp2 = passwordName.text
        if(tmp?.isEmpty)! || (tmp2?.isEmpty)!{
            button.isEnabled = false
            button.alpha = 0.5
        }else {
            button.isEnabled =  true
            button.alpha = 1
        }
    }
    
    
    @IBAction func userNameChanged(_ sender: UITextField) {
       enableButtonFunc()
    }
    
    @IBAction func passwordCahnged(_ sender: UITextField) {
        enableButtonFunc()
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        let myUrl = URL(string: "http://localhost:8080/api/authenticate");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let newRequest: [String: Any] = ["password": passwordName.text!, "username": userName.text!]
        let jsonRequest: Data
        do {
            jsonRequest = try JSONSerialization.data(withJSONObject: newRequest, options: [])
            request.httpBody = jsonRequest
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil
            {
                print("error=\(error!)")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    // Now we can access value of First Name by its key
                    let responseValue = parseJSON["id_token"] as? String
                    if (responseValue != nil){
                        DispatchQueue.main.async {
                            self.responseText.text = "Your token is \(String(describing: responseValue))"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.responseText.text = "Bad User Name or Password"
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }


}

extension ViewController : UITextFieldDelegate {
    func  textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

