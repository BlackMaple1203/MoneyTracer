//
//  AddAssetView.swift
//  MoneyTracer
//
//  Created by 陈冠韬 on 2025/4/1.
//

import SwiftUI

struct OperateAssetView: View {
    let isEdit: Bool
    let asset: Asset?
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var assetStore: AssetStore
    
    @State private var name: String
    @State private var purchaseDate: Date
    @State private var purchasePrice: String
    @State private var showInvalidPriceAlert = false
    @State private var showSuccessAlert = false
    
    init(isEdit: Bool, asset: Asset? = nil) {
        self.isEdit = isEdit
        self.asset = asset
        
        _name = State(initialValue: asset?.name ?? "")
        _purchaseDate = State(initialValue: asset?.purchaseDate ?? Date())
        _purchasePrice = State(initialValue: asset.map { String(format: "%.2f", $0.purchasePrice) } ?? "")
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && Double(purchasePrice) != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                DatePicker("Purchase Date", selection: $purchaseDate,
                           displayedComponents: .date)
                TextField("Purchase Price", text: $purchasePrice)
                    .keyboardType(.decimalPad)
            }
            .navigationBarTitle(isEdit ? "Edit Asset" : "Add Asset", displayMode: .inline)
            .navigationBarItems(
                leading: isEdit ? nil : Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    saveAsset()
                }
                .disabled(!isFormValid)
            )
            .alert("Invalid Price", isPresented: $showInvalidPriceAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid price")
            }
            .alert(isEdit ? "Asset Updated" : "Asset Added", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text(isEdit ? "Successfully updated the asset" : "Successfully added a new asset")
            }
        }
    }
    
    private func saveAsset() {
        guard let price = Double(purchasePrice) else {
            showInvalidPriceAlert = true
            return
        }
        
        if isEdit, let editingAsset = asset {
            let updatedAsset = Asset(
                id: editingAsset.id,
                name: name,
                purchaseDate: purchaseDate,
                purchasePrice: price
            )
            assetStore.updateAsset(updatedAsset)
        } else {
            let newAsset = Asset(
                id: UUID(),
                name: name,
                purchaseDate: purchaseDate,
                purchasePrice: price
            )
            assetStore.addAsset(newAsset)
        }
        showSuccessAlert = true
    }
}

#Preview {
    OperateAssetView(isEdit: false)
        .environmentObject(AssetStore())
}
