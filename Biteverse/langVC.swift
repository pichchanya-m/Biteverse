//
//  langVC.swift
//  Biteverse
//
//  Created by Siripoom Jaruphoom on 3/12/23.
//

import UIKit
import CoreImage

class langVC: UIViewController {
    
    var lang=""
    var click=0

    @IBOutlet weak var imgperson: UIImageView!
    @IBAction func enTapped(_ sender: Any) {
        click+=1
        if click%2 != 0 {
            if let oriTh=UIImage(named: "th") {
                let greyth = convertImageToGrayScale(image: oriTh)
                imgTh.image=greyth
                imgTh.alpha=0.5
                thBtn.isEnabled=false
                lang="en"
                imgperson.image=UIImage(named: "uk")
                
            }} else {
                imgTh.image=UIImage(named: "th")
                imgTh.alpha=1
                thBtn.isEnabled=true
                lang=""
                imgperson.image=nil
            }
    }
    @IBAction func thTapped(_ sender: Any) {
        click+=1
        if click%2 != 0 {
            if let oriEn=UIImage(named: "en") {
                let greyen = convertImageToGrayScale(image: oriEn)
                imgEn.image=greyen
                imgEn.alpha=0.5
                enBtn.isEnabled=false
                lang="th"
                imgperson.image=UIImage(named: "thai")
                
            }} else {
                imgEn.image=UIImage(named: "en")
                imgEn.alpha=1
                enBtn.isEnabled=true
                lang=""
                imgperson.image=nil
            }
    }
    @IBAction func startTapped(_ sender: Any) {
        if lang.isEmpty {
            showAlert()
        }
        
        let user = storyboard?.instantiateViewController(withIdentifier: "user") as? userNameVC
        user!.Lang=lang
        user?.modalPresentationStyle = .fullScreen
        user?.modalTransitionStyle = .flipHorizontal
        present(user!, animated: true)
    }
        
        func showAlert() {
               let alert = UIAlertController(title: "Alert !", message: "Select a language first", preferredStyle: .alert)
            let titleAttributedString = NSAttributedString(string: "Alert !", attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.systemRed
                ])
                alert.setValue(titleAttributedString, forKey: "attributedTitle")

               let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
               alert.addAction(ok)
               present(alert, animated: true, completion: nil)
           }

    
    @IBOutlet weak var enBtn: UIButton!
    @IBOutlet weak var thBtn: UIButton!
    @IBOutlet weak var imgEn: UIImageView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var imgTh: UIImageView!
    
    func convertImageToGrayScale(image: UIImage) -> UIImage? {
        if let cgImage = image.cgImage {
            let ciImage = CIImage(cgImage: cgImage)
            
            if let filter = CIFilter(name: "CIPhotoEffectMono") {
                filter.setValue(ciImage, forKey: kCIInputImageKey)
                
                if let outputCIImage = filter.outputImage {
                    
                    let context = CIContext(options: nil)
                    if let cgImageResult = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
                        
                        let resultImage = UIImage(cgImage: cgImageResult)
                        return resultImage
                    }
                }
            }
        }
        
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        imgTh.image=UIImage(named: "th")
        imgEn.image=UIImage(named: "en")
        imgEn.layer.cornerRadius=10
        imgTh.layer.cornerRadius=10
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
