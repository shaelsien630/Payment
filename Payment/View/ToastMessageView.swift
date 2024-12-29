//
//  ToastMessageView.swift
//  Payment
//
//  Created by 최서희 on 12/27/24.
//

import SwiftUI

struct ToastMessageView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            if let lastTransaction = viewModel.transactions.last {
                VStack(alignment: .leading, spacing: 8) {
                    Text(lastTransaction.name)
                        .font(.headline)
                    Text(lastTransaction.type)
                        .font(.callout)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text(lastTransaction.amount.first == "-" ? "-$" + lastTransaction.amount.dropFirst() : "$" + lastTransaction.amount)
                        .font(.headline)
                    Text(viewModel.formattedTimestamp(timestamp: lastTransaction.timestamp))
                        .font(.callout)
                }
            }
        }
        .frame(width: 300, height: 56)
        .padding()
        .foregroundStyle(.white)
        .background(.accent)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
    }
}

#Preview {
    ToastMessageView()
}
