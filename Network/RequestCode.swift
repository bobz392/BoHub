//
//  RequestCode.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import Foundation

protocol NetworkError: Error {}
public enum RequestError: NetworkError {
    case jsonDecodeError(String)
    case serverCode(Int, String)
    case httpCode(Int, String)
    case taskError(String)
    
    public var info: (title: String, message: String) {
        switch self {
        case .httpCode(let code, let message):
            return ("API エラー: \(code)", message)
        case .jsonDecodeError(let message):
            return ("応答エラー", message)
        case .serverCode(let code, let message):
            return ("リクエストエラー: \(code)", message)
        case .taskError(let message):
            return ("", message)
        }
    }
}


public enum ServerCode: Int {
    case success = 200
    case unkown = 0
    
    public static func fromCode(code: Int) -> ServerCode{
        return ServerCode(rawValue: code) ?? .unkown
    }
}
