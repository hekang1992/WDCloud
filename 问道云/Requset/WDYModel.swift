//
//  WDYModel.swift
//  问道云
//
//  Created by Andrew on 2024/12/3.
//

import SwiftyJSON
import Differentiator

class BaseModel {
    var code: Int?
    var msg: String?
    var data: DataModel?
    var rows: [rowsModel]?
    var datas: [rowsModel]?//搜索的数组
    var datass: [DataModel]?//搜索的数组
    var datasss: [String]?
    var total: Int?
    init(json: JSON) {
        self.code = json["code"].intValue
        self.msg = json["msg"].stringValue
        self.total = json["total"].intValue
        self.data = DataModel(json: json["data"])
        self.rows = json["rows"].arrayValue.map { rowsModel(json: $0) }
        self.datas = json["data"].arrayValue.map { rowsModel(json: $0) }
        self.datass = json["data"].arrayValue.map { DataModel(json: $0) }
        self.datasss = json["data"].arrayValue.map { $0.stringValue }
    }
}

class DataModel {
    var all: Int?
    var legal: Int?
    var staff: Int?
    var url: String?
    var shareholder: Int?
    var access_token: String?//token
    var customernumber: String?
    var user_id: String?
    var createdate: String?
    var userIdentity: String?
    var expires_in: String?
    var userinfo: userinfoModel?//用户信息模型
    var accounttype: Int?//会员类型
    var viplevel: String?
    var endTime: String?
    var endtime: String?
    var startTime: String?
    var comboname: String?
    var combotypenumber: String?
    var combonumber: Int?
    var appleById: Int?
    var total: Int?//列表总个数
    var orgTotal: Int?
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
    var datas: [DataModel]?
    var bossList: bossListModel?
    var pageData: [pageDataModel]?
    var pageMeta: pageMetaModel?
    var contactInfoCount: contactInfoCountModel?
    
    //风险数据模型
    var entityData: entityDataModel?
    var personData: personDataModel?
    var rimRiskSize: Int?//企业个数
    var sumCount: Int?//风险个数
    var generaCompanyCnt: Int?//子公司
    var investCompanyCnt: Int?//对外投资
    var directorCompanyCnt: Int?//董监高投资
    var shCompanyCnt: Int?//股东
    /**
     公司详情数据模型
     */
    //股票模型
    var stockInfo: [stockInfoModel]?
    //
    var firmInfo: firmInfoModel?
    //标签
    var warnLabels: [warnLabelsModel]?
    //员工
    var employees: employeesModel?
    //利润
    var saleInfo: incomeInfoModel?
    //收入
    var profitInfo: profitInfoModel?
    //主要股东
    var shareHolders: [shareHoldersModel]?
    //主要人员
    var srMgmtInfos: [staffInfosModel]?
    //曾用名
    var namesHis: [namesUsedBeforeModel]?
    //税号
    var taxInfo: taxInfoModel?
    //总资产
    var assetInfo: assetInfoModel?
    //标签
    var labels: [promptLabelsModel]?
    //是否被关注
    var followInfo: followInfoModel?
    //法人
    var leaderVec: leaderVecModel?
    //基本信息
    var basicInfo: basicInfoModel?
    //是否被监控
    var monitorInfo: monitorInfoModel?
    /**
     个人详情数据模型
     */
    var personId: String?//个人ID
    var personName: String?//个人名字
    var resume: String?//个人简介
    var shareholderList: [shareholderListModel]?//合作伙伴
    var tags: [String]?
    //风险
    var entityRiskEventInfo: entityRiskEventInfoModel?
    var operationRisk: map1Model?
    var lawRisk: map1Model?
    var financeRisk: map1Model?
    var opinionRisk: map1Model?
    var riskDynamic: map1Model?
    
    var riskGrade: riskGradeModel?
    var totalRiskCnt: Int?
    var totalCompanyCnt: Int?
    var rimRisk: [rimRiskModel]?
    var totaRiskCnt: Int?
    var name: String?
    var riskList: riskListModel?
    var minutesList: [minutesListModel]?
    var entityName: String?
    var logoUrl: String?
    var highLevelCnt: Int?
    var lowLevelCnt: Int?
    var tipLevelCnt: Int?
    var monitorStartDate: String?
    var monitorEndDate: String?
    var monitorFlag: Int?
    var groupName: String?
    var notRelevaRiskDto: notRelevaRiskDtoModel?
    var relevaRiskItemDtos: [itemDtoListModel]?
    /**
     监控设置模型
     */
    var propertyTypeSetting: [propertyTypeSettingModel]?
    var propertyEntityRelatedSetting: [propertyTypeSettingModel]?
    var propertyPersonRelatedSetting: [propertyTypeSettingModel]?
    /**
     高级搜索模型
     */
    var ORG_REG_STATUS: [itemsModel]?//登记状态
    var INC_DATE_LEVEL: [itemsModel]?//成立年限
    var REG_CAP_LEVEL: [itemsModel]?//注册资本
    var ORG_CATEGORY: [itemsModel]?//机构类型
    var ORG_ECON: [itemsModel]?//企业类型
    var SIP_LEVEL: [itemsModel]?//参保人数
    var LIST_STATUS: [itemsModel]?//上市状态
    var LIST_SECTOR: [itemsModel]?//上市板块
    var REGION: [rowsModel]?//地区
    var INDUSTRY: [rowsModel]?//行业
    var pushOffset: String?
    var orgNum: Int?
    var personNum: Int?
    var phoneList: [phoneListModel]?
    var addressList: [addressListModel]?
    var websitesList: [websitesListModel]?
    var emailList: [emailListModel]?
    var wechatList: [wechatListModel]?
    var lawNatureList: [lawNatureListModel]?
    var timelinessList: [lawNatureListModel]?
    var monitor: Bool?
    var monitorListId: String?
    var cluesDataList: [cluesDataListModel]?
    var personPage: personPageModel?
    var companyPage: companyPageModel?
    var entityId: String?
    var searchStr: String?//被搜索的文字 == 自己添加的。不是后台返回的
    var count: countModel?
    var endDate: String?
    var startDate: String?
    var personCount: Int?
    var orgCount: Int?
    var clueNum: Int?
    var clueValuation: String?
    var groupList: [rowsModel]?
    var conditionVO: conditionVOModel?
    var pageableData: pageableDataModel?
    var isRealTimePush: Int?
    var monitorRelationVOList: [monitorRelationVOListModel]?
    var pitems: [pageItemsModel]?
    var amountUnit: String?
    var amount: String?
    var subjectName: String?
    var subjectId: String?
    var bindStatus: Int?
    init(json: JSON) {
        self.bindStatus = json["bindStatus"].intValue
        self.subjectName = json["subjectName"].stringValue
        self.subjectId = json["subjectId"].stringValue
        self.datas = json["items"].arrayValue.map { DataModel(json: $0) }
        self.amount = json["amount"].stringValue
        self.amountUnit = json["amountUnit"].stringValue
        self.pitems = json["item"].arrayValue.map { pageItemsModel(json: $0) }
        self.monitorRelationVOList = json["monitorRelationVOList"].arrayValue.map { monitorRelationVOListModel(json: $0) }
        self.isRealTimePush = json["isRealTimePush"].intValue
        self.pageableData = pageableDataModel(json: json["pageableData"])
        self.conditionVO = conditionVOModel(json: json["conditionVO"])
        self.groupList = json["groupList"].arrayValue.map { rowsModel(json: $0) }
        self.clueNum = json["clueNum"].intValue
        self.clueValuation = json["clueValuation"].stringValue
        self.personCount = json["personCount"].intValue
        self.orgCount = json["orgCount"].intValue
        self.startDate = json["startDate"].stringValue
        self.endDate = json["endDate"].stringValue
        self.relevaRiskItemDtos = json["relevaRiskItemDtos"].arrayValue.map { itemDtoListModel(json: $0) }
        self.notRelevaRiskDto = notRelevaRiskDtoModel(json: json["notRelevaRiskDto"])
        self.count = countModel(json: json["items"])
        self.orgTotal = json["orgTotal"].intValue
        self.logoUrl = json["logoUrl"].stringValue
        self.searchStr = json["searchStr"].stringValue
        self.entityId = json["entityId"].stringValue
        self.companyPage = companyPageModel(json: json["companyPage"])
        self.personPage = personPageModel(json: json["personPage"])
        self.cluesDataList = json["cluesDataList"].arrayValue.map { cluesDataListModel(json: $0) }
        self.monitorListId = json["monitorListId"].stringValue
        self.monitor = json["monitor"].boolValue
        self.timelinessList = json["timelinessList"].arrayValue.map { lawNatureListModel(json: $0) }
        self.lawNatureList = json["lawNatureList"].arrayValue.map { lawNatureListModel(json: $0) }
        self.appleById = json["appleById"].intValue
        self.resume = json["resume"].stringValue
        self.monitorInfo = monitorInfoModel(json: json["monitorInfo"])
        self.groupName = json["groupName"].stringValue
        self.monitorFlag = json["monitorFlag"].intValue
        self.monitorStartDate = json["monitorStartDate"].stringValue
        self.monitorEndDate = json["monitorEndDate"].stringValue
        self.phoneList = json["phoneList"].arrayValue.map { phoneListModel(json: $0) }
        self.addressList = json["addressList"].arrayValue.map { addressListModel(json: $0) }
        self.websitesList = json["websitesList"].arrayValue.map { websitesListModel(json: $0) }
        self.emailList = json["emailList"].arrayValue.map { emailListModel(json: $0) }
        self.wechatList = json["wechatList"].arrayValue.map { wechatListModel(json: $0) }
        self.contactInfoCount = contactInfoCountModel(json: json["contactInfoCount"])
        self.leaderVec = leaderVecModel(json: json["leaderVec"])
        self.basicInfo = basicInfoModel(json: json["basicInfo"])
        self.generaCompanyCnt = json["generaCompanyCnt"].intValue
        self.investCompanyCnt = json["investCompanyCnt"].intValue
        self.directorCompanyCnt = json["directorCompanyCnt"].intValue
        self.shCompanyCnt = json["shCompanyCnt"].intValue
        self.endtime = json["endtime"].stringValue
        self.startTime = json["startTime"].stringValue
        self.totalCompanyCnt = json["totalCompanyCnt"].intValue
        self.highLevelCnt = json["highLevelCnt"].intValue
        self.lowLevelCnt = json["lowLevelCnt"].intValue
        self.tipLevelCnt = json["tipLevelCnt"].intValue
        self.orgNum = json["orgNum"].intValue
        self.personNum = json["personNum"].intValue
        self.pushOffset = json["pushOffset"].stringValue
        self.INDUSTRY = json["INDUSTRY"].arrayValue.map { rowsModel(json: $0) }
        self.REGION = json["REGION"].arrayValue.map { rowsModel(json: $0) }
        self.LIST_SECTOR = json["LIST_SECTOR"].arrayValue.map { itemsModel(json: $0) }
        self.LIST_STATUS = json["LIST_STATUS"].arrayValue.map { itemsModel(json: $0) }
        self.SIP_LEVEL = json["SIP_LEVEL"].arrayValue.map { itemsModel(json: $0) }
        self.ORG_ECON = json["ORG_ECON"].arrayValue.map { itemsModel(json: $0) }
        self.ORG_CATEGORY = json["ORG_CATEGORY"].arrayValue.map { itemsModel(json: $0) }
        self.REG_CAP_LEVEL = json["REG_CAP_LEVEL"].arrayValue.map { itemsModel(json: $0) }
        self.ORG_REG_STATUS = json["ORG_REG_STATUS"].arrayValue.map { itemsModel(json: $0) }
        self.INC_DATE_LEVEL = json["INC_DATE_LEVEL"].arrayValue.map { itemsModel(json: $0) }
        self.propertyEntityRelatedSetting = json["propertyEntityRelatedSetting"].arrayValue.map { propertyTypeSettingModel(json: $0) }
        self.propertyPersonRelatedSetting = json["propertyPersonRelatedSetting"].arrayValue.map { propertyTypeSettingModel(json: $0) }
        self.propertyTypeSetting = json["propertyTypeSetting"].arrayValue.map { propertyTypeSettingModel(json: $0) }
        self.url = json["url"].stringValue
        self.entityName = json["entityName"].stringValue
        self.minutesList = json["minutesList"].arrayValue.map { minutesListModel(json: $0) }
        self.riskList = riskListModel(json: json["riskList"])
        self.name = json["name"].stringValue
        self.followInfo = followInfoModel(json: json["followInfo"])
        self.rimRisk = json["rimRisk"].arrayValue.map { rimRiskModel(json: $0) }
        self.totalRiskCnt = json["totalRiskCnt"].intValue
        self.totaRiskCnt = json["totaRiskCnt"].intValue
        self.riskGrade = riskGradeModel(json: json["riskGrade"])
        self.entityRiskEventInfo = entityRiskEventInfoModel(json: json["entityRiskEventInfo"])
        self.operationRisk = map1Model(json: json["operationRisk"])
        self.lawRisk = map1Model(json: json["lawRisk"])
        self.financeRisk = map1Model(json: json["financeRisk"])
        self.opinionRisk = map1Model(json: json["opinionRisk"])
        self.riskDynamic = map1Model(json: json["riskDynamic"])
        self.all = json["all"].intValue
        self.legal = json["legal"].intValue
        self.staff = json["staff"].intValue
        self.shareholder = json["shareholder"].intValue
        
        self.tags = json["tags"].arrayValue.map { $0.stringValue }
        self.shareholderList = json["shareholderList"].arrayValue.map { shareholderListModel(json: $0) }
        self.personId = json["personId"].stringValue
        self.personName = json["personName"].stringValue
        self.labels = json["labels"].arrayValue.map { promptLabelsModel(json: $0) }
        self.assetInfo = assetInfoModel(json: json["assetInfo"])
        self.taxInfo = taxInfoModel(json: json["taxInfo"])
        self.namesHis = json["namesUsedBefore"].arrayValue.map { namesUsedBeforeModel(json: $0) }
        self.srMgmtInfos = json["srMgmtInfos"].arrayValue.map { staffInfosModel(json: $0) }
        self.shareHolders = json["shareHolders"].arrayValue.map { shareHoldersModel(json: $0) }
        self.profitInfo = profitInfoModel(json: json["profitInfo"])
        self.saleInfo = incomeInfoModel(json: json["saleInfo"])
        self.employees = employeesModel(json: json["employees"])
        self.warnLabels = json["warnLabels"].arrayValue.map { warnLabelsModel(json: $0) }
        self.firmInfo = firmInfoModel(json: json["firmInfo"])
        self.stockInfo = json["stockInfo"].arrayValue.map { stockInfoModel(json: $0) }
        self.entityData = entityDataModel(json: json["entityData"])
        self.personData = personDataModel(json: json["personData"])
        self.pageMeta = pageMetaModel(json: json["pageMeta"])
        self.pageData = json["pageData"].arrayValue.map { pageDataModel(json: $0) }
        self.bossList = bossListModel(json: json["bossList"])
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
        self.endTime = json["endTime"].stringValue
        self.comboname = json["comboname"].stringValue
        self.combotypenumber = json["combotypenumber"].stringValue
        self.combonumber = json["combonumber"].intValue
        self.rimRiskSize = json["rimRiskSize"].intValue
        self.sumCount = json["sumCount"].intValue
        self.total = json["total"].intValue
        self.generaCompanyCnt = json["generaCompanyCnt"].intValue
        self.generaCompanyCnt = json["generaCompanyCnt"].intValue
        self.directorCompanyCnt = json["directorCompanyCnt"].intValue
        self.shCompanyCnt = json["shCompanyCnt"].intValue
        self.rows = json["rows"].arrayValue.map { rowsModel(json: $0) }
        self.data = json["data"].arrayValue.map { rowsModel(json: $0) }
    }
}

class propertyTypeSettingModel {
    var code: Int?
    var isShow: String?
    var name: String?
    var select: Int?
    var levelKey: String?
    var items: [itemsModel]?
    init(json: JSON) {
        self.code = json["code"].intValue
        self.isShow = json["isShow"].stringValue
        self.name = json["name"].stringValue
        self.select = json["select"].intValue
        self.levelKey = json["levelKey"].stringValue
        self.items = json["items"].arrayValue.map { itemsModel(json: $0) }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "code": self.code ?? 0,
            "isShow": self.isShow ?? "",
            "name": self.name ?? "",
            "select": self.select ?? "",
            "levelKey": self.levelKey ?? "",
            "items": self.items?.map { $0.toDictionary() } ?? []
        ]
    }
    
}

class riskListModel {
    var map1: map1Model?
    var map2: map1Model?
    var map3: map1Model?
    var map4: map1Model?
    init(json: JSON) {
        self.map1 = map1Model(json: json["map1"])
        self.map2 = map1Model(json: json["map2"])
        self.map3 = map1Model(json: json["map3"])
        self.map4 = map1Model(json: json["map4"])
    }
}

class followInfoModel {
    var followStatus: Int?//1 未关注；2 已关注；3 已取关
    var followId: String?
    init(json: JSON) {
        self.followStatus = json["followStatus"].intValue
        self.followId = json["followId"].stringValue
    }
}

class minutesListModel {
    var caseId: String?
    var caseTitle: String?
    var dataId: String?
    var caseNumber: String?
    init(json: JSON) {
        self.caseId = json["caseId"].stringValue
        self.caseTitle = json["caseTitle"].stringValue
        self.dataId = json["dataId"].stringValue
        self.caseNumber = json["caseNumber"].stringValue
    }
}

class itemsModel {
    var children: [childrenModel]?
    var companyCount: Int?
    var searchStr: String?//被搜索的文字 == 自己添加的。不是后台返回的
    var navHeadTitleStr: String?// == 自己添加的。标题
    var personName: String?//个人名字
    var personname: String?//个人名字
    var personId: String?
    var logo: String?
    var clueNum: String?
    var groupname: String?
    var groupnumber: String?
    var shareholderList: [shareholderListModel]?//合作伙伴信息
    var listCompany: [listCompanyModel]?//自己公司列表数据
    var monitor: Bool?//是否监控
    var follow: Bool?//是否关注
    var website: [websitesListModel]?
    var phone: [websitesListModel]?
    var orgAddress: regAddrModel?
    
    //风险数据公司
    var entityStatus: String?//经营状态
    var entityName: String?//公司名称
    var entity_name: String?//公司名称
    var firmname: String?//公司名称
    var entityId: String?//公司ID
    var entity_id: String?//公司ID
    var entityid: String?//公司ID
    var registerCapital: String?//注册资本
    var legalName: String?//法定代表人
    var legalId: String?
    var incorporationTime: String?//成立时间
    var organizationNumber: String?//组织代码
    var count: String?
    var riskNum1: Int?//成立时间
    var riskNum2: Int?//成立时间
    var regCap: String?
    var regCapCur: String?
    var incDate: String?
    var relatedOrgCount: Int?
    var relatedOrgList: [relatedOrgListModel]?
    
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
    var dynamicContent: [dynamiccontentModel]?
    var itemName: String?
    var createtime: String?
    var createTime: String?
    var riskLevel: String?
    var riskDetailPath: String?
    var h5Path: String?
    var itemname: String?
    var size: Int?
    var itemnumber: String?
    var highCount: Int?
    var hintCount: Int?
    var lowCount: Int?
    var caseproperty: String?
    var risktime: String?
    var riskdynamicid: String?
    var subitems: [subitemsModel]?
    var riskMonitorPersonDtoList: [riskMonitorPersonDtoListModel]?//搜索监控企业
    var positions: [riskMonitorPersonDtoListModel]?//搜索监控企业
    var firstate: String?
    var riskSumup: Int?
    var high_risk: Int?
    var high_risk_sum: Int?
    var hint: Int?
    var hint_sum: Int?
    var low_risk: Int?
    var low_risk_sum: Int?
    var riskData: riskDataModel?
    var relate: [String]?
    var datanumber: String?//风险ID
    var shareShortCode: String?
    var shareCode: String?
    var publishTime: String?
    var pdfUrl: String?
    var ossUrl: String?
    var announcement_url: String?
    var title: String?
    var formulating_authority: String?
    var law_category: String?
    var publish_date: String?
    var timeliness: String?
    var announcement_title: String?
    var entry_into_force_time: String?
    var forshort: String?
    var descprtion: String?
    var templatepath: String?
    var authflag: Int?
    var reportType: Int?
    var reportnumber: String?
    var riskCount: Int?
    var idCardNumber: String?//身份证
    var resume: String?//简介
    var total: Int?
    var items: [itemsModel]?
    var content: String?
    var select: Int?
    var code: String?
    var levelKey: String?
    var value: String?
    var logoColor: String?
    var orgCount: Int?
    var orgName: String?
    var orgId: String?
    var orgLogo: String?
    var provinceStatList: [provinceStatListModel]?
    var riskInfo: riskInfoModel?
    var cluesDataList: [cluesDataListModel]?
    init(json: JSON) {
        self.createTime = json["createTime"].stringValue
        self.h5Path = json["h5Path"].stringValue
        self.cluesDataList = json["cluesDataList"].arrayValue.map { cluesDataListModel(json: $0) }
        self.clueNum = json["clueNum"].stringValue
        self.announcement_url = json["announcement_url"].stringValue
        self.riskInfo = riskInfoModel(json: json["riskInfo"])
        self.orgLogo = json["orgLogo"].stringValue
        self.legalId = json["legalId"].stringValue
        self.website = json["website"].arrayValue.map { websitesListModel(json: $0) }
        self.phone = json["phone"].arrayValue.map { websitesListModel(json: $0) }
        self.orgAddress = regAddrModel(json: json["orgAddress"])
        self.relatedOrgList = json["relatedOrgList"].arrayValue.map { relatedOrgListModel(json: $0) }
        self.relatedOrgCount = json["relatedOrgCount"].intValue
        self.incDate = json["incDate"].stringValue
        self.regCapCur = json["regCapCur"].stringValue
        self.regCap = json["regCap"].stringValue
        self.orgName = json["orgName"].stringValue
        self.orgId = json["orgId"].stringValue
        self.monitor = json["monitor"].boolValue
        self.follow = json["follow"].boolValue
        self.announcement_title = json["announcement_title"].stringValue
        self.entry_into_force_time = json["entry_into_force_time"].stringValue
        self.provinceStatList = json["provinceStatList"].arrayValue.map { provinceStatListModel(json: $0) }
        self.orgCount = json["orgCount"].intValue
        self.logoColor = json["logoColor"].stringValue
        self.value = json["value"].stringValue
        self.levelKey = json["levelKey"].stringValue
        self.code = json["code"].stringValue
        self.select = json["select"].intValue
        self.groupnumber = json["groupnumber"].stringValue
        self.groupname = json["groupname"].stringValue
        self.content = json["content"].stringValue
        self.items = json["items"].arrayValue.map { itemsModel(json: $0) }
        self.total = json["total"].intValue
        self.navHeadTitleStr = json["navHeadTitleStr"].stringValue
        self.organizationNumber = json["organizationNumber"].stringValue
        self.resume = json["resume"].stringValue
        self.idCardNumber = json["idCardNumber"].stringValue
        self.riskCount = json["riskCount"].intValue
        self.reportnumber = json["reportnumber"].stringValue
        self.authflag = json["authflag"].intValue
        self.reportType = json["reportType"].intValue
        self.templatepath = json["templatepath"].stringValue
        self.descprtion = json["descprtion"].stringValue
        self.forshort = json["forshort"].stringValue
        self.count = json["count"].stringValue
        self.ossUrl = json["ossUrl"].stringValue
        self.timeliness = json["timeliness"].stringValue
        self.publish_date = json["publish_date"].stringValue
        self.law_category = json["law_category"].stringValue
        self.formulating_authority = json["formulating_authority"].stringValue
        self.title = json["title"].stringValue
        self.pdfUrl = json["pdfUrl"].stringValue
        self.publishTime = json["publishTime"].stringValue
        self.shareCode = json["shareCode"].stringValue
        self.shareShortCode = json["shareShortCode"].stringValue
        self.datanumber = json["datanumber"].stringValue
        self.relate = json["relate"].arrayValue.map { $0.stringValue }
        self.entityid = json["entityid"].stringValue
        self.personname = json["personname"].stringValue
        self.riskData = riskDataModel(json: json["riskData"])
        self.high_risk = json["high_risk"].intValue
        self.high_risk_sum = json["high_risk_sum"].intValue
        self.hint = json["hint"].intValue
        self.hint_sum = json["hint_sum"].intValue
        self.low_risk = json["low_risk"].intValue
        self.low_risk_sum = json["low_risk_sum"].intValue
        self.riskSumup = json["riskSumup"].intValue
        self.firstate = json["firstate"].stringValue
        self.entity_id = json["entity_id"].stringValue
        self.positions = json["positions"].arrayValue.map { riskMonitorPersonDtoListModel(json: $0) }
        self.riskMonitorPersonDtoList = json["riskMonitorPersonDtoList"].arrayValue.map { riskMonitorPersonDtoListModel(json: $0) }
        self.riskdynamicid = json["riskdynamicid"].stringValue
        self.risktime = json["risktime"].stringValue
        self.entity_name = json["entity_name"].stringValue
        self.caseproperty = json["caseproperty"].stringValue
        self.highCount = json["highCount"].intValue
        self.hintCount = json["hintCount"].intValue
        self.lowCount = json["lowCount"].intValue
        self.itemnumber = json["itemnumber"].stringValue
        self.size = json["size"].intValue
        self.itemname = json["itemname"].stringValue
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
        
        self.dynamicContent = json["dynamicContent"].arrayValue.map {
            dynamiccontentModel(json: $0)
        }
        self.itemName = json["itemName"].stringValue
        self.createtime = json["createtime"].stringValue
        self.riskLevel = json["riskLevel"].stringValue
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
        self.subitems = json["subitems"].arrayValue.map { subitemsModel(json: $0) }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "code": self.code ?? "",
            "name": self.name ?? "",
            "levelKey": self.levelKey ?? "",
            "select": self.select ?? "",
            "value": self.value ?? "",
            "items": self.items?.map { $0.toDictionary() } ?? []
        ]
    }
    
}

class riskDataModel {
    var risktime: String?
    var itemname: String?
    init(json: JSON) {
        self.risktime = json["risktime"].stringValue
        self.itemname = json["itemname"].stringValue
    }
}

class riskMonitorPersonDtoListModel {
    var monitorFlag: String?
    var personName: String?
    var personId: String?
    var logoColor: String?
    var positions: [String]?
    var isClickMonitoring: Bool//自定义,是否点击了☑️按钮
    init(json: JSON) {
        self.monitorFlag = json["monitorFlag"].stringValue
        self.personName = json["personName"].stringValue
        self.personId = json["personId"].stringValue
        self.logoColor = json["logoColor"].stringValue
        self.positions = json["positions"].arrayValue.map { $0.stringValue }
        self.isClickMonitoring = json["isClickMonitoring"].boolValue
    }
}

class listCompanyModel {
    var count: Int?
    var orgName: String?
    var province: String?
    var percent: String?
    var entityName: String?
    var shrInfo: String?
    var positions: String?
    init(json: JSON) {
        self.positions = json["positions"].stringValue
        self.shrInfo = json["shrInfo"].stringValue
        self.entityName = json["entityName"].stringValue
        self.orgName = json["orgName"].stringValue
        self.province = json["province"].stringValue
        self.count = json["count"].intValue
        self.percent = json["percent"].stringValue
    }
}

class shareholderListModel {
    var count: Int?
    var orgName: String?
    var personId: Int?
    var personName: String?
    var name: String?
    var logoColor: String?
    init(json: JSON) {
        self.logoColor = json["logoColor"].stringValue
        self.count = json["count"].intValue
        self.orgName = json["orgName"].stringValue
        self.personId = json["personId"].intValue
        self.personName = json["personName"].stringValue
        self.name = json["name"].stringValue
    }
}

class childrenModel {
    var icon: String?
    var iconGrey: String?
    var menuName: String?
    var path: String?//请求地址
    var menuId: String?
    var children: [childrenModel]?
    var name: String?
    var code: String?
    var clickFlag: Int?
    init(json: JSON) {
        self.children = json["children"].arrayValue.map { childrenModel(json: $0) }
        self.icon = json["icon"].stringValue
        self.iconGrey = json["iconGrey"].stringValue
        self.menuName = json["menuName"].stringValue
        self.path = json["path"].stringValue
        self.menuId = json["menuId"].stringValue
        self.name = json["name"].stringValue
        self.code = json["code"].stringValue
        self.clickFlag = json["clickFlag"].intValue
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
    var entityid: String?
    var filepathH5: String?//h5链接
    var downloadfilename: String?//名称
    var dataid: String?//id号
    var entityId: String?
    var entityName: String?
    var legalType: String?
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
    var itemName: String?
    var risklevel: String?
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
    var personnumber: String?
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
    var eid: String?//ID
    var type: String?//1企业 2个人
    var searchContent: String?
    var relateEntityName: String?
    var shareholderFlag: Bool?
    var legalFlag: Bool?
    var percent: String?
    var positionName: String?
    var regStatus: String?
    var firmnumber: String?
    var items: [itemsModel]?
    var legalName: String?
    var registerCapital: String?
    var incorporationTime: String?
    var relatedEntity: [relatedEntityModel]?
    var tags: [newstagsobjModel]?
    var viewrecordtype: String?
    var feedbacktype: String?
    var feedbacksubtype: String?
    var question: String?
    var piclist: [String]?
    var orgName: String?
    var groupName: String?
    var groupId: String?
    var startDate: String?
    var endDate: String?
    var orgId: String?//企业ID
    var personId: String?//人员ID
    var curHighRiskCnt: Int?
    var curLowRiskCnt: Int?
    var curRiskCnt: Int?
    var curTipRiskCnt: Int?
    var totalHighRiskCnt: Int?
    var totalLowRiskCnt: Int?
    var totalRiskCnt: Int?
    var totalTipRiskCnt: Int?
    var recentRisk: String?
    var monitorFlag: String?//是否被监控0未监控 1已监控
    var riskMonitorPersonDtoList: [riskMonitorPersonDtoListModel]?//搜索监控企业
    var positions: [String]?//搜索监控企业
    var logoColor: String?//背景色
    var orgStatus: String?
    var personName: String?
    var monitorCnt: Int?
    var appleById: Int?//单项付费ID
    var leaderVec: leaderVecModel?
    var regCap: String?
    var incDate: String?
    var shr: String?//
    var searchStr: String?
    var listCompany: [listCompanyModel]?
    var shareholderList: [shareholderListModel]?
    var monitor: Bool?
    var publishTime: String?
    var category: String?
    var announcementLink: String?
    var stockShortName: String?
    var stockCode: String?
    var riskId: String?
    var riskName: String?
    var riskTime: String?
    var riskLevel: String?
    var riskLevelDesc: String?
    var key: String?
    var count: Int?
    var h5Path: String?
    var data: [itemsModel]?
    var companyRelation: Bool?
    var personRelation: Bool?
    var legalInfo: [legalInfoModel]?
    init(json: JSON) {
        self.legalInfo = json["legalInfo"].arrayValue.map { legalInfoModel(json: $0) }
        self.personRelation = json["personRelation"].boolValue
        self.companyRelation = json["companyRelation"].boolValue
        self.legalType = json["legalType"].stringValue
        self.data = json["data"].arrayValue.map { itemsModel(json: $0) }
        self.risklevel = json["risklevel"].stringValue
        self.itemName = json["itemName"].stringValue
        self.h5Path = json["h5Path"].stringValue
        self.key = json["key"].stringValue
        self.count = json["count"].intValue
        self.riskId = json["riskId"].stringValue
        self.riskName = json["riskName"].stringValue
        self.riskTime = json["riskTime"].stringValue
        self.riskLevel = json["riskLevel"].stringValue
        self.riskLevelDesc = json["riskLevelDesc"].stringValue
        self.stockCode = json["stockCode"].stringValue
        self.category = json["category"].stringValue
        self.announcementLink = json["announcementLink"].stringValue
        self.stockShortName = json["stockShortName"].stringValue
        self.publishTime = json["publishTime"].stringValue
        self.monitor = json["monitor"].boolValue
        self.shareholderList = json["shareholderList"].arrayValue.map { shareholderListModel(json: $0) }
        self.listCompany = json["listCompany"].arrayValue.map { listCompanyModel(json: $0) }
        self.searchStr = json["searchStr"].stringValue
        self.shr = json["shr"].stringValue
        self.incDate = json["incDate"].stringValue
        self.regCap = json["regCap"].stringValue
        self.leaderVec = leaderVecModel(json: json["leaderVec"])
        self.appleById = json["appleById"].intValue
        self.monitorCnt = json["monitorCnt"].intValue
        self.personId = json["personId"].stringValue
        self.personName = json["personName"].stringValue
        self.orgStatus = json["orgStatus"].stringValue
        self.logoColor = json["logoColor"].stringValue
        self.groupId = json["groupId"].stringValue
        self.monitorFlag = json["monitorFlag"].stringValue
        self.positions = json["positions"].arrayValue.map { $0.stringValue }
        self.riskMonitorPersonDtoList = json["riskMonitorPersonDtoList"].arrayValue.map { riskMonitorPersonDtoListModel(json: $0) }
        self.recentRisk = json["recentRisk"].stringValue
        self.curHighRiskCnt = json["curHighRiskCnt"].intValue
        self.curLowRiskCnt = json["curLowRiskCnt"].intValue
        self.curRiskCnt = json["curRiskCnt"].intValue
        self.curTipRiskCnt = json["curTipRiskCnt"].intValue
        self.totalHighRiskCnt = json["totalHighRiskCnt"].intValue
        self.totalLowRiskCnt = json["totalLowRiskCnt"].intValue
        self.totalRiskCnt = json["totalRiskCnt"].intValue
        self.totalTipRiskCnt = json["totalTipRiskCnt"].intValue
        self.orgId = json["orgId"].stringValue
        self.startDate = json["startDate"].stringValue
        self.endDate = json["endDate"].stringValue
        self.groupName = json["groupName"].stringValue
        self.orgName = json["orgName"].stringValue
        self.entityid = json["entityid"].stringValue
        self.piclist = json["piclist"].arrayValue.map { $0.stringValue }
        self.question = json["question"].stringValue
        self.feedbacksubtype = json["feedbacksubtype"].stringValue
        self.feedbacktype = json["feedbacktype"].stringValue
        self.personnumber = json["personnumber"].stringValue
        self.viewrecordtype = json["viewrecordtype"].stringValue
        self.tags = json["tags"].arrayValue.map {
            newstagsobjModel(json: $0)
        }
        self.relatedEntity = json["relatedEntity"].arrayValue.map {
            relatedEntityModel(json: $0)
        }
        self.incorporationTime = json["incorporationTime"].stringValue
        self.registerCapital = json["registerCapital"].stringValue
        self.legalName = json["legalName"].stringValue
        self.items = json["items"].arrayValue.map { itemsModel(json: $0) }
        self.personname = json["personname"].stringValue
        self.firmnumber = json["firmnumber"].stringValue
        self.regStatus = json["regStatus"].stringValue
        self.shareholderFlag = json["shareholderFlag"].boolValue
        self.legalFlag = json["legalFlag"].boolValue
        self.percent = json["percent"].stringValue
        self.positionName = json["positionName"].stringValue
        self.relateEntityName = json["relateEntityName"].stringValue
        self.eid = json["id"].stringValue
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

class relatedEntityModel {
    var entityId: String?
    var entityName: String?
    var percent: Double?
    init(json: JSON) {
        self.entityId = json["entityId"].stringValue
        self.entityName = json["entityName"].stringValue
        self.percent = json["percent"].doubleValue
    }
}

class customerFollowListModel {
    var followtargetname: String?
    var createTime: String?
    var entityId: String?
    var dataid: String?
    var firmnamestate: String?
    var logo: String?
    var logoColor: String?
    var personnumber: String?
    init(json: JSON) {
        self.followtargetname = json["followtargetname"].stringValue
        self.createTime = json["createTime"].stringValue
        self.entityId = json["entityId"].stringValue
        self.dataid = json["dataid"].stringValue
        self.firmnamestate = json["firmnamestate"].stringValue
        self.logo = json["logo"].stringValue
        self.logoColor = json["logoColor"].stringValue
        self.personnumber = json["personnumber"].stringValue
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
    var followStatus: Int?//是否被关注 1 没有关注 2 被关注
    var orgInfo: orgInfoModel?
    var leaderVec: leaderVecModel?
    var regAddr: regAddrModel?
    var taxInfo: taxInfoModel?
    init(json: JSON) {
        self.taxInfo = taxInfoModel(json: json["taxInfo"])
        self.regAddr = regAddrModel(json: json["regAddr"])
        self.orgInfo = orgInfoModel(json: json["orgInfo"])
        self.followStatus = json["followStatus"].intValue
        self.searchStr = json["searchStr"].stringValue
        self.firmInfo = firmInfoModel(json: json["firmInfo"])
        self.legalPerson = legalPersonModel(json: json["legalPerson"])
        self.riskInfo = riskInfoModel(json: json["riskInfo"])
        self.labels = json["labels"].arrayValue.map { labelsModel(json: $0) }
        self.leaderVec = leaderVecModel(json: json["leaderVec"])
    }
}

class orgInfoModel {
    var incDate: String?
    var orgId: String?
    var orgName: String?
    var regCap: String?
    var regStatusLabel: String?
    var logo: String?
    var phone: String?
    var website: String?
    var regAddr: regAddrModel?
    var logoColor: String?
    var usCreditCode: String?
    init(json: JSON) {
        self.usCreditCode = json["usCreditCode"].stringValue
        self.logo = json["logo"].stringValue
        self.logoColor = json["logoColor"].stringValue
        self.incDate = json["incDate"].stringValue
        self.orgId = json["orgId"].stringValue
        self.orgName = json["orgName"].stringValue
        self.regCap = json["regCap"].stringValue
        self.regStatusLabel = json["regStatusLabel"].stringValue
        self.phone = json["phone"].stringValue
        self.website = json["website"].stringValue
        self.regAddr = regAddrModel(json: json["regAddr"])
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
    var relevaRiskCnt: Int?
    var selfRiskCnt: Int?
    init(json: JSON) {
        self.content = json["content"].stringValue
        self.riskTime = json["riskTime"].stringValue
        self.relevaRiskCnt = json["relevaRiskCnt"].intValue
        self.selfRiskCnt = json["selfRiskCnt"].intValue
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
    var entityAddress: String?
    var registeredcapital: String?
    init(json: JSON) {
        self.registeredcapital = json["registeredcapital"].stringValue
        self.entityAddress = json["entityAddress"].stringValue
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
        self.industry = json["industry"].arrayValue.map { $0.stringValue }
    }
}

class pageMetaModel {
    var totalNum: Int?//总共
    var size: Int?//页数
    var index: Int?
    init(json: JSON) {
        self.totalNum = json["totalNum"].intValue
        self.size = json["size"].intValue
        self.index = json["index"].intValue
    }
}

class bossListModel {
    var totalNum: Int?
    var items: [itemsModel]?
    init(json: JSON) {
        self.items = json["items"].arrayValue.map { itemsModel(json: $0) }
        self.totalNum = json["totalNum"].intValue
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
    var lastAmount: String?
    var lastYear: String?
    var annualReports: [annualReportsModel]?
    init(json: JSON) {
        self.annualReports = json["annualReports"].arrayValue.map { annualReportsModel(json: $0) }
        self.lastAmount = json["lastAmount"].stringValue
        self.lastYear = json["lastYear"].stringValue
    }
}

class annualReportsModel {
    var number: Int?//人数
    var reportYear: String?
    var amount: String?//利润
    init(json: JSON) {
        self.number = json["number"].intValue
        self.reportYear = json["reportYear"].stringValue
        self.amount = json["amount"].stringValue
    }
}

//利润模型
class incomeInfoModel {
    var lastAmount: String?
    var lastYear: String?
    var annualReports: [annualReportsModel]?
    init(json: JSON) {
        self.annualReports = json["annualReports"].arrayValue.map { annualReportsModel(json: $0) }
        self.lastAmount = json["lastAmount"].stringValue
        self.lastYear = json["lastYear"].stringValue
    }
}

//收益模型
class profitInfoModel {
    var lastAmount: String?
    var lastYear: String?
    var annualReports: [annualReportsModel]?
    init(json: JSON) {
        self.annualReports = json["annualReports"].arrayValue.map { annualReportsModel(json: $0) }
        self.lastAmount = json["lastAmount"].stringValue
        self.lastYear = json["lastYear"].stringValue
    }
}

//主要股东
class shareHoldersModel {
    var id: String?
    var name: String?
    var shRatio: String?
    var relatedNum: Int?
    var category: String?//类型 2公司 1个人
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.shRatio = json["shRatio"].stringValue
        self.relatedNum = json["relatedNum"].intValue
        self.category = json["category"].stringValue
    }
}

//主要人员
class staffInfosModel {
    var orgId: String?//人员ID
    var name: String?
    var positionName: String?
    var relatedNum: Int?
    var logo: String?
    init(json: JSON) {
        self.logo = json["logo"].stringValue
        self.orgId = json["orgId"].stringValue
        self.name = json["name"].stringValue
        self.positionName = json["positionName"].stringValue
        self.relatedNum = json["relatedNum"].intValue
    }
}

//曾用名
class namesUsedBeforeModel {
    var endTime: String?
    var orgId: String?
    var orgName: String?
    var startTime: String?
    init(json: JSON) {
        self.startTime = json["startTime"].stringValue
        self.endTime = json["endTime"].stringValue
        self.orgId = json["orgId"].stringValue
        self.orgName = json["orgName"].stringValue
    }
}

//税号
class taxInfoModel {
    var entityId: String?
    var phone: String?
    var registerAddress: String?
    var taxpayerId: String?
    init(json: JSON) {
        self.phone = json["phone"].stringValue
        self.registerAddress = json["registerAddress"].stringValue
        self.entityId = json["entityId"].stringValue
        self.taxpayerId = json["taxpayerId"].stringValue
    }
}

//总资产
class assetInfoModel {
    var lastAmount: String?
    var lastYear: String?
    var annualReports: [annualReportsModel]?
    init(json: JSON) {
        self.lastAmount = json["lastAmount"].stringValue
        self.lastYear = json["lastYear"].stringValue
        self.annualReports = json["annualReports"].arrayValue.map { annualReportsModel(json: $0) }
    }
}

//标签
class promptLabelsModel {
    var name: String?
    var type: String?
    var url: String?
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.type = json["type"].stringValue
        self.url = json["url"].stringValue
    }
}

class entityRiskEventInfoModel {
    var dynamiccontent: String?
    var riskTime: String?
    init(json: JSON) {
        self.dynamiccontent = json["dynamiccontent"].stringValue
        self.riskTime = json["riskTime"].stringValue
    }
}

class map1Model {
    var riskTime: String?
    var riskInfo: String?
    var riskCnt: String?
    init(json: JSON) {
        self.riskTime = json["riskTime"].stringValue
        self.riskInfo = json["riskInfo"].stringValue
        self.riskCnt = json["riskCnt"].stringValue
    }
}

class riskGradeModel {
    var highRiskSum: String?
    var hintRiskSum: String?
    var lowRiskSum: String?
    var publicRiskSum: String?
    init(json: JSON) {
        self.highRiskSum = json["highRiskSum"].stringValue
        self.hintRiskSum = json["hintRiskSum"].stringValue
        self.lowRiskSum = json["lowRiskSum"].stringValue
        self.publicRiskSum = json["publicRiskSum"].stringValue
    }
}

class rimRiskModel {
    var entityid: String?
    var entityname: String?
    var firmtype: String?
    var relate: String?
    var relatedEntitySize: Int?
    var itemType: [itemTypeModel]?
    init(json: JSON) {
        self.entityid = json["entityid"].stringValue
        self.entityname = json["entityname"].stringValue
        self.firmtype = json["firmtype"].stringValue
        self.relate = json["relate"].stringValue
        self.relatedEntitySize = json["relatedEntitySize"].intValue
        self.itemType = json["itemType"].arrayValue.map { itemTypeModel(json: $0) }
    }
}

class itemTypeModel {
    var count: Int?
    var typeName: String?
    var typeNumber: String?
    init(json: JSON) {
        self.count = json["count"].intValue
        self.typeName = json["typeName"].stringValue
        self.typeNumber = json["typeNumber"].stringValue
    }
}

class subitemsModel {
    var casetype: Int?
    var subitemname: String?
    var isExpanded: Bool  // 用于控制展开状态
    var threelevelitems: [threelevelitemsModel]?
    init(json: JSON) {
        self.isExpanded = json["isExpanded"].boolValue
        self.casetype = json["casetype"].intValue
        self.subitemname = json["subitemname"].stringValue
        self.threelevelitems = json["threelevelitems"].arrayValue.map { threelevelitemsModel(json: $0) }
    }
    
}

class threelevelitemsModel {
    var caseproperty: String?
    var size: Int?
    var threelevelitemname: String?
    init(json: JSON) {
        self.caseproperty = json["caseproperty"].stringValue
        self.size = json["size"].intValue
        self.threelevelitemname = json["threelevelitemname"].stringValue
    }
}


/**
 新模型数据
 */
class itemDtoListModel {
    var itemId: String?//ID
    var haveSon: String?//是否有下一级
    var itemName: String?//名字
    var highLevelCnt: Int?//高风险
    var lowLevelCnt: Int?//低风险
    var tipLevelCnt: Int?//提示
    var totalCnt: Int?//总共
    var orgId: String?//
    var orgName: String?//
    var orgRelaveType: [String]?
    var operationRiskCnt: Int?//经营风险
    var lawRiskCnt: Int?//法律风险
    var financeRiskCnt: Int?//经营风险
    var opinionRiskCnt: Int?//舆情风险
    init(json: JSON) {
        self.orgId = json["orgId"].stringValue
        self.orgName = json["orgName"].stringValue
        self.orgRelaveType = json["orgRelaveType"].arrayValue.map { $0.stringValue }
        self.itemId = json["itemId"].stringValue
        self.haveSon = json["haveSon"].stringValue
        self.itemName = json["itemName"].stringValue
        self.highLevelCnt = json["highLevelCnt"].intValue
        self.lowLevelCnt = json["lowLevelCnt"].intValue
        self.tipLevelCnt = json["tipLevelCnt"].intValue
        self.totalCnt = json["totalCnt"].intValue
        
        self.operationRiskCnt = json["operationRiskCnt"].intValue
        self.lawRiskCnt = json["lawRiskCnt"].intValue
        self.financeRiskCnt = json["financeRiskCnt"].intValue
        self.opinionRiskCnt = json["opinionRiskCnt"].intValue
    }
}

class basicInfoModel {
    var actCap: String?
    var actCapCur: String?
    var incDate: String?
    var industry: [industryModel]?
    var orgId: String?
    var orgName: String?
    var regCap: String?
    var scale: String?
    var usCreditCode: String?
    var regCapCur: String?
    var resume: String?//描述
    init(json: JSON) {
        self.resume = json["resume"].stringValue
        self.regCapCur = json["regCapCur"].stringValue
        self.actCap = json["actCap"].stringValue
        self.actCapCur = json["actCapCur"].stringValue
        self.incDate = json["incDate"].stringValue
        self.orgId = json["orgId"].stringValue
        self.orgName = json["orgName"].stringValue
        self.regCap = json["regCap"].stringValue
        self.scale = json["scale"].stringValue
        self.usCreditCode = json["usCreditCode"].stringValue
        self.industry = json["industry"].arrayValue.map { industryModel(json: $0) }
    }
}

class industryModel {
    var code: String?
    var name: String?
    init(json: JSON) {
        self.code = json["code"].stringValue
        self.name = json["name"].stringValue
    }
}

class provinceStatListModel {
    var count: Int?
    var province: String?
    var repOrgName: String?
    init(json: JSON) {
        self.count = json["count"].intValue
        self.province = json["province"].stringValue
        self.repOrgName = json["repOrgName"].stringValue
    }
}

class regAddrModel {
    var content: String?
    var id: String?
    var lat: String?
    var lng: String?
    var orgCount: Int?
    init(json: JSON) {
        self.content = json["content"].stringValue
        self.id = json["id"].stringValue
        self.lat = json["lat"].stringValue
        self.lng = json["lng"].stringValue
        self.orgCount = json["orgCount"].intValue
    }
}

class leaderVecModel {
    var leaderList: [leaderListModel]?
    var leaderType: String?
    var leaderTypeName: String?
    init(json: JSON) {
        self.leaderType = json["leaderType"].stringValue
        self.leaderTypeName = json["leaderTypeName"].stringValue
        self.leaderList = json["leaderList"].arrayValue.map { leaderListModel(json: $0) }
    }
}

class leaderListModel {
    var leaderCategory: String?
    var leaderId: String?
    var name: String?
    init(json: JSON) {
        self.leaderCategory = json["leaderCategory"].stringValue
        self.leaderId = json["leaderId"].stringValue
        self.name = json["name"].stringValue
    }
}

class contactInfoCountModel {
    var addressCount: Int?
    var emailCount: Int?
    var phoneCount: Int?
    var webSiteCount: Int?
    var wechatCount: Int?
    init(json: JSON) {
        self.addressCount = json["addressCount"].intValue
        self.emailCount = json["emailCount"].intValue
        self.phoneCount = json["phoneCount"].intValue
        self.webSiteCount = json["webSiteCount"].intValue
        self.wechatCount = json["wechatCount"].intValue
    }
}

class phoneListModel {
    var phone: String?
    var year: String?
    var source: String?
    var orgCount: String?
    init(json: JSON) {
        self.phone = json["phone"].stringValue
        self.year = json["year"].stringValue
        self.source = json["source"].stringValue
        self.orgCount = json["orgCount"].stringValue
    }
}

class addressListModel {
    var address: String?
    var lng: String?
    var lat: String?
    var orgCount: String?
    var type: String?
    var source: String?
    init(json: JSON) {
        self.address = json["address"].stringValue
        self.lng = json["lng"].stringValue
        self.lat = json["lat"].stringValue
        self.orgCount = json["orgCount"].stringValue
        self.type = json["type"].stringValue
        self.source = json["source"].stringValue
    }
}

class websitesListModel {
    var website: String?
    var year: String?
    var orgCount: String?
    var source: String?
    var icpFlag: Bool?
    var owFlag: Bool?
    var value: String?
    init(json: JSON) {
        self.value = json["value"].stringValue
        self.website = json["website"].stringValue
        self.year = json["year"].stringValue
        self.orgCount = json["orgCount"].stringValue
        self.source = json["source"].stringValue
        self.icpFlag = json["icpFlag"].boolValue
        self.owFlag = json["owFlag"].boolValue
    }
}

class emailListModel {
    var emailId: String?
    var email: String?
    var year: String?
    var source: String?
    var orgCount: String?
    init(json: JSON) {
        self.emailId = json["emailId"].stringValue
        self.email = json["email"].stringValue
        self.year = json["year"].stringValue
        self.source = json["source"].stringValue
        self.orgCount = json["orgCount"].stringValue
    }
}

class wechatListModel {
    var wechatId: String?
    var wechat: String?
    var title: String?
    var imgUrl: String?
    var year: String?
    var source: String?
    var orgCount: String?
    init(json: JSON) {
        self.wechatId = json["wechatId"].stringValue
        self.wechat = json["wechat"].stringValue
        self.title = json["title"].stringValue
        self.imgUrl = json["imgUrl"].stringValue
        self.year = json["year"].stringValue
        self.source = json["source"].stringValue
        self.orgCount = json["orgCount"].stringValue
    }
}

class monitorInfoModel {
    var monitorStatus: Int?
    init(json: JSON) {
        self.monitorStatus = json["monitorStatus"].intValue
    }
}

class lawNatureListModel {
    var key: String?
    var count: Int?
    init(json: JSON) {
        self.key = json["key"].stringValue
        self.count = json["count"].intValue
    }
}

class personPageModel {
    var total: Int?
    var data: [DataModel]?
    init(json: JSON) {
        self.total = json["total"].intValue
        self.data = json["data"].arrayValue.map { DataModel(json: $0) }
    }
}

class companyPageModel {
    var total: Int?
    var data: [DataModel]?
    init(json: JSON) {
        self.total = json["total"].intValue
        self.data = json["data"].arrayValue.map { DataModel(json: $0) }
    }
}

class cluesDataListModel {
    var clueDirectionName: String?
    var clueDirectionAbout: String?
    var typeNum: String?
    var typeTotalCount: String?
    var typeTotalValuation: String?
    var totalValuationUnit: String?
    init(json: JSON) {
        self.clueDirectionName = json["clueDirectionName"].stringValue
        self.clueDirectionAbout = json["clueDirectionAbout"].stringValue
        self.typeNum = json["typeNum"].stringValue
        self.typeTotalCount = json["typeTotalCount"].stringValue
        self.typeTotalValuation = json["typeTotalValuation"].stringValue
        self.totalValuationUnit = json["totalValuationUnit"].stringValue
    }
}

class countModel {
    var personCount: Int?
    var orgCount: Int?
    init(json: JSON) {
        self.personCount = json["personCount"].intValue
        self.orgCount = json["orgCount"].intValue
    }
}

class relatedOrgListModel {
    var orgName: String?
    var percent: String?
    init(json: JSON) {
        self.orgName = json["orgName"].stringValue
        self.percent = json["percent"].stringValue
    }
}

class notRelevaRiskDtoModel {
    var highLevelCnt: Int?
    var lowLevelCnt: Int?
    var tipLevelCnt: Int?
    var totalRiskCnt: Int?
    var itemDtoList: [itemDtoListModel]
    init(json: JSON) {
        self.highLevelCnt = json["highLevelCnt"].intValue
        self.lowLevelCnt = json["lowLevelCnt"].intValue
        self.tipLevelCnt = json["tipLevelCnt"].intValue
        self.totalRiskCnt = json["totalRiskCnt"].intValue
        self.itemDtoList = json["itemDtoList"].arrayValue.map { itemDtoListModel(json: $0) }
    }
}

class conditionVOModel {
    var cueObject: [rowsModel]?
    var propertyDirection: [rowsModel]?
    var cueType: [rowsModel]?
    var customRelationFlag: Int?
    init(json: JSON) {
        self.customRelationFlag = json["customRelationFlag"].intValue
        self.cueObject = json["cueObject"].arrayValue.map { rowsModel(json: $0) }
        self.propertyDirection = json["propertyDirection"].arrayValue.map { rowsModel(json: $0) }
        self.cueType = json["cueType"].arrayValue.map { rowsModel(json: $0) }
    }
}

class pageableDataModel {
    var totalElements: Int?//总条数
    var totalValue: String?
    var valueUnit: String?
    var pageItems: [pageItemsModel]?
    var isShowLine: Bool?//自定义
    init(json: JSON) {
        self.isShowLine = json["isShowLine"].boolValue
        self.totalElements = json["totalElements"].intValue
        self.totalValue = json["totalValue"].stringValue
        self.valueUnit = json["valueUnit"].stringValue
        self.pageItems = json["pageItems"].arrayValue.map { pageItemsModel(json: $0) }
    }
}

class pageItemsModel {
    var clueId: String?
    var modelId: String?
    var modelName: String?
    var clueType: String?
    var clueTypeName: String?
    var clueTypeDirectionName: String?
    var detailUrl: String?//H5地址
    var longTimeDes: String?
    var clueAnalyze: String?
    var explanin: String?
    var outList: [outListModel]?
    var innerList: [outListModel]?
    var isShowLine: Bool?//自定义
    var entityName: String?
    var clueClassificationName: String?
    var assetTypeName: String?
    var directionTypeName: String?
    var clueName: String?
    init(json: JSON) {
        self.clueName = json["clueName"].stringValue
        self.assetTypeName = json["assetTypeName"].stringValue
        self.directionTypeName = json["directionTypeName"].stringValue
        self.clueClassificationName = json["clueClassificationName"].stringValue
        self.explanin = json["explanin"].stringValue
        self.entityName = json["entityName"].stringValue
        self.isShowLine = json["isShowLine"].boolValue
        self.clueId = json["clueId"].stringValue
        self.modelId = json["modelId"].stringValue
        self.modelName = json["modelName"].stringValue
        self.clueType = json["clueType"].stringValue
        self.clueTypeName = json["clueTypeName"].stringValue
        self.clueTypeDirectionName = json["clueTypeDirectionName"].stringValue
        self.detailUrl = json["detailUrl"].stringValue
        self.longTimeDes = json["longTimeDes"].stringValue
        self.clueAnalyze = json["clueAnalyze"].stringValue
        self.outList = json["outList"].arrayValue.map { outListModel(json: $0) }
        self.innerList = json["innerList"].arrayValue.map { outListModel(json: $0) }
    }
}

class outListModel {
    var itemKey: String?
    var itemValue: String?
    init(json: JSON) {
        self.itemKey = json["itemKey"].stringValue
        self.itemValue = json["itemValue"].stringValue
    }
}

class monitorRelationVOListModel {
    var subjectId: Int?
    var entityId: Int?
    var entityName: String?
    var entityType: Int?
    var relation: Int?
    var relationName: String?
    var shareholdingRatio: String?
    var customRelation: Int?
    var select: Bool?//是否点选了。自己加的..
    init(json: JSON) {
        self.select = json["select"].boolValue
        self.subjectId = json["subjectId"].intValue
        self.entityId = json["entityId"].intValue
        self.entityName = json["entityName"].stringValue
        self.entityType = json["entityType"].intValue
        self.relation = json["relation"].intValue
        self.relationName = json["relationName"].stringValue
        self.shareholdingRatio = json["shareholdingRatio"].stringValue
        self.customRelation = json["customRelation"].intValue
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "subjectId": self.subjectId ?? "",
            "entityId": self.entityId ?? "",
            "entityName": self.entityName ?? "",
            "entityType": self.entityType ?? "",
            "relation": self.relation ?? "",
            "relationName": self.relationName ?? "",
            "shareholdingRatio": self.shareholdingRatio ?? "",
            "customRelation": self.customRelation ?? ""
        ]
    }
}

class legalInfoModel {
    var legal_id: Int?
    var legal_name: String?
    var legal_type: Int?
    init(json: JSON) {
        self.legal_id = json["legal_id"].intValue
        self.legal_type = json["legal_type"].intValue
        self.legal_name = json["legal_name"].stringValue
    }
}
