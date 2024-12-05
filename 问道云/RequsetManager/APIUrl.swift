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
