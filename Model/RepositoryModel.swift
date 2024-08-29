//
//  RepositoryModel.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import Foundation

public struct RepositoryModel: Codable {
    let id: Int
    let nodeId: String
    let name: String
    let fullName: String
    let `private`: Bool
    let owner: OwnerModel
    let htmlUrl: String
    let description: String?
    let fork: Bool
    let url: String
    let forksUrl: String
    let keysUrl: String
    let collaboratorsUrl: String
    let teamsUrl: String
    let hooksUrl: String
    let issueEventsUrl: String
    let eventsUrl: String
    let assigneesUrl: String
    let branchesUrl: String
    let tagsUrl: String
    let blobsUrl: String
    let gitTagsUrl: String
    let gitRefsUrl: String
    let treesUrl: String
    let statusesUrl: String
    let languagesUrl: String
    let stargazersUrl: String
    let contributorsUrl: String
    let subscribersUrl: String
    let subscriptionUrl: String
    let commitsUrl: String
    let gitCommitsUrl: String
    let commentsUrl: String
    let issueCommentUrl: String
    let contentsUrl: String
    let compareUrl: String
    let mergesUrl: String
    let archiveUrl: String
    let downloadsUrl: String
    let issuesUrl: String
    let pullsUrl: String
    let milestonesUrl: String
    let notificationsUrl: String
    let labelsUrl: String
    let releasesUrl: String
    let deploymentsUrl: String
    let createdAt: String?
    let updatedAt: String?
    let pushedAt: String?
    let gitUrl: String
    let sshUrl: String
    let cloneUrl: String
    let svnUrl: String
    let homepage: String?
    let size: Int
    let stargazersCount: Int
    let watchersCount: Int
    let language: String?
    let hasIssues: Bool
    let hasProjects: Bool
    let hasDownloads: Bool
    let hasWiki: Bool
    let hasPages: Bool
    let hasDiscussions: Bool
    let forksCount: Int
    let mirrorUrl: String?
    let archived: Bool
    let disabled: Bool
    let openIssuesCount: Int
    let license: LicenseModel?
    let allowForking: Bool
    let isTemplate: Bool
    let webCommitSignoffRequired: Bool
    let topics: [String]
    let visibility: String
    let forks: Int
    let openIssues: Int
    let watchers: Int
    let defaultBranch: String
    
    public struct LicenseModel: Codable {
        @Default<Empty> var key: String
        @Default<Empty> var name: String
        @Default<Empty> var spdxId: String
        @Default<Empty> var url: String
        @Default<Empty> var nodeId: String
    }
    
    public struct OwnerModel: Codable {
        let login: String
        let id: Int
        let nodeId: String
        let avatarUrl: String
        let gravatarId: String
        let url: String
        let htmlUrl: String
        let followersUrl: String
        let followingUrl: String
        let gistsUrl: String
        let starredUrl: String
        let subscriptionsUrl: String
        let organizationsUrl: String
        let reposUrl: String
        let eventsUrl: String
        let receivedEventsUrl: String
        let type: String
        let siteAdmin: Bool
    }
}

