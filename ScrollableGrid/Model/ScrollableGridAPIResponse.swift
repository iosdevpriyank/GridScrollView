//
//  ScrollableGridAPIResponse.swift
//  ScrollableGrid
//
//  Created by Priyank Gandhi on 09/05/24.
//

import Foundation

typealias ScrollableGrid = [ScrollableGridAPIResponse]

// MARK: - ScrollableGridElement
struct ScrollableGridAPIResponse: Codable {
    let id, title, language: String
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt, publishedBy: String
    let backupDetails: BackupDetails?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.language = try container.decode(String.self, forKey: .language)
        self.thumbnail = try container.decode(Thumbnail.self, forKey: .thumbnail)
        self.mediaType = try container.decode(Int.self, forKey: .mediaType)
        self.coverageURL = try container.decode(String.self, forKey: .coverageURL)
        self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
        self.publishedBy = try container.decode(String.self, forKey: .publishedBy)
        self.backupDetails = try container.decodeIfPresent(BackupDetails.self, forKey: .backupDetails)
    }
}

// MARK: - BackupDetails
struct BackupDetails: Codable {
    let pdfLink: String
    let screenshotURL: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pdfLink = try container.decode(String.self, forKey: .pdfLink)
        self.screenshotURL = try container.decode(String.self, forKey: .screenshotURL)
    }
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let id: String
    let version: Int
    let domain: String
    let basePath, key: String
    let qualities: [Int]
    let aspectRatio: Double
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.version = try container.decode(Int.self, forKey: .version)
        self.domain = try container.decode(String.self, forKey: .domain)
        self.basePath = try container.decode(String.self, forKey: .basePath)
        self.key = try container.decode(String.self, forKey: .key)
        self.qualities = try container.decode([Int].self, forKey: .qualities)
        self.aspectRatio = try container.decode(Double.self, forKey: .aspectRatio)
    }
}


