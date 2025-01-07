//
//  APIUrl.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

//域名
let base_url = "https://testh5.wintaocloud.com"
//let base_url = "https://h5.wintaocloud.com"

//用户协议
let agreement_url = "/user-agreement"
//隐私政策
let privacy_url = "/privacy-statement"
//会员协议
let membership_agreement = "/membership-agreement"
//收集协议
let information_collection = "/information-collection"

//请求地址
/**
 登录和验证码模块
 */
let get_code = "/operation/messageVerification/sendcode"
let get_code_login = "/auth/loginmessage"
let rest_password = "/operation/messageVerification/resetpassword"
let password_login = "/auth/customerlogin"

/**
 个人中心
 */
let buymore_info = "/operation/enterpriseclientbm/buymoreinfo"
let myorder_info = "/operation/customerorder/myorder"
let combotype_list = "/operation/combotype/list"
let customerDownload_list = "/operation/mydownload/customerDownload"
let log_out = "/auth/logout"

/**
 发票相关
 */
let invoiceriseit_selecinvoicerise = "/operation/invoiceriseit/selecinvoicerise"//列表
let operation_invoiceriseit = "/operation/invoiceriseit/add"//添加
let invoiceriseit_updateinvoicerise = "/operation/invoiceriseit/updateinvoicerise"//修改
let invoiceriseit_deleteinvoicerise = "/operation/invoiceriseit/deleteinvoicerise"//删除

/**
 个人中心 浏览历史
 */
let browsing_History = "/operation/clientbrowsecb/selectBrowserecord"

/**
 套餐列表
 */
let getCombo_selectmember = "/operation/combo/selectmember"

/**
 首页
 */
let customer_menuTree = "/operation/customermenu/customerMenuTree"//item
let bannerHome_url = "/operation/configurationoc/selectconfigurationenabledstate2"//banner
let browser_hotwords = "/operation/clientbrowsecb/hot-search"
