import SwiftUI

// MARK: - Food Detail & Recipe Screen

public struct FoodDetailView: View {
    public let recipe: FoodRecipe
    @Environment(\.dismiss) private var dismiss
    
    public init(recipe: FoodRecipe) {
        self.recipe = recipe
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // AI Generated Food Image
                ZStack(alignment: .topTrailing) {
                    if let imageURL = recipe.imageURL {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                ZStack {
                                    Color.gray.opacity(0.1)
                                    ProgressView("Görsel Yükleniyor...")
                                }
                                .frame(height: 340)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 340)
                                    .clipped()
                            case .failure:
                                ZStack {
                                    Color.gray.opacity(0.2)
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(height: 340)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Rectangle()
                            .fill(Color.orange.opacity(0.15))
                            .frame(height: 340)
                            .overlay(
                                Image(systemName: "fork.knife.circle.fill")
                                    .font(.system(size: 64))
                                    .foregroundStyle(.orange)
                            )
                    }
                    
                    // Style tag overlay
                    Text("AI FLUX 8K")
                        .font(.caption2.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(16)
                }
                
                // Detailed Content Card
                VStack(spacing: 20) {
                    RecipeCardView(recipe: recipe)
                    
                    // Prompt info box
                    DisclosureGroup("🔍 Kullanılan AI Promptu") {
                        Text(recipe.promptUsed)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 6)
                    }
                    .font(.subheadline.bold())
                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding()
                .offset(y: -20)
            }
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: "\(recipe.title) Tarifi ve Görseli: \(recipe.imageURL?.absoluteString ?? "")") {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}
