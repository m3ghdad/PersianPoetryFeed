//
//  APIService.swift
//  PersianPoetry
//
//  Created by Meghdad Abbaszadegan on 10/3/25.
//

import Foundation
import Combine

class APIService: ObservableObject {
    static let shared = APIService()
    private let baseURL = "https://api.ganjoor.net"
    
    private init() {}
    
    // MARK: - Fetch Random Poem
    func fetchRandomPoem() -> AnyPublisher<Poem, Error> {
        // For now, let's try to get a specific poem by ID (1) as a test
        guard let url = URL(string: "\(baseURL)/api/poems/1") else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("API Response: \(jsonString)")
                }
            })
            .decode(type: Poem.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Multiple Random Poems
    func fetchRandomPoems(count: Int = 10) -> AnyPublisher<[Poem], Error> {
        // For now, let's use sample data since the API might not be working
        let samplePoems = SampleDataService.shared.getSamplePoems()
        let shuffledPoems = Array(samplePoems.shuffled().prefix(count))
        
        return Just(shuffledPoems)
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Search Poems
    func searchPoems(keyword: String) -> AnyPublisher<[Poem], Error> {
        guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/poems/search?keyword=\(encodedKeyword)") else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PoemsResponse.self, decoder: JSONDecoder())
            .map(\.poems)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Poem by ID
    func fetchPoem(id: Int) -> AnyPublisher<Poem, Error> {
        guard let url = URL(string: "\(baseURL)/poems/\(id)") else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Poem.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - API Errors
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode data"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
