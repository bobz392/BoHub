//
//  UserDetailViewModel.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - UserDetailViewModel
public final class UserDetailViewModel: ViewModelType {
    
    public var input: Input
    public var output: Output
    
    let serviceProvider: ServiceProviderType
    
    public struct Input {
        let requestUserDetail: AnyObserver<String>
    }
    
    private let usernameSubject = PublishSubject<String>()
    
    public struct Output {
        let userDetailResult: Observable<UserDetailResult>
        let loading: Observable<Bool>
        let repositoriesResult: Observable<RepositoriesResult>
    }
    
    public init(
        serviceProvider: ServiceProviderType
    ) {
        self.input = Input(
            requestUserDetail: usernameSubject.asObserver()
        )
        
        let detailResult = usernameSubject
            .flatMap(serviceProvider.boHubService.getUserDetail)
            .share(replay: 1)
        
        let beginLoading = usernameSubject.map { _ in true }
        let endLoading = detailResult.map({ _ in false })
            .share(replay: 1)
        
        let repositoriesResult = endLoading
            .withLatestFrom(usernameSubject) { $1 }
            .flatMapLatest(serviceProvider.boHubService.getUserRepositories)
            
        self.output = Output(
            userDetailResult: detailResult,
            loading: Observable.merge(beginLoading, endLoading),
            repositoriesResult: repositoriesResult
        )
        
        self.serviceProvider = serviceProvider
    }
    
    public func mapDetailModel(
        result: UserDetailResult
    ) -> Observable<UserDetailModel> {
        switch result {
        case .success(let model):
            return Observable.just(model)
        case .failure:
            return Observable.empty()
        }
    }
    
    public func mapRepositories(
        result: RepositoriesResult
    ) -> Observable<[RepositoryModel]> {
        switch result {
        case .success(let repos):
            return Observable.just(
                repos.filter({ !$0.fork })
            )
        case .failure(_):
            return Observable.just([])
        }
    }
}
