//
//  UserListViewModel.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import Foundation
import RxSwift
import RxCocoa

public enum UserListRequestAction {
    case refresh
    case loadMore(lastestId: Int)
}
// MARK: - UserListViewModel
public final class UserListViewModel: ViewModelType {
    
    public var input: Input
    public var output: Output
    
    let serviceProvider: ServiceProviderType
    private var lastestUserId: Int? = nil
    
    public struct Input {
        // prepare for next page id
        let requestNextPage: AnyObserver<UserListRequestAction>
    }
    
    private let nextPageSubject = PublishSubject<UserListRequestAction>()
    
    public struct Output {
        let usersResult: Observable<UserListResult>
        let users: Observable<[UserModel]>
        let loading: Observable<Bool>
    }
    
    public init(serviceProvider: ServiceProviderType) {
        self.input = Input(
            requestNextPage: nextPageSubject.asObserver()
        )
        
        let userResult = nextPageSubject
            .map({ action in
                switch action {
                case .refresh:
                    return nil
                case .loadMore(let lastestId):
                    print("requesting \(lastestId)")
                    return lastestId
                }
            })
            .distinctUntilChanged()
            .flatMap(serviceProvider.boHubService.getUserList)
            .share(replay: 1)
        
        let users = userResult
            .map { result in
                switch result {
                case .success(let new):
                    return new
                case.failure:
                    return []
                }
            }
            .scan([UserModel](), accumulator: { aggregate, new in
                return aggregate + new
            })
        
        let beginLoading = nextPageSubject.map { _ in true }
        let endLoading = userResult.map({ _ in false })
        
        self.output = Output(
            usersResult: userResult,
            users: users,
            loading: Observable.merge(beginLoading, endLoading)
        )
        
        self.serviceProvider = serviceProvider
    }
    
    public func mapUserList(result: UserListResult) -> Observable<[UserModel]> {
        switch result {
        case .success(let users):
            self.lastestUserId = users.last?.id
            return Observable.just(users)
        case .failure(_): // regardless of the ux changes for demo
            return Observable.just([])
        }
    }
    
    public func refreshNextPageIfNeed(row: Int, users: [UserModel]) -> Observable<UserListRequestAction> {
        guard let userId = self.lastestUserId else {
            return Observable.empty()
        }
        if users[row].id == userId {
            return Observable.just(.loadMore(lastestId: userId))
        } else {
            return Observable.empty()
        }
    }
}
