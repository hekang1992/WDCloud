//
//  RequestManager.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import Moya
import SwiftyJSON
import MBProgressHUD_WJExtension

enum APIService {
    case requestAPI(params: [String: Any]?, pageUrl: String, method: Moya.Method)
    case uploadImageAPI(params: [String: Any]?, pageUrl: String, data: Data, method: Moya.Method)
    case uploadDataAPI(params: [String: Any]?, pageUrl: String, method: Moya.Method)
}

extension APIService: TargetType {
    var baseURL: URL {
        let baseUrl = base_url + "/prod-api"
        return URL(string: baseUrl)!
    }
    
    var path: String {
        switch self {
        case .requestAPI(_, let pageUrl, _),
                .uploadImageAPI(_, let pageUrl, _, _),
                .uploadDataAPI(_, let pageUrl, _):
            return pageUrl
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestAPI(_, _, let method),
                .uploadImageAPI(_, _, _, let method),
                .uploadDataAPI(_, _, let method):
            return method
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .requestAPI(let params, _, let method):
            if method == .get {
                return .requestParameters(parameters: params ?? [:], encoding: URLEncoding.default)
            }else {
                return .requestParameters(parameters: params ?? [:], encoding: JSONEncoding.default)
            }
            
        case .uploadImageAPI(let params, _, let data, _):
            var formData = [MultipartFormData]()
            formData.append(MultipartFormData(provider: .data(data), name: "shock", fileName: "shock.png", mimeType: "image/png"))
            if let params = params {
                for (key, value) in params {
                    if let value = value as? String, let data = value.data(using: .utf8) {
                        formData.append(MultipartFormData(provider: .data(data), name: key))
                    }
                }
            }
            return .uploadMultipart(formData)
            
        case .uploadDataAPI(let params, _, _):
            var formData = [MultipartFormData]()
            if let params = params {
                for (key, value) in params {
                    if let value = value as? String, let data = value.data(using: .utf8) {
                        formData.append(MultipartFormData(provider: .data(data), name: key))
                    }
                }
            }
            return .uploadMultipart(formData)
        }
    }
    
    var headers: [String: String]? {
        var headers = [String: String]()
        headers["Accept"] = "application/json"
        headers["Connection"] = "keep-alive"
        headers["x-sld-client-version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        var sessionID: String = ""
        if let sessionId: String = UserDefaults.standard.object(forKey: WDY_SESSIONID) as? String {
            sessionID = sessionId
        }
        headers["Authorization"] = "Bearer " + sessionID
        return headers
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

class RequestManager: NSObject {

    private let provider = MoyaProvider<APIService>()
    
    private func requestData(target: APIService, completion: @escaping (Result<BaseModel, Error>) -> Void) {
        ViewHud.addLoadView()
        provider.request(target) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                    let baseModel = BaseModel(json: json)
                    self.handleResponse(baseModel: baseModel, completion: completion)
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func handleResponse(baseModel: BaseModel, completion: @escaping (Result<BaseModel, Error>) -> Void) {
        let msg = baseModel.msg ?? ""
        let code = baseModel.code ?? 0
        if code == 200 {
            completion(.success(baseModel))
        } else {
            if code == 401 {
                let vc = UIViewController.getCurrentViewController() as? WDBaseViewController
                vc?.popLogin()
            }
            let error = NSError()
            completion(.failure(error))
            MBProgressHUD.wj_showPlainText(msg, view: nil)
        }
    }
    
    func requestAPI(params: [String: Any]?, pageUrl: String, method: Moya.Method, completion: @escaping (Result<BaseModel, Error>) -> Void) {
        requestData(target: .requestAPI(params: params, pageUrl: pageUrl, method: method), completion: completion)
    }
    
    func uploadDataAPI(params: [String: Any]?, pageUrl: String, method: Moya.Method, completion: @escaping (Result<BaseModel, Error>) -> Void) {
        requestData(target: .requestAPI(params: params, pageUrl: pageUrl, method: method), completion: completion)
    }
    
    func uploadImageAPI(params: [String: Any]?, pageUrl: String, data: Data, method: Moya.Method, completion: @escaping (Result<BaseModel, Error>) -> Void) {
        requestData(target: .uploadImageAPI(params: params, pageUrl: pageUrl, data: data, method: method), completion: completion)
    }
    
}
