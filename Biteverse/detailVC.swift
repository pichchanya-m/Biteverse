//
//  detailVC.swift
//  Biteverse
//
//  Created by Siripoom Jaruphoom on 1/12/23.
//

import UIKit

class detailVC: UIViewController {
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbCate: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbArea: UILabel!
    @IBOutlet weak var imgDetailed: UIImageView!
    var name=""
    var detail:[String]=[]
    var lang=String()
    
 
    @IBAction func backToMenu(_ sender: Any) {
        if let mainMenuVc = self.navigationController?.viewControllers.first(where: { $0.restorationIdentifier == "mainView" }) {
                self.navigationController?.popToViewController(mainMenuVc, animated: true)
            } else {
                print("Main menu view controller not found in the navigation stack.")
            }
    }
    
    @IBOutlet weak var lbC: UILabel!
    @IBOutlet weak var lbOC: UILabel!
    @IBOutlet weak var lbP: UILabel!
    @IBOutlet weak var lbZ: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbName.text=name
        lbPrice.text="\(detail[0]) ฿"
        lbCate.text=detail[1]
        lbTime.text=detail[3]
        lbArea.text=detail[2]
        imgDetailed.image=UIImage(named: detail[6])
        imgDetailed.layer.cornerRadius=9.0
        overrideUserInterfaceStyle = .light
        
        if lang=="th" {
            lbC.text="ประเภท :"
            lbZ.text="บริเวณ :"
            lbOC.text="เวลาเปิด - ปิด :"
            lbP.text="ราคา :"
        }
    }
    
    @IBOutlet weak var desBtn: UIButton!
    @IBOutlet weak var backmenuBtn: UIButton!
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "data2" {
                if let mapViewController = segue.destination as? mapRes {
                    mapViewController.latitude = Double(detail[5]) ?? 0.0
                    mapViewController.longitude = Double(detail[4]) ?? 0.0
                    mapViewController.annotationTitle = name
                    mapViewController.lang=lang
                }
            }
    }
    
    
    }
  


