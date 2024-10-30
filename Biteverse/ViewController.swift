//
//  ViewController.swift
//  Biteverse
//
//  Created by Siripoom Jaruphoom on 3/12/23.
//

import UIKit

class ViewController: UINavigationController {
    
    var usernamE=String()
    var lang=String()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("nvg = \(usernamE)")
        print("VC:\(lang)")
        
        if let modeVc = self.topViewController as? modeSelcetionVC {
            modeVc.username = usernamE
            modeVc.lang=lang
            print("complete")
        }
        else {
            print("failed")
        }

        // Do any additional setup after loading the view.
    }
    
   
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
  

}
