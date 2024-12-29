//
//  RecentTranscationsView.swift
//  Payment
//
//  Created by 최서희 on 12/27/24.
//

import SwiftUI

struct RecentTranscationsView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Recent Transactions")
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
            
            HStack(spacing: 20) {
                Button {
                    viewModel.selectedFilter = .all
                } label: {
                    Text("All")
                        .font(.headline)
                        .foregroundStyle(viewModel.selectedFilter == .all ? .accent : .secondary)
                }
                
                Button {
                    viewModel.selectedFilter = .expense
                } label: {
                    Text("Expense")
                        .font(.headline)
                        .foregroundStyle(viewModel.selectedFilter == .expense ? .accent : .secondary)
                }
                
                Button {
                    viewModel.selectedFilter = .income
                } label: {
                    Text("Income")
                        .font(.headline)
                        .foregroundStyle(viewModel.selectedFilter == .income ? .accent : .secondary)
                }
                
                Spacer()
            }
            .padding(.vertical)
            
            ForEach(viewModel.filterByType() , id: \.self) { transaction in
                RecentTransactionsRowView(amount: transaction.amount, name: transaction.name, timestamp: viewModel.formattedTimestamp(timestamp: transaction.timestamp), type: transaction.type)
            }
            .padding(.vertical, 8)
        } //:VSTACK
        
    }
}

#Preview {
    RecentTranscationsView()
}
