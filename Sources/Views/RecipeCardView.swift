import SwiftUI

// MARK: - Recipe Card Component

public struct RecipeCardView: View {
    public let recipe: FoodRecipe
    @State private var checkedItems: Set<UUID> = []
    
    public init(recipe: FoodRecipe) {
        self.recipe = recipe
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // Header & Badges
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.title)
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                
                HStack(spacing: 8) {
                    Label(recipe.cuisine.rawValue, systemImage: recipe.cuisine.icon)
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.orange.opacity(0.15))
                        .foregroundStyle(.orange)
                        .clipShape(Capsule())
                    
                    Label(recipe.prepTime, systemImage: "clock")
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue.opacity(0.15))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                    
                    Label(recipe.calories, systemImage: "flame")
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.red.opacity(0.15))
                        .foregroundStyle(.red)
                        .clipShape(Capsule())
                }
            }
            
            Text(recipe.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(3)
            
            Divider()
            
            // Ingredients List
            VStack(alignment: .leading, spacing: 10) {
                Text("🛒 Malzemeler")
                    .font(.headline)
                
                ForEach(recipe.ingredients) { ingredient in
                    Button {
                        if checkedItems.contains(ingredient.id) {
                            checkedItems.remove(ingredient.id)
                        } else {
                            checkedItems.insert(ingredient.id)
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: checkedItems.contains(ingredient.id) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(checkedItems.contains(ingredient.id) ? .green : .secondary)
                                .font(.body)
                            
                            Text(ingredient.name)
                                .font(.subheadline)
                                .foregroundStyle(checkedItems.contains(ingredient.id) ? .secondary : .primary)
                                .strikethrough(checkedItems.contains(ingredient.id))
                            
                            Spacer()
                            
                            Text(ingredient.amount)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Divider()
            
            // Instructions
            VStack(alignment: .leading, spacing: 10) {
                Text("👨‍🍳 Hazırlanış Adımları")
                    .font(.headline)
                
                ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption.bold())
                            .frame(width: 24, height: 24)
                            .background(Color.orange.opacity(0.2))
                            .foregroundStyle(.orange)
                            .clipShape(Circle())
                        
                        Text(step)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .lineSpacing(2)
                    }
                }
            }
            
            // Chef Tip Box
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.yellow)
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Şefin İpucu")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    Text(recipe.chefTip)
                        .font(.caption)
                        .foregroundStyle(.primary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.yellow.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
