import SwiftUI

// MARK: - Food Generator Screen

public struct FoodGeneratorView: View {
    @ObservedObject public var viewModel: FoodGeneratorViewModel
    @FocusState private var isFieldFocused: Bool
    
    public init(viewModel: FoodGeneratorViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // Input Card
            VStack(alignment: .leading, spacing: 16) {
                Text("🍽️ Ne Pişirmek / Görmek İstiyorsunuz?")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "fork.knife")
                        .foregroundStyle(.orange)
                    
                    TextField("Örn: Trüflü Parmesanlı Fırın Somon", text: $viewModel.dishName)
                        .focused($isFieldFocused)
                        .textInputAutocapitalization(.words)
                    
                    if !viewModel.dishName.isEmpty {
                        Button {
                            viewModel.dishName = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(14)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                
                // Quick Preset Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        PresetPill(title: "Trüflü Makarna", cuisine: .italian, viewModel: viewModel)
                        PresetPill(title: "Adana Kebap", cuisine: .turkish, viewModel: viewModel)
                        PresetPill(title: "Somon Sashimi", cuisine: .japanese, viewModel: viewModel)
                        PresetPill(title: "Wagyu Burger", cuisine: .international, viewModel: viewModel)
                        PresetPill(title: "San Sebastian Cheesecake", cuisine: .french, viewModel: viewModel)
                    }
                }
            }
            .padding(18)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            // Customization Options
            VStack(alignment: .leading, spacing: 14) {
                Text("🎨 Sunum ve Atmosfer Tercihleri")
                    .font(.subheadline.bold())
                
                // Cuisine Picker
                Picker("Mutfak", selection: $viewModel.selectedCuisine) {
                    ForEach(Cuisine.allCases) { cuisine in
                        Text(cuisine.rawValue).tag(cuisine)
                    }
                }
                .pickerStyle(.segmented)
                
                // Style Picker
                Picker("Fotoğraf Tarzı", selection: $viewModel.selectedStyle) {
                    ForEach(PresentationStyle.allCases) { style in
                        Text(style.rawValue).tag(style)
                    }
                }
                .pickerStyle(.menu)
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // Lighting Picker
                Picker("Işıklandırma", selection: $viewModel.selectedLighting) {
                    ForEach(LightingStyle.allCases) { light in
                        Text(light.rawValue).tag(light)
                    }
                }
                .pickerStyle(.menu)
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            // Action Button
            Button {
                isFieldFocused = false
                Task {
                    await viewModel.generate()
                }
            } label: {
                HStack(spacing: 10) {
                    if viewModel.isGenerating {
                        ProgressView()
                            .tint(.white)
                        Text("Şef Hazırlıyor...")
                    } else {
                        Image(systemName: "wand.and.stars")
                        Text("AI Görsel ve Tarif Oluştur")
                    }
                }
                .font(.headline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color.orange, Color.red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.orange.opacity(0.3), radius: 10, y: 4)
            }
            .disabled(viewModel.isGenerating)
        }
        .padding(.horizontal)
    }
}

// Preset helper button
private struct PresetPill: View {
    let title: String
    let cuisine: Cuisine
    @ObservedObject var viewModel: FoodGeneratorViewModel
    
    var body: some View {
        Button {
            viewModel.selectPreset(name: title, cuisine: cuisine)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: cuisine.icon)
                    .font(.caption2)
                Text(title)
                    .font(.caption.weight(.medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Color(.systemBackground))
            .foregroundStyle(.primary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
