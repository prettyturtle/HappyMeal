//
//  Network_SchoolInfoFetcher.swift
//  HappyMeal
//
//  Created by yc on 2022/05/30.
//

import Foundation
import Alamofire

struct SchoolInfoFetcher {
    private let url = "https://open.neis.go.kr/hub/schoolInfo"
    let schoolName: String
    
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
    
    func fetchAllSchool(
        completion: @escaping (Result<[SchoolInfoResponse.SchoolInfo.Row], Error>
        ) -> Void) {
        var params = [String: String]()
        _ = Parameter.allCases.map {
            params[$0.title] = $0.value
        }
        params["SCHUL_NM"] = schoolName
        
        AF
            .request(url, method: .get, parameters: params)
            .responseDecodable(of: SchoolInfoResponse.self) { res in
                switch res.result {
                case .success(let totalSchoolInfo):
                    guard let rows = totalSchoolInfo.schoolInfo
                        .compactMap({ $0.row }).first else { return }
                    completion(.success(rows))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
        
    }
}
