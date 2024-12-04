//
//  WDYModel.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import SwiftyJSON

class BaseModel {
    var code: Int?
    var msg: String?
    var data: DataModel?
    init(json: JSON) {
        self.code = json["code"].intValue
        self.msg = json["msg"].stringValue
        self.data = DataModel(json: json["data"])
    }
}


class DataModel {
    
    init(json: JSON) {
        
    }
    
}
