//
//  result.swift
//  Biteverse
//
//  Created by Siripoom Jaruphoom on 30/11/23.
//

import UIKit

class result: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "result", for: indexPath) as! resultTVC
        
        cell.lbName.text=foodName[indexPath.row]
        cell.imgResult.image=UIImage(named: resultArray[indexPath.row][6])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var resultArray:[[String]]=[]
    var foodName=[String]()
    var foodInfo=[String]()
    var lang=String()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        overrideUserInterfaceStyle = .light
        
        let backButton = UIBarButtonItem(
                    title: "< Back to Menu",
                    style: .plain,
                    target: self,
                    action: #selector(backToMenu)
                )
                navigationItem.leftBarButtonItem = backButton
        
    uiAlert()
            }

            @objc func backToMenu() {

                if let menuViewController = navigationController?.viewControllers.first(where: { $0 is menu }) {
                    navigationController?.popToViewController(menuViewController, animated: true)
                }
            }
    
    func uiAlert() {
         var titleKey = "find food !"
         var messageKey = "we find food that you preferred😋"
         
         if lang == "th" {
             titleKey = "เจออาหารแล้ว !"
             messageKey = "พบอาหารที่คุณต้องการ😋"
         }
         
         let alertController = UIAlertController(title: NSLocalizedString(titleKey, comment: ""),
                                                 message: NSLocalizedString(messageKey, comment: ""),
                                                 preferredStyle: .alert)
         
         alertController.setBackgroundColor(color: UIColor.systemGray)
         alertController.view.layer.cornerRadius = 10
         
         present(alertController, animated: true, completion: nil)
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             alertController.dismiss(animated: true, completion: nil)
         }
     }

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let rowClick:Int=self.tableView.indexPathForSelectedRow!.row
        let detail=segue.destination as! detailVC
        detail.name=foodName[rowClick]
        detail.detail=resultArray[rowClick]
        detail.lang=lang
    }
   

}

extension UIAlertController {
    func setBackgroundColor(color: UIColor) {
        if let backgroundSubview = self.view.subviews.first,
           let contentView = backgroundSubview.subviews.first {
            contentView.backgroundColor = color
        }
    }
}
