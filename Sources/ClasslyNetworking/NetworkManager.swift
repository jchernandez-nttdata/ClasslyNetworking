//
//  File.swift
//  ClasslyNetworking
//
//  Created by Juan Carlos Hernandez Castillo on 7/04/25.
//

import Foundation

public final class NetworkManager: NetworkManagerProtocol {
    private let encoder = JSONEncoder()
    private let urlSession: URLSession
    private let jsonDecoder = JSONDecoder()

    /// Initializes the NetworkManager with a URLSession.
    /// - Parameter urlSession: The URLSession to be used for network requests. Defaults to URLSession.shared.
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    /// Performs a network request and returns the decoded response.
    /// - Parameter request: The network request to be performed.
    /// - Returns: The decoded response of the request.
    /// - Throws: NetworkError if the request fails or the response cannot be decoded.
    public func performRequest<T: Request>(_ request: T) async throws -> T.Response {
        let urlRequest = try configureURLRequest(request)
        debugLog("➡️ Performing request: \(urlRequest.httpMethod ?? "") \(urlRequest.url?.absoluteString ?? "")")
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponseType
            }

            debugLog("⬅️ Status code: \(httpResponse.statusCode)")
            debugLog("📍 URL: \(httpResponse.url?.absoluteString ?? "nil")")
            debugLog("🧾 Headers:")
            for (key, value) in httpResponse.allHeaderFields {
                debugLog("   \(key): \(value)")
            }

            if let bodyString = String(data: data, encoding: .utf8) {
                debugLog("📦 Body:\n\(bodyString)")
            } else {
                debugLog("❌ No body or unable to decode.")
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
            }

            let decodedResponse: T.Response = try decodeData(data)
            return decodedResponse
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }

    private func configureURLRequest<T: Request>(_ request: T) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: request.completeURLString) else {
            throw NetworkError.invalidURL
        }
        if let params = request.params {
            urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.urlMethod.rawValue
        urlRequest.timeoutInterval = 30
        if let requestWithBody = request as? (any RequestWithBody) {
            urlRequest.httpBody = try encode(requestWithBody.body)
        }
        request.headers.forEach { header in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        return urlRequest
    }

    private func encode(_ value: Encodable) throws -> Data {
        do {
            return try encoder.encode(value)
        } catch {
            throw NetworkError.encodingFailed(error)
        }
    }

    private func decodeData<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }

    private func debugLog(_ message: String) {
#if DEBUG
        print("📡 [NetworkManager] \(message)")
#endif
    }
}
