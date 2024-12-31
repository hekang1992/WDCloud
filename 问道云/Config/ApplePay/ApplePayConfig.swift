//
//  ApplePayConfig.swift
//  问道云
//
//  Created by 何康 on 2024/12/30.
//

import DYFStore

typealias completion = () -> Void
class ApplePayConfig {
    
    static func buy(with storeID: String, completion: completion? = nil ) {
    
        guard !GetSaveLoginInfoConfig.getPhoneNumber().isEmpty else {
            ToastViewConfig.showToast(message: "请先登录")
            return
        }
        
        if !DYFStore.canMakePayments() {
            ToastViewConfig.showToast(message: "您的设备无法或不支持付款!")
            return
        }
        
        DYFStore.default.requestProduct(withIdentifier: storeID) { products, invalidIdentifiers in
            if let product = products.first {
                addPayment(productId: product.productIdentifier, completion: completion)
            }
        } failure: { error in
            let value = error.userInfo[NSLocalizedDescriptionKey] as? String
            let msg = value ?? "\(error.localizedDescription)"
            ToastViewConfig.showToast(message: msg)
        }
        
        func addPayment(productId: String, completion: completion? = nil) {
            SKIAPManager.shared.addPayment(productId)
            SKIAPManager.shared.successCallback = completion
        }
        
    }
}
