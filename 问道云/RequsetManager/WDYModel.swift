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
    var rows: [rowsModel]?
    init(json: JSON) {
        self.code = json["code"].intValue
        self.msg = json["msg"].stringValue
        self.rows = json["rows"].arrayValue.map { rowsModel(json: $0) }
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
    var data: [rowsModel]?
    init(json: JSON) {
        self.access_token = json["access_token"].stringValue
        self.customernumber = json["customernumber"].stringValue
        self.user_id = json["user_id"].stringValue
        self.createdate = json["createdate"].stringValue
        self.userIdentity = json["userIdentity"].stringValue
        self.expires_in = json["expires_in"].stringValue
        self.userinfo = userinfoModel(json: json["userinfo"])
        self.accounttype = json["accounttype"].intValue
        self.viplevel = json["viplevel"].stringValue
        self.endtime = json["endtime"].stringValue
        self.comboname = json["comboname"].stringValue
        self.combotypenumber = json["combotypenumber"].stringValue
        self.combonumber = json["combonumber"].intValue
        self.total = json["total"].intValue
        self.rows = json["rows"].arrayValue.map { rowsModel(json: $0) }
        self.data = json["data"].arrayValue.map { rowsModel(json: $0) }
    }
}

class userinfoModel {
    var token: String?
    var userid: String?
    var username: String?
    var createdate: String?
    var userIdentity: String?
    init(json: JSON) {
        self.token = json["token"].stringValue
        self.userid = json["userid"].stringValue
        self.username = json["username"].stringValue
        self.createdate = json["createdate"].stringValue
        self.userIdentity = json["userIdentity"].stringValue
    }
}

class rowsModel {
    var comboname: String?
    var orderstate: String?//订单状态
    var ordernumber: String?
    var ordertime: String?
    var payway: String?
    var pirce: Float?
    var combotypename: String?//name
    var combotypenumber: Int?//type
    var descprtion: String?
    var code: String?
    var value: String?
    var downloadfilename: String?
    var firmname: String?
    var createtime: String?
    var filepathH5: String?
    init(json: JSON) {
        self.comboname = json["comboname"].stringValue
        self.orderstate = json["orderstate"].stringValue
        self.ordernumber = json["ordernumber"].stringValue
        self.ordertime = json["ordertime"].stringValue
        self.payway = json["payway"].stringValue
        self.pirce = json["pirce"].floatValue
        self.combotypename = json["combotypename"].stringValue
        self.combotypenumber = json["combotypenumber"].intValue
        self.descprtion = json["descprtion"].stringValue
        self.code = json["code"].stringValue
        self.value = json["value"].stringValue
        self.downloadfilename = json["downloadfilename"].stringValue
        self.firmname = json["firmname"].stringValue
        self.createtime = json["createtime"].stringValue
        self.filepathH5 = json["filepathH5"].stringValue
    }
}
