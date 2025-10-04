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
    
    // MARK: - Fetch Random Poems (Real API)
    func fetchRandomPoems(count: Int = 1000) -> AnyPublisher<[Poem], Error> {
        print("Fetching \(count) poems from Ganjoor API...")
        
        // Since the API is not working reliably, we'll use a hybrid approach:
        // 1. Try to get a few poems from API (if any work)
        // 2. Generate the rest from sample data to ensure we always have content
        
        return Publishers.MergeMany([
            fetchPoemsByRandomIDs(count: min(count / 4, 50)), // Try to get 25% from API
            fetchPoemsByDirectSearch(count: min(count / 4, 50)),
            fetchPoemsByFamousPoets(count: min(count / 4, 50))
        ])
        .collect()
        .map { results in
            // Flatten and shuffle all results
            let allPoems = results.flatMap { $0 }
            let uniquePoems = Array(Set(allPoems.map { $0.id })).compactMap { id in
                allPoems.first { $0.id == id }
            }
            print("Fetched \(uniquePoems.count) unique poems from API")
            
            // If we got some poems from API, use them and fill the rest with sample data
            if !uniquePoems.isEmpty {
                let remainingCount = max(0, count - uniquePoems.count)
                let samplePoems = SampleDataService.shared.getSamplePoems()
                let additionalPoems = Array(samplePoems.shuffled().prefix(remainingCount))
                let combinedPoems = uniquePoems + additionalPoems
                return Array(combinedPoems.shuffled().prefix(count))
            } else {
                // If no API poems, use all sample data
                let samplePoems = SampleDataService.shared.getSamplePoems()
                return Array(samplePoems.shuffled().prefix(count))
            }
        }
        .catch { error in
            print("API Error: \(error), falling back to sample data")
            // Fallback to sample data if API fails
            let samplePoems = SampleDataService.shared.getSamplePoems()
            let shuffledPoems = Array(samplePoems.shuffled().prefix(count))
            return Just(shuffledPoems)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch All Poets
    private func fetchAllPoets() -> AnyPublisher<[Poet], Error> {
        guard let url = URL(string: "\(baseURL)/api/ganjoor/poets") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 10.0
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                print("Poets API Response bytes: \(data.count)")
            })
            .tryMap { data -> [Poet] in
                guard let jsonString = String(data: data, encoding: .utf8),
                      let jsonData = jsonString.data(using: .utf8) else {
                    throw APIError.decodingError
                }
                
                let poets = try JSONDecoder().decode([Poet].self, from: jsonData)
                print("Fetched \(poets.count) poets from API")
                return poets
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Poems from Random Poets
    private func fetchPoemsFromRandomPoets(poets: [Poet], count: Int) -> AnyPublisher<[Poem], Error> {
        // Select random poets (limit to avoid too many API calls)
        let selectedPoets = Array(poets.shuffled().prefix(min(50, poets.count)))
        let poemsPerPoet = max(1, count / selectedPoets.count)
        
        print("Fetching poems from \(selectedPoets.count) random poets...")
        
        let publishers = selectedPoets.map { poet in
            fetchPoemsByPoetID(poet.id, count: poemsPerPoet)
                .catch { error in
                    print("Error fetching poems for poet \(poet.name): \(error)")
                    return Just([Poem]()).setFailureType(to: Error.self)
                }
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .map { results in
                let allPoems = results.flatMap { $0 }
                let uniquePoems = Array(Set(allPoems.map { $0.id })).compactMap { id in
                    allPoems.first { $0.id == id }
                }
                print("Fetched \(uniquePoems.count) unique poems from API")
                return Array(uniquePoems.shuffled().prefix(count))
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Poems by Poet ID
    private func fetchPoemsByPoetID(_ poetID: Int, count: Int) -> AnyPublisher<[Poem], Error> {
        guard let url = URL(string: "\(baseURL)/api/ganjoor/poets/\(poetID)/poems") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 5.0
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                print("Poems for poet \(poetID) API Response bytes: \(data.count)")
            })
            .tryMap { data -> [Poem] in
                guard let jsonString = String(data: data, encoding: .utf8),
                      let jsonData = jsonString.data(using: .utf8) else {
                    throw APIError.decodingError
                }
                
                let poems = try JSONDecoder().decode([Poem].self, from: jsonData)
                return Array(poems.shuffled().prefix(count))
            }
            .catch { error in
                print("Error fetching poems for poet \(poetID): \(error)")
                return Just([Poem]()).setFailureType(to: Error.self)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Random Poem (Single)
    func fetchRandomPoem() -> AnyPublisher<Poem, Error> {
        guard let url = URL(string: "\(baseURL)/api/ganjoor/poems/random") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 15

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                print("Random poem payload bytes: \(data.count)")
            })
            .tryMap { data -> Poem in
                let decoder = JSONDecoder()
                if let poem = try? decoder.decode(Poem.self, from: data) {
                    return poem
                }
                if let wrapper = try? decoder.decode(RandomPoemResponse.self, from: data) {
                    return wrapper.poem
                }
                if let fallback = self.parsePoemFallback(from: data) {
                    return fallback
                }
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Random poem decode failed. Payload: \(jsonString)")
                }
                throw APIError.decodingError
            }
            .retry(2)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Poems by Random IDs
    private func fetchPoemsByRandomIDs(count: Int) -> AnyPublisher<[Poem], Error> {
        // Use a wider range of IDs to get poems from different poets
        let randomIDs = (1...10000).shuffled().prefix(min(count * 3, 100)) // Limit to avoid too many requests
        let publishers = randomIDs.map { id in
            fetchPoem(id: id)
                .map { [$0] }
                .catch { _ in Just([Poem]()).setFailureType(to: Error.self) }
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .map { results in
                let poems = results.flatMap { $0 }
                print("Random IDs strategy fetched \(poems.count) poems")
                return poems
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Poems by Direct Search
    private func fetchPoemsByDirectSearch(count: Int) -> AnyPublisher<[Poem], Error> {
        // Try searching for famous poets
        let searchTerms = ["حافظ", "سعدی", "فردوسی", "مولانا", "عمر خیام"]
        let publishers = searchTerms.map { term in
            searchPoems(keyword: term)
                .map { poems in Array(poems.prefix(count / searchTerms.count + 1)) }
                .catch { _ in Just([Poem]()).setFailureType(to: Error.self) }
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .map { results in
                let poems = results.flatMap { $0 }
                print("Direct search strategy fetched \(poems.count) poems")
                return poems
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Poems by Famous Poets
    private func fetchPoemsByFamousPoets(count: Int) -> AnyPublisher<[Poem], Error> {
        // Try to get poems from famous poets using their known IDs
        let famousPoetIDs = [2, 5, 6, 7, 8] // حافظ, مولانا, نظامی, سعدی, فردوسی
        let publishers = famousPoetIDs.map { poetID in
            fetchPoemsByPoetID(poetID, count: count / famousPoetIDs.count + 1)
                .catch { _ in Just([Poem]()).setFailureType(to: Error.self) }
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .map { results in
                let poems = results.flatMap { $0 }
                print("Famous poets strategy fetched \(poems.count) poems")
                return poems
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Search Poems (Real API)
    func searchPoems(keyword: String) -> AnyPublisher<[Poem], Error> {
        guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/api/ganjoor/poems/search?keyword=\(encodedKeyword)") else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 3.0
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                print("Search API Response bytes: \(data.count)")
            })
            .tryMap { data -> [Poem] in
                guard let jsonString = String(data: data, encoding: .utf8),
                      let jsonData = jsonString.data(using: .utf8) else {
                    throw APIError.decodingError
                }
                
                // Try to decode as PoemsResponse first, then as array
                if let response = try? JSONDecoder().decode(PoemsResponse.self, from: jsonData) {
                    return response.poems
                } else if let poems = try? JSONDecoder().decode([Poem].self, from: jsonData) {
                    return poems
                } else {
                    throw APIError.decodingError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Poem by ID
    func fetchPoem(id: Int) -> AnyPublisher<Poem, Error> {
        guard let url = URL(string: "\(baseURL)/api/ganjoor/poems/\(id)") else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 3.0
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Poem.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Flexible Fallback Parser
    private func parsePoemFallback(from data: Data) -> Poem? {
        guard let obj = try? JSONSerialization.jsonObject(with: data) else { return nil }

        func int(from any: Any?) -> Int? {
            if let i = any as? Int { return i }
            if let s = any as? String, let i = Int(s) { return i }
            return nil
        }
        func str(from any: Any?) -> String? {
            return any as? String
        }
        func dict(_ any: Any?) -> [String: Any]? { any as? [String: Any] }

        let root = dict(obj)

        // Support wrapper { "poem": { ... } }
        let poemDict = dict(root?["poem"]) ?? root
        guard let poem = poemDict else { return nil }

        let id = int(from: poem["id"]) ?? int(from: poem["poemId"]) ?? Int.random(in: 1_000_000...2_000_000)
        let title = str(from: poem["title"]) ?? str(from: poem["fullTitle"]) ?? str(from: poem["ganjoorTitle"]) ?? "Untitled"
        let urlSlug = str(from: poem["urlSlug"]) ?? str(from: poem["slug"]) ?? "poem-\(id)"

        // Try plain text, else build from verses array if present
        var plainText = str(from: poem["plainText"]) ?? ""
        if plainText.isEmpty, let verses = poem["verses"] as? [[String: Any]] {
            let lines = verses.compactMap { $0["text"] as? String }
            if !lines.isEmpty { plainText = lines.joined(separator: "\n") }
        }
        if plainText.isEmpty, let body = str(from: poem["body"]) { plainText = body }

        // HTML text fallback
        let htmlText = str(from: poem["htmlText"]) ?? "<p>\(plainText)</p>"

        // Poet
        var poetId = 0
        var poetName = "Unknown"
        if let poetObj = dict(poem["poet"]) {
            poetId = int(from: poetObj["id"]) ?? 0
            poetName = str(from: poetObj["name"]) ?? poetName
        } else if let pName = str(from: poem["poetName"]) {
            poetName = pName
        }

        let poet = Poet(id: poetId, name: poetName, description: nil, birthYear: nil, deathYear: nil)
        let category = Category(id: 0, title: str(from: poem["category"]) ?? "", urlSlug: str(from: poem["categorySlug"]) ?? "", parentId: nil)

        return Poem(id: id, title: title, urlSlug: urlSlug, plainText: plainText, htmlText: htmlText, poet: poet, category: category)
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