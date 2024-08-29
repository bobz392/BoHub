//
//  BoHubNetwork.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import Moya
import RxSwift
import RxCocoa
import Alamofire

#if DEBUG
func networkPrint(_ items: Any) {
    print("\(Date()) - \(items)")
    print()
}
#else
func networkPrint(_ items: Any) {}
#endif

// MARK: - type alias
public typealias VoidResult = Result<Void, RequestError>

// MARK: - NetworkType
public protocol NetworkType {
    // MARK: request
    /// templete T for target response data model
    func requestResult<T: Codable>(target: MultiTarget) -> Observable<Result<T, RequestError>>
    /// void result
    ///
    /// our response has void data structure
    func requestVoidResult(target: MultiTarget) -> Observable<VoidResult>
}

// MARK: - NetworkType
public extension NetworkType {
    /// base network type
    static func createStandard() -> NetworkType {
        let networkPlugin = NetworkActivityPlugin { changeType, target in
#if DEBUG
            switch changeType {
            case .began:
                networkPrint("\(Date()) | request began: \(target.path), \(target.task)")
                switch target.task {
                case .requestParameters(let p, _):
                    networkPrint("\(Date()) | request parameters: \(p)")
                default: break
                }
                
            case .ended: break
            }
#endif
        }
        let accessTokenPlugin = ScanatAuthPlugin { target in
            let token = readToken()
            
            if let authType = target as? AccessTokenAuthorizable,
               authType.authorizationType != nil {
                networkPrint("target -> \(target.path). use token -> \(token)")
                return token
            } else {
                networkPrint("target -> \(target.path). no need token")
                return nil
            }
        }
        
        let session = Alamofire.Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 30
        session.sessionConfiguration.timeoutIntervalForResource = 300
        session.sessionConfiguration.requestCachePolicy = .useProtocolCachePolicy
        
        return BoHubNetwork (
            plugins: [
                networkPlugin,
                accessTokenPlugin
            ],
            session: session
        )
    }
    
    static func readToken() -> String {
        // Locate the file in the bundle
        guard let fileURL = Bundle.main.url(forResource: "env", withExtension: "txt") else {
            fatalError("please add your token to env file")
        }
        
        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            fatalError("Error reading file: \(error)")
        }
    }
}

// MARK: - Network Layer
public final class BoHubNetwork: NetworkType {
    
    /// moya provider
    let networkProvider: MoyaProvider<MultiTarget>
        
    /// Codable decoder
    private let defaultDecoder: JSONDecoder = {
        let jd = JSONDecoder()
        jd.keyDecodingStrategy = .convertFromSnakeCase
        return jd
    }()

    public init(plugins: [PluginType], session: Alamofire.Session) {
        self.networkProvider = MoyaProvider<MultiTarget>(
            session: session,
            plugins: plugins,
            trackInflights: false
        )
    }
    
    public func requestResult<T: Codable>(target: MultiTarget) -> Observable<Result<T, RequestError>> {
        return Observable.create { [unowned self] observable in
            let cancelable = self.networkProvider.request(target) { responseResult in
                switch responseResult {
                case let .success(resp):
                    if let hasError = self.checkServerCode(response: resp, target: target) {
                        observable.onNext(.failure(hasError))
                    } else {
                        do {
                            let data = try resp.map(T.self,
                                                    using: self.defaultDecoder,
                                                    failsOnEmptyData: false)
                            observable.onNext(.success(data))
                        } catch let error {                            
                            observable.onNext(.failure(.jsonDecodeError(error.localizedDescription)))
                        }
                    }
                    
                case let .failure(error):
                    let code = error.response?.statusCode ?? 0
                    observable.onNext(.failure(
                        .httpCode(code, error.localizedDescription)
                    ))
                }
                observable.onCompleted()
            }
            return Disposables.create {
                cancelable.cancel()
            }
        }
    }
    
    public func requestVoidResult(target: MultiTarget) -> Observable<VoidResult> {
        return Observable.create { [unowned self] observable in
            let cancelable = self.networkProvider.request(target) { responseResult in
                switch responseResult {
                case let .success(resp):
                    if let hasError = self.checkServerCode(
                        response: resp, target: target) {
                        observable.onNext(.failure(hasError))
                    } else {
                        observable.onNext(.success(Void()))
                    }
                case let .failure(error):
                    let code = error.response?.statusCode ?? 0
                    observable.onNext(.failure(.httpCode(code, error.localizedDescription)))
                }
                observable.onCompleted()
            }
            return Disposables.create {
                cancelable.cancel()
            }
        }
    }
    
    /// check response's server code is 200
    private func checkServerCode(
        response: Moya.Response, target: MultiTarget
    ) -> RequestError? {
        if let code = try? response.map(
            Int.self,
            atKeyPath: target.codeKey,
            using: self.defaultDecoder,
            failsOnEmptyData: true)
        {
            guard ServerCode.fromCode(code: code) == .success
            else {
                let message = try? response.mapString(atKeyPath: target.messageKey)
                let serverError = RequestError.serverCode(code, message ?? "")
                return serverError
            }
        }
        return nil
    }
}

// MARK: - we have more than one endpoint
extension MultiTarget {
    var codeKey: String {
        return "status"
    }
    
    var messageKey: String {
        return "message"
    }
}

// MARK: - auth plguin
public struct ScanatAuthPlugin: PluginType {
    public typealias AuthClosure = (TargetType) -> String?
    public let authClosure: AuthClosure
    
    public init(authClosure: @escaping AuthClosure) {
        self.authClosure = authClosure
    }
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let authorizable = target as? AccessTokenAuthorizable,
              let authorizationType = authorizable.authorizationType
        else { return request }
        
        var request = request
        let realTarget = (target as? MultiTarget)?.target ?? target
        guard let value = authClosure(realTarget) else { return request }
        let authValue = authorizationType.value + " " + value
        request.addValue(authValue, forHTTPHeaderField: "Authorization")
        return request
    }
}
