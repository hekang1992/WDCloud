//
//  ServerDataManager.swift
//  问道云
//
//  Created by Andrew on 2025/3/5.
//

import UIKit

//行业
class IndustruDataManager {
    
    static let shared = IndustruDataManager()
    
    private init() {}
    
    private var serverData: [rowsModel] = []
    
    func saveData(_ data: [rowsModel]) {
        serverData = data
    }
    
    func getData() -> [rowsModel] {
        return serverData
    }
    
    func clearData() {
        serverData = []
    }
    
}

//地区
class RegionDataManager {
    
    static let shared = RegionDataManager()
    
    private init() {}
    
    private var serverData: [rowsModel] = []
    
    func saveData(_ data: [rowsModel]) {
        serverData = data
    }
    
    func getData() -> [rowsModel] {
        return serverData
    }
    
    func clearData() {
        serverData = []
    }
    
}

