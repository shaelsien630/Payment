//
//  Model.swift
//  Payment
//
//  Created by 최서희 on 12/27/24.
//

import Foundation

enum FilterType {
    case all
    case income
    case expense
}

struct Transaction: Codable, Hashable {
    let amount: String
    let name: String
    let timestamp: String
    let type: String
}

struct ChartEntry {
    let amount: Double
    let timestamp: String
}
