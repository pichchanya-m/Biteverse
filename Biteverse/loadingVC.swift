//
//  loadingVC.swift
//  Biteverse
//
//  Created by a. on 2/12/2566 BE.
//

import UIKit

class loadingVC: UIViewController {
    
   
   
    var foodName=[String]()
    var foodInfo=[String]()
    var resultArray=[[String]]()
    var lang=String()
    var imgRun: [UIImage] = []
    @IBOutlet weak var imgView: UIImageView!
 
    
    @IBOutlet weak var spinnerr: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
  // progress view daft
    var timer: Timer?
       var keepTime: TimeInterval = 0
       var duration: TimeInterval = 3
   
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerr.startAnimating()
        
          DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                      self.spinnerr.stopAnimating()
                      self.performSegue(withIdentifier: "result", sender: self)
                  }
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                   guard let self = self else { return }

                   self.keepTime += timer.timeInterval
                   let progress = Float(self.keepTime / self.duration)
                   self.progressView.progress = progress //progress ตามเวลา

                   if self.keepTime >= self.duration {
                       timer.invalidate() //stop timer
                       self.spinnerr.stopAnimating()
                       imgView.stopAnimating()
                   }
               }
        
        for i in 1...5 {
            if let image = UIImage(named: "cat\(i)") {
                imgRun.append(image)
            }
        }
        
       imgView.animationImages = imgRun
        imgView.animationDuration = 1.0
        imgView.animationRepeatCount = 0
        imgView.startAnimating()
              }
    

      
      
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        let resultVC=segue.destination as! result
        resultVC.foodInfo=foodInfo
        resultVC.foodName=foodName
        resultVC.resultArray=resultArray
        resultVC.lang=lang
    }


}
