//
//  AssetRowView.swift
//  MoneyTracer
//
//  Created by 陈冠韬 on 2025/4/3.
//

import Foundation
import SwiftUI

struct AssetRow: View {
    let asset: Asset
    
    private var daysSincePurchase: Int {
        Calendar.current.numberOfDaysBetween(asset: asset)
    }
    
    private var averageDailyPrice: Double {
        asset.purchasePrice / Double(max(1, daysSincePurchase))
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(asset.name)
                    .font(.headline)
                Text("Purchase: \(asset.purchaseDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(daysSincePurchase) days since purchase")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("¥\(asset.purchasePrice, specifier: "%.2f")")
                    .font(.system(.body, design: .monospaced))
                Text("¥\(averageDailyPrice, specifier: "%.2f")/day")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
            }
        }
        .padding()        
    }
}

#Preview {
    AssetRow(asset: Asset(id: UUID(), name: "Sample Asset", purchaseDate: Date(), purchasePrice: 1000.0))
}
