//
//  Asset.swift
//  MoneyTracer
//
//  Created by 陈冠韬 on 2025/4/1.
//

import Foundation

struct Asset: Identifiable, Codable {
    var id: UUID
    var name: String
    var purchaseDate: Date
    var purchasePrice: Double
}

class AssetStore: ObservableObject {
    @Published var assets: [Asset] = []
    init() {
        loadAssets()
    }
    
    private func loadAssets() {
        if let data = UserDefaults.standard.data(forKey: "savedAssets"),
           let decodedAssets = try? JSONDecoder().decode([Asset].self, from: data) {
            assets = decodedAssets
        }
    }
    
    private func saveAssets() {
        if let encodedData = try? JSONEncoder().encode(assets) {
            UserDefaults.standard.set(encodedData, forKey: "savedAssets")
        }
    }
    
    
    func addAsset(_ asset: Asset) {
        assets.append(asset)
    }
        
    func deleteAsset(withId id: UUID) {
        assets.removeAll { $0.id == id }
    }
    
    func updateAsset(_ updatedAsset: Asset) {
        if let index = assets.firstIndex(where: { $0.id == updatedAsset.id }) {
            assets[index] = updatedAsset
        }
    }
}
