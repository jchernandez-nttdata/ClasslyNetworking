//
//  File.swift
//  ClasslyNetworking
//
//  Created by Juan Carlos Hernandez Castillo on 7/04/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case encodingFailed(Error)
}
