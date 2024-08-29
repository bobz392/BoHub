//
//  ServiceProvider.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import Foundation
import RxSwift

public protocol ServiceProviderType: AnyObject {
    // Auth Services
    var boHubService: BoHubServiceType { get }
}

public final class ServiceProvider: ServiceProviderType {
    public let boHubService: BoHubServiceType
    
    public init() {
        let standardNetwork = BoHubNetwork.createStandard()
        self.boHubService = BoHubServiceImpl(networkType: standardNetwork)
    }
}
