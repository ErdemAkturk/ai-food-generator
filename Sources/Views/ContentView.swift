import SwiftUI

// MARK: - Main Application Root Screen

public struct ContentView: View {
    @StateObject private var viewModel = FoodGeneratorViewModel()
    @State private var selectedRecipe: FoodRecipe?
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("🍳 GourmetAI")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.orange, .red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Spacer()
                            
                            Label("FLUX 8K", systemImage: "sparkles")
                                .font(.caption2.bold())
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.15))
                                .foregroundStyle(.orange)
                                .clipShape(Capsule())
                        }
                        
                        Text("Yapay zeka ile gurme tabak görselleri ve enfes şef tarifleri oluşturun.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Input / Generator Form
                    FoodGeneratorView(viewModel: viewModel)
                    
                    // Current Active Creation
                    if let current = viewModel.currentRecipe {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("✨ Son Oluşturulan Lezzet")
                                .font(.title3.bold())
                                .padding(.horizontal)
                            
                            NavigationLink(value: current) {
                                CurrentRecipeCard(recipe: current)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                    }
                    
                    // Recent Gallery Feed
                    if viewModel.recentRecipes.count > 1 {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("📚 Tarif Geçmişi")
                                .font(.title3.bold())
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 14) {
                                    ForEach(viewModel.recentRecipes.dropFirst()) { recipe in
                                        NavigationLink(value: recipe) {
                                            RecentRecipeThumbnail(recipe: recipe)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationDestination(for: FoodRecipe.self) { recipe in
                FoodDetailView(recipe: recipe)
            }
        }
    }
}

// Subview for Current Generated Dish Banner
private struct CurrentRecipeCard: View {
    let recipe: FoodRecipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                if let imageURL = recipe.imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.orange.opacity(0.1))
                                .overlay(ProgressView())
                        case .success(let img):
                            img.resizable()
                                .scaledToFill()
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .overlay(Image(systemName: "photo").font(.largeTitle))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 220)
                    .clipped()
                } else {
                    Rectangle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(height: 220)
                }
                
                // Gradient overlay
                LinearGradient(
                    colors: [.clear, .black.opacity(0.8)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 8) {
                        Text(recipe.cuisine.rawValue)
                        Text("•")
                        Text(recipe.prepTime)
                        Text("•")
                        Text(recipe.calories)
                    }
                    .font(.caption.bold())
                    .foregroundStyle(.white.opacity(0.85))
                }
                .padding(14)
            }
            
            HStack {
                Text("Tarifi & Malzemeleri İncele")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.orange)
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.orange)
            }
            .padding(14)
            .background(Color(.secondarySystemBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
    }
}

// Subview for history thumbnail
private struct RecentRecipeThumbnail: View {
    let recipe: FoodRecipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let url = recipe.imageURL {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.orange.opacity(0.15)
                    }
                } else {
                    Color.orange.opacity(0.15)
                }
            }
            .frame(width: 140, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(recipe.title)
                .font(.caption.bold())
                .lineLimit(2)
                .frame(width: 140, alignment: .leading)
            
            Text(recipe.cuisine.rawValue)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}
