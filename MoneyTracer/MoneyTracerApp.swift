//
//  MoneyTracerApp.swift
//  MoneyTracer
//
//  Created by 陈冠韬 on 2025/4/1.
//

import SwiftUI

@main
struct MoneyTracerApp: App {
    @StateObject private var assetStore = AssetStore()
    
    var body: some Scene {
        WindowGroup {
            MoneyTracerMainView()
                .environmentObject(assetStore)
        }
    }
}
