import UIKit

class menu: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    var loading=loadplist()
    var prices=[String]()
    var cates=[String]()
    var area="all"
    var price="all"
    var cate="all"
    var click=0
    var lang=String()

    
    @IBOutlet weak var clearSwitch: UISwitch!
    
    @IBAction func clearTapped(_ sender: Any) {
        
        priceTxt.text=""
        cateTxt.text=""
        price="all"
        cate="all"
        area="all"
        clearSwitch.isOn=true
        
        let allButtonsEnabled = [uniBtn, g2Btn, ssBtn, g5Btn].allSatisfy { $0?.isEnabled == true }
        if allButtonsEnabled==false {
            enableAllButtons()
            print(click)
            click+=1}
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pricePicker {
            return prices.count
        } else if pickerView == catePicker {
            return cates.count
        }
        return 0
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == pricePicker {
                return prices[row]
            } else if pickerView == catePicker {
                return cates[row]
            }
            return nil
            }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pricePicker {
            if prices[row]=="select price range"||prices[row]=="เลือกช่วงราคา" {
                price="all"
                priceTxt.text=""
            } else {
                priceTxt.text=prices[row]
                price=prices[row]
            }
            priceTxt.resignFirstResponder()
        } else if pickerView==catePicker{
            if cates[row] == "select categories" || cates[row] == "เลือกประเภท" {
                cate="all"
                cateTxt.text=""
            } else {
                cate=cates[row]
                cateTxt.text=cates[row]
            }
            cateTxt.resignFirstResponder()
        }
    }
    
    @IBAction func catetapped(_ sender: Any) {
        catePicker.isHidden=false
        print("show cate")
    }
    @IBAction func pricetapped(_ sender: Any) {
        pricePicker.isHidden=false
        print("show price")
    }
    @IBAction func g5tapped(_ sender: Any) {
        if lang=="en" {
            handleButtonClick(area: "gate 5", button: g5Btn)
        } else {
            handleButtonClick(area: "ประตู 5", button: g5Btn)
        }
    }
    @IBAction func g2tapped(_ sender: Any) {
        if lang=="en" {
            handleButtonClick(area: "gate 2", button: g2Btn)
        } else {
            handleButtonClick(area: "ประตู 2", button: g2Btn)
        }
    }
    @IBAction func sstapped(_ sender: Any) {
        if lang=="en" {
            handleButtonClick(area: "saen saep side", button: ssBtn)
        } else {
            handleButtonClick(area: "หลังคลองแสนแสบ", button: ssBtn)
        }
    }
    @IBAction func unitapped(_ sender: Any) {
        if lang=="en" {
            handleButtonClick(area: "in uni", button: uniBtn)
        } else {
            handleButtonClick(area: "ในมหาลัย", button: uniBtn)
        }
    }
    
    func handleButtonClick(area: String, button: UIButton) {
        click += 1
        
        if click % 2 != 0 {
            self.area = area
            disableButtons(except: button)
        } else {
            self.area = "all"
            enableAllButtons()
        }
        print(self.area)
    }

    func disableButtons(except buttonToEnable: UIButton?) {
        [uniBtn, g2Btn, ssBtn, g5Btn].forEach { button in
            button.isEnabled = (button == buttonToEnable)
        }
    }
    func enableAllButtons() {
        [uniBtn, g2Btn, ssBtn, g5Btn].forEach { button in
            button.isEnabled = true
        }
    }

    
    @IBAction func startTapped(_ sender: Any) {
        
        let loading = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "load") as! loadingVC

        var result2dim:[[String]]=[]
        var keys:[String]=[]
        
        for (key,array) in foodDictionary {
            let isAreaMatch = area == "all" || array.contains(area)
            
            let isCategoryMatch = cate=="all"||array.contains{ element in element.contains(("\(cate)/"))}||array.contains {element in element.contains(("/\(cate)/")) }||array.contains{ element in element.contains(("/\(cate)"))}||array.contains(cate)
            
            let isPriceMatch = (price == "50-70" && (array.contains("50-70") || array.contains("50-100"))) || price == "all"||array.contains(price) || (price == "70-100" && (array.contains("70-100") || array.contains("50-100")))
            
            if isAreaMatch && isCategoryMatch && isPriceMatch {
                print("Compatible values found in \(key)")
                
                print("---current values--- \narea:\(area)\nprice:\(price)\ncate:\(cate)")
                
                result2dim.append(array)
                keys.append(key)
                
                loading.foodName=keys
                loading.foodInfo=array
            }
        }
        print("---current values--- \narea:\(area)\nprice:\(price)\ncate:\(cate)")
        
        if keys.isEmpty {
            let alert = UIAlertController(title: "Not found 😭", message: "Select again", preferredStyle: .alert)
                    let okja = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okja)
                   present(alert, animated: true, completion: nil)
        } else {
            self.navigationController?.pushViewController(loading, animated: true)
            
        }
        loading.resultArray=result2dim
        loading.lang=lang
        
    }
    
  
    
    @IBOutlet weak var pricePicker: UIPickerView!
    
    @IBOutlet weak var lbg2: UILabel!
    @IBOutlet weak var lbg5: UILabel!
    @IBOutlet weak var lbSS: UILabel!
    @IBOutlet weak var lbUni: UILabel!
    @IBOutlet weak var lbCate: UILabel!
    @IBOutlet weak var catePicker: UIPickerView!
    
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var cateTxt: UITextField!
    @IBOutlet weak var priceTxt: UITextField!
    
    @IBOutlet weak var g5Btn: UIButton!
    @IBOutlet weak var g2Btn: UIButton!
    @IBOutlet weak var ssBtn: UIButton!
    @IBOutlet weak var uniBtn: UIButton!

    
    func checkForPermission(){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings{
            settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert,.sound]){
                    didAllow , error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
            default:
                return
            }
        }
    }

    func dispatchNotification() {
        let identifier = "routine"
        let title = "Are you hungry ?"
        let body = "Let's find some food 🥩"
        let interval: TimeInterval = 60  //1 minute
        let isRepeating = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: isRepeating)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
        
        print("Notification")
    }

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("menuVC:\(lang)")
        
        if lang=="th" {
            lbPrice.text="ราคา"
            lbCate.text="ประเภท"
            lbUni.text="ในมหาลัย"
            lbSS.text="คลองแสนแสบ"
            lbg2.text="ประตู 2"
            lbg5.text="ประตู 5"
            priceTxt.placeholder="เลือกช่วงราคา"
            cateTxt.placeholder="เลือกประเภท"
        }
        
        checkForPermission()
      // UI TF
        cateTxt.layer.borderColor = UIColor.systemPurple.cgColor
        cateTxt.layer.borderWidth = 1.0
        cateTxt.layer.cornerRadius = 7.0
        priceTxt.layer.borderColor = UIColor.systemPurple.cgColor
        priceTxt.layer.borderWidth = 1.0
        priceTxt.layer.cornerRadius = 7.0

        startBtn.layer.cornerRadius = startBtn.bounds.height / 2.0
        startBtn.layer.masksToBounds = true

        overrideUserInterfaceStyle = .light
        if lang=="en" {
            foodDictionary=loading.loaddict(lang: "foodDict")
            prices=loading.loadingplistData(key: "price", lang: "priceCategories")
            cates=loading.loadingplistData(key: "cate", lang: "priceCategories")
        } else if lang=="th" {
            foodDictionary=loading.loaddict(lang: "foodDictTH")
            prices=loading.loadingplistData(key: "price", lang: "priceCategoriesTH")
            cates=loading.loadingplistData(key: "cate", lang: "priceCategoriesTH")
        }

    
        
        priceTxt.inputView=pricePicker
        cateTxt.inputView=catePicker
        pricePicker.delegate=self
        pricePicker.dataSource=self
        catePicker.dataSource=self
        catePicker.delegate=self
        
        pricePicker.selectRow(0, inComponent: 0, animated: false)
        catePicker.selectRow(0, inComponent: 0, animated: false)
        
        uniBtn.tintColor=UIColor(red: 45/255, green: 160/255, blue: 154/255, alpha: 1)
        ssBtn.tintColor=UIColor(red: 45/255, green: 160/255, blue: 154/255, alpha: 1)
        g2Btn.tintColor=UIColor(red: 45/255, green: 160/255, blue: 154/255, alpha: 1)
        g5Btn.tintColor=UIColor(red: 45/255, green: 160/255, blue: 154/255, alpha: 1)
    
        
    }
    
    var foodDictionary:Dictionary=[String:[String]]()
    var matchingResult=[String]()

    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var imgG5: UIImageView!
    @IBOutlet weak var imgG2: UIImageView!
    @IBOutlet weak var imgSS: UIImageView!
    @IBOutlet weak var imgUni: UIImageView!
}

