//
//  Network_MealFetcher.swift
//  HappyMeal
//
//  Created by yc on 2022/05/30.
//

import Foundation
import Alamofire

struct MealFetcher {
    private let url = "https://open.neis.go.kr/hub/mealServiceDietInfo"
    let schoolInfo: SchoolInfo
    let dateString: String
    
    enum Parameter: String, CaseIterable {
        case key = "KEY"
        case type = "Type"
        case pIndex
        case pSize
        
        var title: String { self.rawValue }
        var value: String {
            switch self {
            case .key: return "54cc6412825d4d409f7dd27dc8c45edd"
            case .type: return "json"
            case .pIndex: return "1"
            case .pSize: return "100"
            }
        }
    }
    
    func fetchMeal(completion: @escaping (Result<MealInfoResponse.MealServiceDietInfo.Row, Error>) -> Void) {
        
        var params = [String: String]()
        
        _ = Parameter.allCases.map { params[$0.title] = $0.value }
        params["SD_SCHUL_CODE"] = schoolInfo.schoolCode
        params["ATPT_OFCDC_SC_CODE"] = schoolInfo.officeCode
        params["MLSV_YMD"] = dateString
        
        AF
            .request(
                url,
                method: .get,
                parameters: params
            )
            .responseDecodable(of: MealInfoResponse.self) { res in
                switch res.result {
                case .success(let mealInfoResponse):
                    guard let row = mealInfoResponse.mealServiceDietInfo.compactMap({ $0.row }).first?.first else { return }
                    completion(.success(row))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
