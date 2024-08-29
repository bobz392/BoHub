//
//  ViewModelType.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import Foundation

// MARK: - view model abstraction
public protocol ViewModelType {
    /// view send command to view model
    associatedtype Input
    /// bind observable from consequences
    associatedtype Output

    // MARK: - getters
    var input: Input { get }
    var output: Output { get }
}
