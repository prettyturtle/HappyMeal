//
//  MealInfoResponse.swift
//  HappyMeal
//
//  Created by yc on 2022/05/30.
//

import Foundation

struct MealInfoResponse: Codable {
    let mealServiceDietInfo: [MealServiceDietInfo]
    
    struct MealServiceDietInfo: Codable {
        let head: [Head]?
        let row: [Row]?
        
        struct Head: Codable {
            let listTotalCount: Int?
            let result: Result?
            enum CodingKeys: String, CodingKey {
                case listTotalCount = "list_total_count"
                case result = "RESULT"
            }
            
            struct Result: Codable {
                let code: String
                let message: String
                enum CodingKeys: String, CodingKey {
                    case code = "CODE"
                    case message = "MESSAGE"
                }
            }
        }
        
        struct Row: Codable {
            let breakfastLunchDinner: String
            let mealInfo: String
            let originInfo: String
            let calorieInfo: String
            let nutritionInfo: String
            enum CodingKeys: String, CodingKey {
                case breakfastLunchDinner = "MMEAL_SC_NM"
                case mealInfo = "DDISH_NM"
                case originInfo = "ORPLC_INFO"
                case calorieInfo = "CAL_INFO"
                case nutritionInfo = "NTR_INFO"
            }
        }
    }
}
