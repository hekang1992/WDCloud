//
//  WDYModel.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import SwiftyJSON
import Differentiator

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
    var accounttype: Int?//会员类型
    var viplevel: String?
    var endtime: String?
    var comboname: String?
    var combotypenumber: String?
    var combonumber: Int?//多少天
    var total: Int?//列表总个数
    var rows: [rowsModel]?
    init(json: JSON) {
        self.access_token = json["access_token"].string
        self.customernumber = json["customernumber"].string
        self.user_id = json["user_id"].string
        self.createdate = json["createdate"].string
        self.userIdentity = json["userIdentity"].string
        self.expires_in = json["expires_in"].string
        self.userinfo = userinfoModel(json: json["userinfo"])
        self.accounttype = json["accounttype"].intValue
        self.viplevel = json["viplevel"].string
        self.endtime = json["endtime"].string
        self.comboname = json["comboname"].string
        self.combotypenumber = json["combotypenumber"].string
        self.combonumber = json["combonumber"].intValue
        self.total = json["total"].intValue
        self.rows = json["rows"].arrayValue.map { rowsModel(json: $0) }
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

class rowsModel {
    var comboname: String?
    var orderstate: String?//订单状态
    var ordernumber: String?
    var ordertime: String?
    var payway: String?
    var pirce: Float?
    init(json: JSON) {
        self.comboname = json["comboname"].string
        self.orderstate = json["orderstate"].string
        self.ordernumber = json["ordernumber"].string
        self.ordertime = json["ordertime"].string
        self.payway = json["payway"].string
        self.pirce = json["pirce"].floatValue
    }
}
