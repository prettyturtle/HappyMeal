//
//  UserDefaultsManager.swift
//  HappyMeal
//
//  Created by yc on 2022/06/01.
//

import Foundation

struct UserDefaultsManager {
    private let root = "MySchool"
    private let standard = UserDefaults.standard
    static let shared = UserDefaultsManager()
    
    func setMySchool(schoolInfo: SchoolInfo) -> Bool {
        do {
            let encodedData = try JSONEncoder().encode(schoolInfo)
            standard.set(encodedData, forKey: root)
            return true
        } catch {
            return false
        }
    }
    func checkMySchool() -> Bool {
        let data = standard.value(forKey: root)
        return (data != nil)
    }
    func getMySchool() -> SchoolInfo? {
        guard let data = standard.value(forKey: root) as? Data else { return nil }
        
        do {
            let schoolInfo = try JSONDecoder().decode(SchoolInfo.self, from: data)
            return schoolInfo
        } catch {
            return nil
        }
    }
}
