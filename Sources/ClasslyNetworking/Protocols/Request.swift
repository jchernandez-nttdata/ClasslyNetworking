//
//  File.swift
//  ClasslyNetworking
//
//  Created by Juan Carlos Hernandez Castillo on 7/04/25.
//

import Foundation

public protocol Request {
    associatedtype Response: Decodable

    var urlMethod: HTTPMethod { get set }
    var baseURL: String { get }
    var endpoint: String { get }
    var validStatusCodes: [Int] { get }
    var headers: [String: String?] { get }
    var params: [String: String]? { get }
}

public extension Request {
    var completeURLString: String {
        baseURL+endpoint
    }
}
