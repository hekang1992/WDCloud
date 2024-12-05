//
//  WDLoginConfig.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit

let WDY_PHONE = "WDY_PHONE"

let WDY_SESSIONID = "WDY_SESSIONID"

let WDY_CUSTOMERNUMBER = "WDY_CUSTOMERNUMBER"

var IS_LOGIN: Bool {
    if let sessionID = UserDefaults.standard.object(forKey: WDY_SESSIONID) as? String {
        return !sessionID.isEmpty
    } else {
        return false
    }
}

class WDLoginConfig: NSObject {

    static func saveLoginInfo(_ phone: String, _ sessionID: String, _ customerNumber: String) {
        UserDefaults.standard.setValue(phone, forKey: WDY_PHONE)
        UserDefaults.standard.setValue(sessionID, forKey: WDY_SESSIONID)
        UserDefaults.standard.setValue(customerNumber, forKey: WDY_CUSTOMERNUMBER)
        UserDefaults.standard.synchronize()
    }
    
    static func removeLoginInfo() {
        UserDefaults.standard.setValue("", forKey: WDY_PHONE)
        UserDefaults.standard.setValue("", forKey: WDY_SESSIONID)
        UserDefaults.standard.setValue("", forKey: WDY_CUSTOMERNUMBER)
        UserDefaults.standard.synchronize()
    }
    
}
