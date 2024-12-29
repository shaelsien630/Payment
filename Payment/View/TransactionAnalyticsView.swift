//
//  TransactionAnalyticsView.swift
//  Payment
//
//  Created by 최서희 on 12/27/24.
//

import SwiftUI
import Charts

struct TransactionAnalyticsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var animateProgress: CGFloat = 0.0
    let segments = ["Week", "Month"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.accent)
                        .frame(width: 88, height: 40)
                        .padding(2)
                        .offset(x: viewModel.selectedSegment == "Week" ? 0 : 88)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.selectedSegment)
                    
                    HStack(spacing: 0) {
                        ForEach(segments, id: \.self) { segment in
                            Text(segment)
                                .fontWeight(.bold)
                                .foregroundColor(viewModel.selectedSegment == segment ? .white : .gray)
                                .frame(width: 90, height: 40)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.selectedSegment = segment
                                        viewModel.filterByDateRange()
                                    }
                                }
                        }
                    }
                }
                .background(.lightGray)
                .clipShape(Capsule())
                
                Spacer()
            }
            
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 30, height: 5)
                    .foregroundStyle(.accent)
                
                Text("Income")
                    .font(.caption)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 30, height: 5)
                    .foregroundStyle(.lightMint)
                    .padding(.leading, 20)
                
                Text("Expense")
                    .font(.caption)
                
                Spacer()
            }
            .padding(.vertical)
            
            // 차트
            if viewModel.isLoading {
                ZStack {
                    chartPath(data: viewModel.expenseData, color: .lightMint)
                    chartPath(data: viewModel.incomeData, color: .accent)
                }
                .frame(height: 200)
                .padding(.vertical, 20)
                .onAppear { animateChart() }
                .onChange(of: viewModel.selectedSegment) { _ in animateChart() }
                .frame(height: 200)
                .padding(.vertical, 20)
            } else {
                ProgressView()
                    .foregroundColor(.gray)
                    .frame(height: 200)
                    .padding(.vertical, 20)
            }
            
            // 날짜
            HStack {
                Text(viewModel.selectedSegment == "Week" ? "7일 전" : "30일 전")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text("오늘")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func chartPath(data: [ChartEntry], color: Color) -> some View {
        GeometryReader { geometry in
            ZStack {
                // 그라데이션 영역
                makePath(data: data, geometry: geometry, isGradient: true)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color.opacity(0.2), color.opacity(0.01)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(animateProgress == 1.0 ? 1.0 : 0.0)
                
                // 선 경로
                makePath(data: data, geometry: geometry, isGradient: false)
                    .trim(from: 0, to: animateProgress)
                    .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            }
        }
    }
    
    private func makePath(data: [ChartEntry], geometry: GeometryProxy, isGradient: Bool) -> Path {
        var path = Path()
        guard data.count > 1 else { return path }
        
        let maxValue = data.map { $0.amount }.max() ?? 0.0 > 0 ? data.map { $0.amount }.max() ?? 0.0 : 1.0
        let points = data.enumerated().map { index, entry in
            CGPoint(
                x: geometry.size.width * CGFloat(index) / CGFloat(data.count - 1),
                y: geometry.size.height * (1 - CGFloat(entry.amount) / CGFloat(maxValue))
            )
        }
        
        path.move(to: points.first!)
        for i in 1..<points.count {
            let current = points[i]
            let previous = points[i - 1]
            let midPoint = CGPoint(
                x: (current.x + previous.x) / 2,
                y: (current.y + previous.y) / 2
            )
            path.addQuadCurve(to: midPoint, control: previous)
        }
        
        if let last = points.last { path.addLine(to: last) }
        
        if isGradient {
            path.addLine(to: CGPoint(x: points.last!.x, y: geometry.size.height))
            path.addLine(to: CGPoint(x: points.first!.x, y: geometry.size.height))
            path.closeSubpath()
        }
        
        return path
    }
    
    private func animateChart() {
        animateProgress = 0.0
        withAnimation(.linear(duration: 2.0)) {
            animateProgress = 1.0
        }
    }
}

#Preview {
    TransactionAnalyticsView()
}
