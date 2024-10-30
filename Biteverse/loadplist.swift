//
//  loadplist.swift
//  Biteverse
//
//  Created by Siripoom Jaruphoom on 30/11/23.
//

import UIKit

class loadplist: NSObject {
    
    
    func loadingplistData(key:String,lang:String) -> [String] {
        let plistPath = Bundle.main.path(forResource: lang, ofType: "plist")
        
        var array = [String]()
        
        if let path = plistPath, let data = FileManager.default.contents(atPath: path) {
            do {
                if let plistDict = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],let resultArray = plistDict[key] as? [String]  {
                    
              array = resultArray
                
                }
            } catch {
                print("Error: \(error)")
            }
        }
        else {
            print("Property list not found.")
        }
        return array
    }
    func loaddict(lang:String) -> [String:[String]] {
        let url = Bundle.main.url(forResource: lang, withExtension: "plist")!
        let testdata = try! Data(contentsOf: url)
        let myPlist = try! PropertyListSerialization.propertyList(from: testdata, options: [], format: nil)
        
        let plistdict = myPlist as? [String:[String]]

        return plistdict!
        }
}
