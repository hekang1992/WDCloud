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
    var datas: [rowsModel]?//搜索的数组
    init(json: JSON) {
        self.code = json["code"].intValue
        self.msg = json["msg"].stringValue
        self.rows = json["rows"].arrayValue.map { rowsModel(json: $0) }
        self.datas = json["data"].arrayValue.map { rowsModel(json: $0) }
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
    var orderstate: String?// 订单状态，0待支付 1已支付 2已失效 3已退款
    var ordernumber: String?
    var ordertime: String?
    var payway: String?
    var pirce: Float?
    var combotypename: String?//name
    var combotypenumber: Int?//type
    var descprtion: String?
    var code: String?
    var value: String?
    var firmname: String?
    var createtime: String?//创建时间
    var filepathH5: String?//h5链接
    var downloadfilename: String?//名称
    var dataid: String?//id号
    var entityId: String?
    var entityName: String?
    var phone: String?
    var registerAddress: String?
    var usCreditCode: String?
    var logo: String?
    var companyname: String?
    var companynumber: String?
    var defaultstate: String?// 默认状态
    var zidingyiState: String?// 自定义默认状态
    var address: String?
    var bankname: String?
    var bankfullname: String?
    var contact: String?
    var invoicecontent: String?
    var createTime: String?
    var invoiceamount: String?
    var invoicetype: String?//发票类型
    var isChecked: Bool = false//记录cell是否被点击啦..
    var unitname: String?//抬头
    var taxpayernumber: String?//税号
    var handlestate: String?//税号
    var localpdflink: String?//发票地址
    init(json: JSON) {
        self.localpdflink = json["localpdflink"].stringValue
        self.handlestate = json["handlestate"].stringValue
        self.taxpayernumber = json["taxpayernumber"].stringValue
        self.unitname = json["unitname"].stringValue
        self.invoicetype = json["invoicetype"].stringValue
        self.isChecked = json["isChecked"].boolValue
        self.invoiceamount = json["invoiceamount"].stringValue
        self.createTime = json["createTime"].stringValue
        self.invoicecontent = json["invoicecontent"].stringValue
        self.contact = json["contact"].stringValue
        self.bankfullname = json["bankfullname"].stringValue
        self.bankname = json["bankname"].stringValue
        self.address = json["address"].stringValue
        self.defaultstate = json["defaultstate"].stringValue
        self.companynumber = json["companynumber"].stringValue
        self.companyname = json["companyname"].stringValue
        self.logo = json["logo"].stringValue
        self.entityId = json["entityId"].stringValue
        self.entityName = json["entityName"].stringValue
        self.phone = json["phone"].stringValue
        self.registerAddress = json["registerAddress"].stringValue
        self.usCreditCode = json["usCreditCode"].stringValue
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
        self.dataid = json["dataid"].stringValue
    }
}
