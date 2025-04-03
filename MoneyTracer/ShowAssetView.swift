import SwiftUI

struct ShowAssetView: View {
    @EnvironmentObject var assetStore: AssetStore
    @State private var searchText = ""
    @State private var showingAddAsset = false
    @State private var isEditing = false
    @State private var selectedAssets = Set<UUID>()
    @State private var sortOption = SortOption.name
    @State private var sortOrder = SortOrder.ascending
    
    enum SortOption: String, CaseIterable, Identifiable {
        case name = "Name"
        case price = "Price"
        case averageDailyPrice = "Average Daily Price"
        
        var id: String { self.rawValue }
    }
    
    enum SortOrder: String, CaseIterable, Identifiable {
        case ascending = "Ascending"
        case descending = "Descending"
        
        var id: String { self.rawValue }
    }
    
    var filteredAndSortedAssets: [Asset] {
            let filteredAssets = assetStore.assets.filter { asset in
                searchText.isEmpty ||
                asset.name.localizedCaseInsensitiveContains(searchText) ||
                String(format: "%.2f", asset.purchasePrice).contains(searchText)
            }
            
            switch (sortOption, sortOrder) {
            case (.name, .ascending):
                return filteredAssets.sorted { $0.name < $1.name }
            case (.name, .descending):
                return filteredAssets.sorted { $0.name > $1.name }
            case (.price, .ascending):
                return filteredAssets.sorted { $0.purchasePrice < $1.purchasePrice }
            case (.price, .descending):
                return filteredAssets.sorted { $0.purchasePrice > $1.purchasePrice }
            case (.averageDailyPrice, .ascending):
                return filteredAssets.sorted {
                    let days1 = Calendar.current.numberOfDaysBetween(asset: $0)
                    let days2 = Calendar.current.numberOfDaysBetween(asset: $1)
                    return ($0.purchasePrice / Double(max(1, days1))) < ($1.purchasePrice / Double(max(1, days2)))
                }
            case (.averageDailyPrice, .descending):
                return filteredAssets.sorted {
                    let days1 = Calendar.current.numberOfDaysBetween(asset: $0)
                    let days2 = Calendar.current.numberOfDaysBetween(asset: $1)
                    return ($0.purchasePrice / Double(max(1, days1))) > ($1.purchasePrice / Double(max(1, days2)))
                }
            }
        }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding()
                
                let totalAssetValue = filteredAndSortedAssets.reduce(0) { $0 + $1.purchasePrice }
                let totalAverageDailyPrice = filteredAndSortedAssets.reduce(0.0) { total, asset in
                    let days = Calendar.current.numberOfDaysBetween(asset: asset)
                    return total + (asset.purchasePrice / Double(max(1, days)))
                }
                VStack {
                        Text("Total Asset Value: ¥\(totalAssetValue,specifier: "%.2f")")
                            .font(.headline)
                        Text("Total Average Daily Price: ¥\(totalAverageDailyPrice,specifier: "%.2f")")
                            .font(.headline)
                    }
                .padding()
                .background(Color(.blue))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .foregroundStyle(Color(.white))
                
                List {
                    ForEach(filteredAndSortedAssets) { asset in
                        if isEditing {
                            AssetRow(asset: asset)
                                .listRowBackground(selectedAssets.contains(asset.id) ? Color.blue.opacity(0.2) : nil)
                                .onTapGesture {
                                    if selectedAssets.contains(asset.id) {
                                        selectedAssets.remove(asset.id)
                                    } else {
                                        selectedAssets.insert(asset.id)
                                    }
                                }
                        } else {
                            NavigationLink(destination: OperateAssetView(isEdit: true, asset: asset)) {
                                AssetRow(asset: asset)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Assets")
            .navigationBarItems(
                leading: Menu {
                    Picker("Sort By", selection: $sortOption) {
                        ForEach(SortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    Picker("Sort Order", selection: $sortOrder) {
                        ForEach(SortOrder.allCases) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                },
                trailing: HStack {
                    if isEditing {
                        Button(action: deleteSelectedAssets) {
                            Text("Delete")
                                .foregroundColor(.red)
                        }
                    }
                    Button(action: {
                        if isEditing {
                            selectedAssets.removeAll()
                        }
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
            )
            .sheet(isPresented: $showingAddAsset) {
                OperateAssetView(isEdit: false)
            }
        }
    }
    
    private func deleteSelectedAssets() {
        for id in selectedAssets {
            assetStore.deleteAsset(withId: id)
        }
        selectedAssets.removeAll()
        isEditing = false
    }
}

#Preview {
    ShowAssetView()
        .environmentObject(AssetStore())
}
