//
//  APIService.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/09/08.
//

import Foundation

protocol Requestable {
    func request<T: Response>(_ request: URLRequest) async throws -> T?
}

class APIService: Requestable {
    func request<T: Response>(_ request: URLRequest) async throws -> T? {
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(BaseResponse<T>.self, from: data)
        return decodedData.data
    }
}
