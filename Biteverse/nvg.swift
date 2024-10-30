//
//  nvg.swift
//  Biteverse
//
//  Created by Siripoom Jaruphoom on 2/12/23.
//

import UIKit

class nvg: UINavigationController {
    
    var username=""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("user:@\(username)")
    }

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let modevc=segue.destination as? modeSelcetionVC
        modevc?.username=username
    }
   

}
