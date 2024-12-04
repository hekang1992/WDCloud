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
    var access_token: String?//token
    var customernumber: String?
    var user_id: String?
    var createdate: String?
    var userIdentity: String?
    var expires_in: String?
    var userinfo: userinfoModel?//用户信息模型
    init(json: JSON) {
        self.access_token = json["access_token"].string
        self.customernumber = json["customernumber"].string
        self.user_id = json["user_id"].string
        self.createdate = json["createdate"].string
        self.userIdentity = json["userIdentity"].string
        self.expires_in = json["expires_in"].string
        self.userinfo = userinfoModel(json: json["userinfo"])
    }
    
}

class userinfoModel {
    var token: String?
    var userid: String?
    var username: String?
    var createdate: String?
    var userIdentity: String?
    init(json: JSON) {
        self.token = json["token"].string
        self.userid = json["userid"].string
        self.username = json["username"].string
        self.createdate = json["createdate"].string
        self.userIdentity = json["userIdentity"].string
    }
}
