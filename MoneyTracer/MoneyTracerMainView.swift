//
//  ContentView.swift
//  MoneyTracer
//
//  Created by 陈冠韬 on 2025/4/1.
//

import SwiftUI

struct MoneyTracerMainView: View {
    var body: some View {
        
        TabView {
            ShowAssetView()
                .tabItem {Label("Assets", systemImage: "dollarsign.circle.fill")}
            OperateAssetView(isEdit: false)
                .tabItem {Label("Add", systemImage: "plus.circle.fill")}
        }
    }
}

#Preview {
    MoneyTracerMainView()
        .environmentObject(AssetStore())
}
