//
//  TransactionsView.swift
//  Payment
//
//  Created by 최서희 on 12/27/24.
//

import SwiftUI

struct TransactionsView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                Text("Transactions")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                ScrollView {
                    TransactionAnalyticsView()
                    RecentTranscationsView()
                }
                .padding(.horizontal, 14)
                .scrollIndicators(.hidden)
            }
            .padding()
            
            if viewModel.toastMessageFlag {
                ToastMessageView()
                    .offset(y: viewModel.toastMessageFlag ? 300 : UIScreen.main.bounds.height) // 아래로 이동 설정
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .opacity(viewModel.toastMessageFlag ? 1.0 : 0.0)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(response: 1.2, dampingFraction: 0.8, blendDuration: 0.8))
                    .zIndex(1)
            }
        }
        .environmentObject(viewModel)
        
    }
}

#Preview {
    TransactionsView()
}
