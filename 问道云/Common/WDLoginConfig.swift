//
//  WDLoginConfig.swift
//  问道云
//
//  Created by Andrew on 2024/12/3.
//

import UIKit

let WDY_PHONE = "WDY_PHONE"

let WDY_SESSIONID = "WDY_SESSIONID"

let WDY_CUSTOMERNUMBER = "WDY_CUSTOMERNUMBER"

let WDY_USER_ID = "WDY_USER_ID"

var IS_LOGIN: Bool {
    if let sessionID = UserDefaults.standard.object(forKey: WDY_SESSIONID) as? String {
        return !sessionID.isEmpty
    } else {
        return false
    }
}

class WDLoginConfig: NSObject {
    
    static func saveLoginInfo(_ phone: String, _ sessionID: String, _ customerNumber: String, _ userID: String) {
        UserDefaults.standard.setValue(phone, forKey: WDY_PHONE)
        UserDefaults.standard.setValue(sessionID, forKey: WDY_SESSIONID)
        UserDefaults.standard.setValue(customerNumber, forKey: WDY_CUSTOMERNUMBER)
        UserDefaults.standard.setValue(userID, forKey: WDY_USER_ID)
        UserDefaults.standard.synchronize()
    }
    
    static func removeLoginInfo() {
        GetCacheConfig.clearCache()
        UserDefaults.standard.setValue("", forKey: WDY_PHONE)
        UserDefaults.standard.setValue("", forKey: WDY_SESSIONID)
        UserDefaults.standard.setValue("", forKey: WDY_CUSTOMERNUMBER)
        UserDefaults.standard.setValue("", forKey: WDY_USER_ID)
        UserDefaults.standard.setValue("", forKey: CLICK_PRIVACY)
        UserDefaults.standard.synchronize()
    }
    
}

//获取登录数据
class GetSaveLoginInfoConfig {
    
    static func getCustomerNumber() -> String {
        let customernumber = UserDefaults.standard.object(forKey: WDY_CUSTOMERNUMBER) as? String ?? ""
        return customernumber
    }
    
    static func getPhoneNumber() -> String {
        let phoneNum = UserDefaults.standard.object(forKey: WDY_PHONE) as? String ?? ""
        return phoneNum
    }
    
    static func getSessionID() -> String {
        let token = UserDefaults.standard.object(forKey: WDY_SESSIONID) as? String ?? ""
        return token
    }
    
    static func getUserID() -> String {
        let userID = UserDefaults.standard.object(forKey: WDY_USER_ID) as? String ?? ""
        return userID
    }
    
    
}
