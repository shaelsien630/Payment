//
//  ViewModel.swift
//  Payment
//
//  Created by 최서희 on 12/27/24.
//

import Foundation
import Combine

final class ViewModel: ObservableObject {
    @Published var transactions: [Transaction] = [] {
        didSet {
            toastMessageFlag = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.toastMessageFlag = false
            }
        }
    }
    @Published var selectedSegment: String = "Week"
    @Published var selectedFilter: FilterType = .all
    @Published var toastMessageFlag = false
    
    @Published var incomeData: [ChartEntry] = []
    @Published var expenseData: [ChartEntry] = []
    
    @Published var isLoading: Bool = false
    
    init() {
        loadMockData()
        filterByDateRange()
    }
    
    // MARK: - Load Mock Data
    func loadMockData() {
        guard let path = Bundle.main.path(forResource: "Transactions", ofType: "json") else {
            print("파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodeTransactions = try decoder.decode([Transaction].self, from: data)
            transactions = decodeTransactions
            isLoading = true
        } catch {
            print("JSON 로드 실패: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Timestamp Date 변환
    func formatDate(_ timestamp: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: timestamp) ?? Date()
    }
    
    // MARK: - 날짜 포맷 변환
    func formattedTimestamp(timestamp: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: formatDate(timestamp))
    }
    
    // MARK: - Filter for Week and Month
    func filterByDateRange() {
        let sortedTransactions = transactions.sorted {
            $0.timestamp < $1.timestamp
        }
        let calendar = Calendar.current
        let today = Date()
        
        let filteredTransactions = sortedTransactions.filter { transaction in
            let date = formatDate(transaction.timestamp)
            if selectedSegment == "Week" {
                return calendar.dateComponents([.day], from: date, to: today).day! <= 7
            } else {
                return calendar.dateComponents([.day], from: date, to: today).day! <= 30
            }
        }
        
        DispatchQueue.main.async {
            self.incomeData = filteredTransactions
                .filter { Double($0.amount)! > 0 }
                .map { ChartEntry(amount: Double($0.amount)!, timestamp: $0.timestamp) }
            
            self.expenseData = filteredTransactions
                .filter { Double($0.amount)! < 0 }
                .map { ChartEntry(amount: abs(Double($0.amount)!), timestamp: $0.timestamp) }
        }
    }
    
    // MARK: - Filter Transactions
    func filterByType() -> [Transaction] {
        let sortedTransactions = transactions.sorted {
            $0.timestamp > $1.timestamp
        }
        
        switch selectedFilter {
        case .all:
            return Array(sortedTransactions.prefix(20))
        case .income:
            return Array(
                sortedTransactions.filter { Double($0.amount) ?? 0 > 0 }
                    .prefix(10)
            )
        case .expense:
            return Array(
                sortedTransactions.filter { Double($0.amount) ?? 0 < 0 }
                    .prefix(10)
            )
        }
    }
}
