//
//  SchoolInfoResponse.swift
//  HappyMeal
//
//  Created by yc on 2022/05/30.
//

import Foundation

struct SchoolInfoResponse: Codable {
    let schoolInfo: [SchoolInfo]
    
    struct SchoolInfo: Codable {
        let row: [Row]?
        
        struct Row: Codable {
            let officeCode: String
            let schoolCode: String
            let schoolName: String
            
            enum CodingKeys: String, CodingKey {
                case officeCode = "ATPT_OFCDC_SC_CODE"
                case schoolCode = "SD_SCHUL_CODE"
                case schoolName = "SCHUL_NM"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case row
        }
    }
    enum CodingKeys: String, CodingKey {
        case schoolInfo
    }
}
