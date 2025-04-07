//
//  File.swift
//  ClasslyNetworking
//
//  Created by Juan Carlos Hernandez Castillo on 7/04/25.
//

import Foundation

public protocol RequestWithBody: Request {
    associatedtype Body: Encodable

    var body: Body { get }
}
