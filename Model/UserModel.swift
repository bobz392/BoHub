//
//  UserModel.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import Foundation

public struct UserModel: Codable {
    public let login: String
    public let id: Int
    @Default<Empty> public var nodeId: String
    @Default<Empty> public var avatarUrl: String
    @Default<Empty> public var gravatarId: String
    @Default<Empty> public var url: String
    @Default<Empty> public var htmlUrl: String
    @Default<Empty> public var followersUrl: String
    @Default<Empty> public var followingUrl: String
    @Default<Empty> public var gistsUrl: String
    @Default<Empty> public var starredUrl: String
    @Default<Empty> public var subscriptionsUrl: String
    @Default<Empty> public var organizationsUrl: String
    @Default<Empty> public var reposUrl: String
    @Default<Empty> public var eventsUrl: String
    @Default<Empty> public var receivedEventsUrl: String
    let type: String
    let siteAdmin: Bool
}
