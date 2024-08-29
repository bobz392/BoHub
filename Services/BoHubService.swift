//
//  BoHubService.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import Foundation
import RxSwift

// MARK: - typealias
public typealias UserListResult = Result<[UserModel], RequestError>
public typealias UserDetailResult = Result<UserDetailModel, RequestError>
public typealias RepositoriesResult = Result<[RepositoryModel], RequestError>

public protocol BoHubServiceType {
    func getUserList(since: Int?) -> Observable<UserListResult>
    func getUserDetail(username: String) -> Observable<UserDetailResult>
    func getUserRepositories(username: String) -> Observable<RepositoriesResult>
}


// MARK: - BoHubServiceType Impl
public struct BoHubServiceImpl {
    private let networkType: NetworkType
    
    public init(networkType: NetworkType) {
        self.networkType = networkType
    }
}

// MARK: service impl
extension BoHubServiceImpl: BoHubServiceType {
    public func getUserRepositories(
        username: String) -> Observable<RepositoriesResult> {
        return networkType.requestResult(
            target: BoHubTargetType.repos(name: username).multiTarget
        )
    }
    
    
    public func getUserList(since: Int?) -> Observable<UserListResult> {
        return networkType.requestResult(
            target: BoHubTargetType.users(since: since).multiTarget
        )
    }
    
    public func getUserDetail(username: String) -> Observable<UserDetailResult> {
        return networkType.requestResult(
            target: BoHubTargetType.userDetails(name: username).multiTarget
        )
    }
}
