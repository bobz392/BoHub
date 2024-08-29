//
//  BoHubTargetType.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import Foundation
import Moya

enum BoHubTargetType {
    case users(since: Int?)
    case userDetails(name: String)
    case repos(name: String)
    
    public var multiTarget: MultiTarget {
        return MultiTarget(self)
    }
}

extension BoHubTargetType: TargetType {
    var baseURL: URL {
        return URL(string:"https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .users:
            return "/users"
        case .userDetails(let name):
            return "/users/\(name)"
        case .repos(let name):
            return "/users/\(name)/repos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .users, .userDetails, .repos:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .users(let since):
            if let since = since {
                return .requestParameters(parameters: [
                    "since": since
                ], encoding: URLEncoding.queryString)
            } else {
                return .requestPlain
            }
        case .userDetails, .repos:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "X-GitHub-Api-Version": "2022-11-28",
            "Accept": "application/vnd.github+json",
        ]
    }
}

extension BoHubTargetType: AccessTokenAuthorizable {
    var authorizationType: Moya.AuthorizationType? {
        return .bearer
    }
}
