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
    var total: Int?
    init(json: JSON) {
        self.code = json["code"].intValue
        self.msg = json["msg"].stringValue
        self.rows = json["rows"].arrayValue.map { rowsModel(json: $0) }
        self.datas = json["data"].arrayValue.map { rowsModel(json: $0) }
        self.data = DataModel(json: json["data"])
        self.total = json["total"].intValue
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
    var isDistributor: String?//是否是分销商
    var rows: [rowsModel]?
    var data: [rowsModel]?
    var ordernumber: String?
    var dataid: String?
    var firmname: String?
    var email: String?
    var useaccountcount: String?//当前人数
    var accountcount: String?//总人数
    var flag: String?
    var wechatopenid: String?
    var items: [itemsModel]?
    var bossList: [bossListModel]?
    var pageData: [pageDataModel]?
    var pageMeta: pageMetaModel?
    
    //风险数据模型
    var entityData: entityDataModel?
    var personData: personDataModel?
    
    //股票模型
    var stockInfo: [stockInfoModel]?
    //
    var firmInfo: firmInfoModel?
    //标签
    var warnLabels: [warnLabelsModel]?
    //员工
    var employees: employeesModel?
    //利润
    var incomeInfo: incomeInfoModel?
    //收入
    var profitInfo: profitInfoModel?
    //主要股东
    var shareHolders: [shareHoldersModel]?
    //主要人员
    var staffInfos: [staffInfosModel]?
    init(json: JSON) {
        self.staffInfos = json["staffInfos"].arrayValue.map { staffInfosModel(json: $0) }
        self.shareHolders = json["shareHolders"].arrayValue.map { shareHoldersModel(json: $0) }
        self.profitInfo = profitInfoModel(json: json["profitInfo"])
        self.incomeInfo = incomeInfoModel(json: json["incomeInfo"])
        self.employees = employeesModel(json: json["employees"])
        self.warnLabels = json["warnLabels"].arrayValue.map { warnLabelsModel(json: $0) }
        self.firmInfo = firmInfoModel(json: json["firmInfo"])
        self.stockInfo = json["stockInfo"].arrayValue.map { stockInfoModel(json: $0) }
        self.entityData = entityDataModel(json: json["entityData"])
        self.personData = personDataModel(json: json["personData"])
        self.pageMeta = pageMetaModel(json: json["pageMeta"])
        self.pageData = json["pageData"].arrayValue.map { pageDataModel(json: $0) }
        self.bossList = json["bossList"].arrayValue.map { bossListModel(json: $0) }
        self.items = json["items"].arrayValue.map { itemsModel(json: $0) }
        self.flag = json["flag"].stringValue
        self.wechatopenid = json["wechatopenid"].stringValue
        self.useaccountcount = json["useaccountcount"].stringValue
        self.accountcount = json["accountcount"].stringValue
        self.email = json["email"].stringValue
        self.firmname = json["firmname"].stringValue
        self.dataid = json["dataid"].stringValue
        self.ordernumber = json["ordernumber"].stringValue
        self.isDistributor = json["isDistributor"].stringValue
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

class itemsModel {
    var children: [childrenModel]?
    var companyCount: Int?
    var searchStr: String?//被搜索的文字 == 自己添加的。不是后台返回的
    var personName: String?
    var personId: String?
    var logo: String?
    var shareholderList: [shareholderListModel]?//合作伙伴信息
    var listCompany: [listCompanyModel]?//自己公司列表数据
    
    //风险数据公司
    var entityStatus: String?//经营状态
    var entityName: String?//公司名称
    var entityId: String?//公司ID
    var registerCapital: String?//注册资本
    var legalName: String?//法定代表人
    var incorporationTime: String?//成立时间
    var riskNum1: Int?//成立时间
    var riskNum2: Int?//成立时间
    
    //风险数据人员
    var name: String?//名称
    var personNumber: String?//人员ID
    var relevanceCount: Int?//企业个数
    
    //企业详情
    var menuName: String?//item名称
    var clickFlag: String?
    var icon: String?
    var iconGrey: String?
    var menuId: String?
    var path: String?//h5链接
    var status: String?//状态
    
    //动态
    var dynamiccontent: [dynamiccontentModel]?
    var itemName: String?
    var createtime: String?
    var risklevel: String?
    var riskDetailPath: String?
    var firmname: String?
    init(json: JSON) {
        //风险数据公司
        self.menuName = json["menuName"].stringValue
        self.entityStatus = json["entityStatus"].stringValue
        self.riskNum1 = json["riskNum1"].intValue
        self.riskNum2 = json["riskNum2"].intValue
        self.entityName = json["entityName"].stringValue
        self.entityId = json["entityId"].stringValue
        self.registerCapital = json["registerCapital"].stringValue
        self.legalName = json["legalName"].stringValue
        self.incorporationTime = json["incorporationTime"].stringValue
        //风险数据人员
        self.name = json["name"].stringValue
        self.personNumber = json["personNumber"].stringValue
        self.relevanceCount = json["relevanceCount"].intValue
        
        self.dynamiccontent = json["dynamiccontent"].arrayValue.map {
            dynamiccontentModel(json: $0)
        }
        self.itemName = json["itemName"].stringValue
        self.createtime = json["createtime"].stringValue
        self.risklevel = json["risklevel"].stringValue
        self.riskDetailPath = json["riskDetailPath"].stringValue
        self.firmname = json["firmname"].stringValue
        
        self.logo = json["logo"].stringValue
        self.companyCount = json["companyCount"].intValue
        self.searchStr = json["searchStr"].stringValue
        self.children = json["children"].arrayValue.map { childrenModel(json: $0) }
        self.personName = json["personName"].stringValue
        self.personId = json["personId"].stringValue
        self.listCompany = json["listCompany"].arrayValue.map { listCompanyModel(json: $0) }
        self.shareholderList = json["shareholderList"].arrayValue.map { shareholderListModel(json: $0) }
    }
}

class listCompanyModel {
    var count: Int?
    var entityName: String?
    var province: String?
    init(json: JSON) {
        self.entityName = json["entityName"].stringValue
        self.province = json["province"].stringValue
        self.count = json["count"].intValue
    }
}

class shareholderListModel {
    var count: Int?
    var entityName: String?
    var personId: Int?
    var personName: String?
    var name: String?
    init(json: JSON) {
        self.count = json["count"].intValue
        self.entityName = json["entityName"].stringValue
        self.personId = json["personId"].intValue
        self.personName = json["personName"].stringValue
        self.name = json["name"].stringValue
    }
}

class childrenModel {
    var icon: String?
    var menuName: String?
    var children: [childrenModel]?
    init(json: JSON) {
        self.children = json["children"].arrayValue.map { childrenModel(json: $0) }
        self.icon = json["icon"].stringValue
        self.menuName = json["menuName"].stringValue
    }
}

class userinfoModel {
    var token: String?
    var userid: String?
    var username: String?
    var createdate: String?
    var userIdentity: String?
    var access_token: String?
    var customernumber: String?
    var userinfo: wxuserinfoModel?
    init(json: JSON) {
        self.customernumber = json["customernumber"].stringValue
        self.userinfo = wxuserinfoModel(json: json["userinfo"])
        self.access_token = json["access_token"].stringValue
        self.token = json["token"].stringValue
        self.userid = json["userid"].stringValue
        self.username = json["username"].stringValue
        self.createdate = json["createdate"].stringValue
        self.userIdentity = json["userIdentity"].stringValue
    }
}

class wxuserinfoModel {
    var sysUser: sysUserModel?
    init(json: JSON) {
        self.sysUser = sysUserModel(json: json["sysUser"])
    }
}

class sysUserModel {
    var phonenumber: String?
    init(json: JSON) {
        self.phonenumber = json["phonenumber"].stringValue
    }
}

class rowsModel {
    var comboname: String?
    var orderstate: String?// 订单状态，0待支付 1已支付 2已失效 3已退款
    var ordernumber: String?
    var payway: String?
    var pirce: Double?
    var combotypename: String?//name
    var combotypenumber: Int?//type
    var descprtion: String?
    var code: String?
    var value: String?
    var firmname: String?
    var filepathH5: String?//h5链接
    var downloadfilename: String?//名称
    var dataid: String?//id号
    var entityId: String?
    var entityName: String?
    var follow: Bool?
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
    var createtime: String?
    var ordertime: String?
    var invoiceamount: String?
    var invoicetype: String?//发票类型
    var isChecked: Bool = false//记录cell是否被点击啦..
    var unitname: String?//抬头
    var taxpayernumber: String?//税号
    var handlestate: String?//税号
    var localpdflink: String?//发票地址
    var paynumber: String?//支付单号
    var name: String?
    var children: [rowsModel]?
    var groupname: String?
    var groupnumber: String?
    var customerFollowList: [customerFollowListModel]?
    var createhourtime: String?
    var personname: String?
    var sellprice: Double?
    var minconsumption: String?
    var combonumber: Int?
    var serviceComboList: [serviceComboListModel]?
    var endtime: String?
    var accounttype: Int?
    var accountcount: Int?
    var username: String?
    var customernumber: String?
    var title: String?//标题
    var summary: String?//描述
    var pic: String?//图片地址
    var itemId: String?//新闻ID
    var videofile: String?//讲堂链接
    var newstagsobj: [newstagsobjModel]?
    var banner: String?//banner图片链接
    var id: String?//ID
    var type: String?//1企业 2个人
    var searchContent: String?
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.searchContent = json["searchContent"].stringValue
        self.type = json["type"].stringValue
        self.banner = json["banner"].stringValue
        self.newstagsobj = json["newstagsobj"].arrayValue.map { newstagsobjModel(json: $0) }
        self.videofile = json["videofile"].stringValue
        self.itemId = json["itemId"].stringValue
        self.pic = json["pic"].stringValue
        self.summary = json["summary"].stringValue
        self.title = json["title"].stringValue
        self.customernumber = json["customernumber"].stringValue
        self.username = json["username"].stringValue
        self.accountcount = json["accountcount"].intValue
        self.accounttype = json["accounttype"].intValue
        self.endtime = json["endtime"].stringValue
        self.combonumber = json["combonumber"].intValue
        self.serviceComboList = json["serviceComboList"].arrayValue.map { serviceComboListModel(json: $0) }
        self.minconsumption = json["minconsumption"].stringValue
        self.sellprice = json["sellprice"].doubleValue
        self.personname = json["personname"].stringValue
        self.createhourtime = json["createhourtime"].stringValue
        self.createtime = json["createtime"].stringValue
        self.follow = json["follow"].boolValue
        self.customerFollowList = json["customerFollowList"].arrayValue.map { customerFollowListModel(json: $0) }
        self.groupname = json["groupname"].stringValue
        self.groupnumber = json["groupnumber"].stringValue
        self.children = json["children"].arrayValue.map { rowsModel(json: $0) }
        self.name = json["name"].stringValue
        self.code = json["code"].stringValue
        self.paynumber = json["paynumber"].stringValue
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
        self.pirce = json["pirce"].doubleValue
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

class newstagsobjModel {
    var abbName: String?
    var name: String?
    var tag: String?
    var type: String?
    var value: String?
    init(json: JSON) {
        self.value = json["value"].stringValue
        self.abbName = json["abbName"].stringValue
        self.name = json["name"].stringValue
        self.tag = json["tag"].stringValue
        self.type = json["type"].stringValue
    }
}

class customerFollowListModel {
    var followtargetname: String?
    var createTime: String?
    var entityid: String?
    var dataid: String?
    var firmnamestate: String?
    var logo: String?
    init(json: JSON) {
        self.followtargetname = json["followtargetname"].stringValue
        self.createTime = json["createTime"].stringValue
        self.entityid = json["entityid"].stringValue
        self.dataid = json["dataid"].stringValue
        self.firmnamestate = json["firmnamestate"].stringValue
        self.logo = json["logo"].stringValue
    }
}

class serviceComboListModel {
    var comboname: String?
    var combonumber: Int?//苹果支付产品ID
    var combotypename: String?
    var minconsumption: String?
    var price: Double?
    var sellprice: Double?
    var privilegedpic: String?//图片地址
    init(json: JSON) {
        self.comboname = json["comboname"].stringValue
        self.combonumber = json["combonumber"].intValue
        self.combotypename = json["combotypename"].stringValue
        self.minconsumption = json["minconsumption"].stringValue
        self.price = json["price"].doubleValue
        self.sellprice = json["sellprice"].doubleValue
        self.privilegedpic = json["privilegedpic"].stringValue
    }
}

class pageDataModel {
    var firmInfo: firmInfoModel?
    var legalPerson: legalPersonModel?
    var riskInfo: riskInfoModel?
    var searchStr: String?//被搜索的文字 == 自己添加的。不是后台返回的
    var labels: [labelsModel]?
    init(json: JSON) {
        self.searchStr = json["searchStr"].stringValue
        self.firmInfo = firmInfoModel(json: json["firmInfo"])
        self.legalPerson = legalPersonModel(json: json["legalPerson"])
        self.riskInfo = riskInfoModel(json: json["riskInfo"])
        self.labels = json["labels"].arrayValue.map { labelsModel(json: $0) }
    }
}

class labelsModel {
    var name: String?
    var type: Int?
    var url: String?
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.type = json["type"].intValue
        self.url = json["url"].stringValue
    }
}

class riskInfoModel {
    var content: String?
    var riskTime: String?
    init(json: JSON) {
        self.content = json["content"].stringValue
        self.riskTime = json["riskTime"].stringValue
    }
}

class firmInfoModel {
    var entityId: String?
    var entityStatusLabel: String?
    var incorporationTime: String?
    var phone: String?
    var registerAddress: String?
    var registerCapital: String?
    var registerCapitalCurrency: String?
    var website: String?
    var logo: String?//企业logo
    var entityName: String?//企业名称
    var usCreditCode: String?//统一社会信用代码
    var businessScope: String?//简介
    var legalPerson: legalPersonModel?
    var industry: [String]?
    var scale: String?
    var listingStatus: String?
    init(json: JSON) {
        self.listingStatus = json["listingStatus"].stringValue
        self.scale = json["scale"].stringValue
        self.legalPerson = legalPersonModel(json: json["legalPerson"])
        self.businessScope = json["businessScope"].stringValue
        self.logo = json["logo"].stringValue
        self.entityId = json["entityId"].stringValue
        self.entityName = json["entityName"].stringValue
        self.entityStatusLabel = json["entityStatusLabel"].stringValue
        self.incorporationTime = json["incorporationTime"].stringValue
        self.phone = json["phone"].stringValue
        self.registerAddress = json["registerAddress"].stringValue
        self.registerCapital = json["registerCapital"].stringValue
        self.registerCapitalCurrency = json["registerCapitalCurrency"].stringValue
        self.website = json["website"].stringValue
        self.usCreditCode = json["usCreditCode"].stringValue
        self.industry = json["industry"].arrayValue.map({
            $0.stringValue
        })
    }
}


class pageMetaModel {
    var totalNum: Int?//总共
    var size: Int?//页数
    init(json: JSON) {
        self.totalNum = json["totalNum"].intValue
        self.size = json["size"].intValue
    }
}

class bossListModel {
    var name: String?
    init(json: JSON) {
        self.name = json["name"].stringValue
    }
}

//法定代表人
class legalPersonModel {
    var legalName: String?
    var personNumber: String?
    init(json: JSON) {
        self.legalName = json["legalName"].stringValue
        self.personNumber = json["personNumber"].stringValue
    }
}

//风险数据模型企业数据
class entityDataModel {
    var items: [itemsModel]?
    var total: Int?
    init(json: JSON) {
        self.items = json["items"].arrayValue.map { itemsModel(json: $0) }
        self.total = json["total"].intValue
    }
}

//风险数据模型人员数据
class personDataModel {
    var items: [itemsModel]?
    var total: Int?
    init(json: JSON) {
        self.items = json["items"].arrayValue.map { itemsModel(json: $0) }
        self.total = json["total"].intValue
    }
}

//动态数据模型
class dynamiccontentModel {
    var fieldName: String?
    var title: String?
    var fieldValue: String?
    init(json: JSON) {
        self.fieldName = json["fieldName"].stringValue
        self.title = json["title"].stringValue
        self.fieldValue = json["fieldValue"].stringValue
    }
}

//股票模型数据
class stockInfoModel {
    var key: String?//深a 沪a
    var value: valueModel?
    init(json: JSON) {
        self.key = json["key"].stringValue
        self.value = valueModel(json: json["value"])
    }
}

class valueModel {
    var marketName: String?
    var stockName: String?
    var shareCode: String?
    var securityType: String?
    var listedExchange: String?
    var olPublishTime: String?
    var listingTime: String?
    var riseFall: String?
    var riseFallRatio: String?
    var listingStatus: String?
    var updateDate: String?
    var totalMarketValue: String?
    var volumeOfBusiness: String?
    var circulatingMarketValue: String?
    var tradingVolume: String?
    var yClosePrice: String?
    var netRate: String?
    var earningsRatio: String?
    var openPriceToday: String?
    
    init(json: JSON) {
        self.earningsRatio = json["earningsRatio"].stringValue
        self.netRate = json["netRate"].stringValue
        self.yClosePrice = json["yClosePrice"].stringValue
        self.openPriceToday = json["openPriceToday"].stringValue
        self.tradingVolume = json["tradingVolume"].stringValue
        self.volumeOfBusiness = json["volumeOfBusiness"].stringValue
        self.circulatingMarketValue = json["circulatingMarketValue"].stringValue
        self.totalMarketValue = json["totalMarketValue"].stringValue
        self.updateDate = json["updateDate"].stringValue
        self.listingStatus = json["listingStatus"].stringValue
        self.riseFallRatio = json["riseFallRatio"].stringValue
        self.riseFall = json["riseFall"].stringValue
        self.listingTime = json["listingTime"].stringValue
        self.olPublishTime = json["olPublishTime"].stringValue
        self.listedExchange = json["listedExchange"].stringValue
        self.securityType = json["securityType"].stringValue
        self.shareCode = json["shareCode"].stringValue
        self.stockName = json["stockName"].stringValue
        self.marketName = json["marketName"].stringValue
    }
}

class warnLabelsModel {
    var name: String?
    var url: String?
    var type: String?
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.url = json["url"].stringValue
        self.type = json["type"].stringValue
    }
}

class employeesModel {
    var lastNumber: Int?
    var lastYear: String?
    var annualReports: [annualReportsModel]?
    init(json: JSON) {
        self.annualReports = json["annualReports"].arrayValue.map { annualReportsModel(json: $0) }
        self.lastNumber = json["lastNumber"].intValue
        self.lastYear = json["lastYear"].stringValue
    }
}

class annualReportsModel {
    var number: Int?//人数
    var reportYear: String?
    var amount: Double?//利润
    init(json: JSON) {
        self.number = json["number"].intValue
        self.reportYear = json["reportYear"].stringValue
        self.amount = json["amount"].doubleValue
    }
}

//利润模型
class incomeInfoModel {
    var lastAmount: Int?
    var lastYear: String?
    var annualReports: [annualReportsModel]?
    init(json: JSON) {
        self.annualReports = json["annualReports"].arrayValue.map { annualReportsModel(json: $0) }
        self.lastAmount = json["lastAmount"].intValue
        self.lastYear = json["lastYear"].stringValue
    }
}

//收益模型
class profitInfoModel {
    var lastAmount: Int?
    var lastYear: String?
    var annualReports: [annualReportsModel]?
    init(json: JSON) {
        self.annualReports = json["annualReports"].arrayValue.map { annualReportsModel(json: $0) }
        self.lastAmount = json["lastAmount"].intValue
        self.lastYear = json["lastYear"].stringValue
    }
}

//主要股东
class shareHoldersModel {
    var id: String?
    var name: String?
    var percent: String?
    var relatedNum: Int?
    var type: String?//类型 2公司 1个人
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.percent = json["percent"].stringValue
        self.relatedNum = json["relatedNum"].intValue
        self.type = json["type"].stringValue
    }
}

//主要人员
class staffInfosModel {
    var count: Int?
    var entityId: String?
    var id: String?//人员ID
    var name: String?
    var positionName: String?
    var relatedNum: Int?
    var logo: String?
    init(json: JSON) {
        self.logo = json["logo"].stringValue
        self.count = json["count"].intValue
        self.entityId = json["entityId"].stringValue
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.positionName = json["positionName"].stringValue
        self.relatedNum = json["relatedNum"].intValue
    }
}
