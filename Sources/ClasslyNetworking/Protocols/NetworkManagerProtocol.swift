//
//  File.swift
//  ClasslyNetworking
//
//  Created by Juan Carlos Hernandez Castillo on 7/04/25.
//

import Foundation

public protocol NetworkManagerProtocol {
    func performRequest<T: Request>(_ request: T) async throws -> T.Response
}
