import Foundation
import SwiftUI
import Combine

// MARK: - Food Generator ViewModel

@MainActor
public final class FoodGeneratorViewModel: ObservableObject {
    // Inputs
    @Published public var dishName: String = ""
    @Published public var selectedCuisine: Cuisine = .international
    @Published public var selectedStyle: PresentationStyle = .michelin
    @Published public var selectedLighting: LightingStyle = .softStudio
    @Published public var extraDetails: String = ""
    
    // Outputs & State
    @Published public var isGenerating: Bool = false
    @Published public var currentRecipe: FoodRecipe?
    @Published public var recentRecipes: [FoodRecipe] = []
    @Published public var errorMessage: String?
    
    private let service = AIImageService.shared
    
    public init() {
        // Load initial recipe for instant preview
        let initial = service.createRecipe(for: "Trüflü El Yapımı Fettuccine", cuisine: .italian)
        var updated = initial
        let prompt = service.craftFoodPrompt(dishName: initial.title, style: .michelin, lighting: .softStudio)
        updated.imageURL = service.generateImageURL(prompt: prompt)
        self.currentRecipe = updated
        self.recentRecipes = [updated]
    }
    
    /// Trigger AI Generation for Food Visual and Recipe
    public func generate() async {
        let trimmedName = dishName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            errorMessage = "Lütfen bir yemek adı girin."
            return
        }
        
        isGenerating = true
        errorMessage = nil
        
        // 1. Build prompt
        let prompt = service.craftFoodPrompt(
            dishName: trimmedName,
            style: selectedStyle,
            lighting: selectedLighting,
            extraDetails: extraDetails
        )
        
        // 2. Generate Recipe Model
        var recipe = service.createRecipe(for: trimmedName, cuisine: selectedCuisine)
        
        // 3. Obtain AI Image URL
        if let imageURL = service.generateImageURL(prompt: prompt) {
            recipe.imageURL = imageURL
        }
        
        // Brief animation delay for pleasant UX
        try? await Task.sleep(nanoseconds: 1_200_000_000)
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            self.currentRecipe = recipe
            self.recentRecipes.insert(recipe, at: 0)
            self.isGenerating = false
        }
    }
    
    public func selectPreset(name: String, cuisine: Cuisine) {
        self.dishName = name
        self.selectedCuisine = cuisine
    }
}
