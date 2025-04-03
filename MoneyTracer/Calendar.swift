//
//  Calendar.swift
//  MoneyTracer
//
//  Created by 陈冠韬 on 2025/4/3.
//

import Foundation

extension Calendar {
    func numberOfDaysBetween(asset: Asset) -> Int {
        let today = Date()
        let components = self.dateComponents([.day], from: asset.purchaseDate, to: today)
        return max(1, components.day ?? 1)
    }
}
