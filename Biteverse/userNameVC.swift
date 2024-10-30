//
//  userNameVC.swift
//  Biteverse
//
//  Created by Siripoom Jaruphoom on 2/12/23.
//

import UIKit

class userNameVC: UIViewController {
    
    var userName=""
    var Lang=String()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        overrideUserInterfaceStyle = .light
        userNamePop()
        print("userVc:\(Lang)")
    }

    
   func userNamePop() {
        let alertController = UIAlertController(title: "Welcome to Biteverse!", message: "Enter your username", preferredStyle: .alert)
       alertController.overrideUserInterfaceStyle = .light
       if Lang=="th" {
           alertController.message="โปรดใส่ชื่อของคุณ"
       }
        alertController.addTextField { textField in
            textField.placeholder = "Username"
            textField.autocapitalizationType = .words 
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let username = alertController.textFields?.first?.text {
                self?.userName = username
                print(self?.userName as Any)
                print(username)
                
                if let startVC = self?.storyboard?.instantiateViewController(withIdentifier: "start") as? ViewController {
                    print("startVC instantiated successfully")
                    startVC.usernamE=username
                    startVC.lang=self!.Lang

                    startVC.modalPresentationStyle = .fullScreen
                    self?.present(startVC, animated: true, completion: nil)
                    
                }
            }
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    

    

    // MARK: - Navigation


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        }
//    }
  

}
