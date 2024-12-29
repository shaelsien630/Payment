//
//  RecentTransactionsRowView.swift
//  Payment
//
//  Created by 최서희 on 12/27/24.
//

import SwiftUI

struct RecentTransactionsRowView: View {
    let amount: String
    let name: String
    let timestamp: String
    let type: String
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 50, height: 50)
                .foregroundStyle(.lightGray)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.primary)
                Text(type)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
            } //:VSTACK
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text(amount.first == "-" ? "-$" + amount.dropFirst() : "$" + amount)
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.accent)
                Text(timestamp)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(width: 110)
                
            } //:VSTACK
        } //:HSTACK
    }
}

#Preview {
    RecentTransactionsRowView(amount: "3304.49", name: "Julie Sandoval", timestamp: "2024-10-01T15:18:38.158418Z", type: "transfer")
}
