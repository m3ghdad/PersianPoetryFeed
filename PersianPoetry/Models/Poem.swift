//
//  Poem.swift
//  PersianPoetry
//
//  Created by Meghdad Abbaszadegan on 10/3/25.
//

import Foundation

struct Poem: Codable, Identifiable {
    let id: Int
    let title: String
    let urlSlug: String
    let plainText: String
    let htmlText: String
    let poet: Poet
    let category: Category
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case urlSlug
        case plainText
        case htmlText
        case poet
        case category
    }
}

struct Poet: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let birthYear: Int?
    let deathYear: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case birthYear
        case deathYear
    }
}

struct Category: Codable, Identifiable {
    let id: Int
    let title: String
    let urlSlug: String
    let parentId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case urlSlug
        case parentId
    }
}

// MARK: - API Response Models
struct PoemsResponse: Codable {
    let poems: [Poem]
}

struct RandomPoemResponse: Codable {
    let poem: Poem
}
