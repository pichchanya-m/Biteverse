//
//  modeSelcetionVC.swift
//  Biteverse
//
//  Created by Siripoom Jaruphoom on 2/12/23.
//

import UIKit

class modeSelcetionVC: UIViewController {
    
    var username=""
    var lang=String()

    @IBOutlet weak var lbGreeting: UILabel!
    
    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
        super.viewDidLoad()
        if lang=="th" {
            lbGreeting.text="ยินดีต้อนรับ \(username)\nเข้าสู่ Biteverse"
            findFoodbtn.setTitle("ค้นหาอาหาร", for: .normal)
            mapbtn.setTitle("แผนที่ความอร่อย", for: .normal)
        } else {
            lbGreeting.text="Welcome, \(username)\nto Biteverse"}
        print("modeSelectVC:\(lang)")
        
    }
    
    @IBOutlet weak var findFoodbtn: UIButton!
    
    @IBOutlet weak var mapbtn: UIButton!
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let menuVC = segue.destination as? menu
        menuVC?.lang=lang
        
        let mapVC = segue.destination as? mapALL
        mapVC?.lang=lang
    }
  

}
