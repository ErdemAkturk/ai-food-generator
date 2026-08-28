import Foundation
import UIKit

// MARK: - AI Image & Recipe Generation Service

public final class AIImageService {
    public static let shared = AIImageService()
    
    private init() {}
    
    /// Crafts an enriched photographic prompt for FLUX and DALL-E models
    public func craftFoodPrompt(
        dishName: String,
        style: PresentationStyle = .michelin,
        lighting: LightingStyle = .softStudio,
        extraDetails: String = ""
    ) -> String {
        var components: [String] = [
            "Masterpiece gourmet culinary photography of \(dishName)",
            style.promptDescription,
            lighting.promptDescription,
            "shallow depth of field, 85mm lens f/1.8, award-winning food styling, mouthwatering appetizing texture, photorealistic, 8k resolution"
        ]
        
        let trimmedExtra = extraDetails.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedExtra.isEmpty {
            components.append(trimmedExtra)
        }
        
        return components.joined(separator: ", ")
    }
    
    /// Generates image URL using Pollinations.ai (Flux Engine - Free & Fast)
    public func generateImageURL(prompt: String, width: Int = 1024, height: Int = 1024) -> URL? {
        guard let encodedPrompt = prompt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        let seed = Int.random(in: 100000...999999)
        let urlString = "https://image.pollinations.ai/prompt/\(encodedPrompt)?width=\(width)&height=\(height)&model=flux&seed=\(seed)&nologo=true"
        return URL(string: urlString)
    }
    
    /// Generates structured culinary recipe data
    public func createRecipe(for dishName: String, cuisine: Cuisine) -> FoodRecipe {
        let sampleIngredients = [
            Ingredient(name: "\(dishName) için taze ana malzeme", amount: "500g"),
            Ingredient(name: "Sızma zeytinyağı veya tereyağı", amount: "2 yemek kaşığı"),
            Ingredient(name: "Taze sarımsak, ince kıyılmış", amount: "2 diş"),
            Ingredient(name: "Deniz tuzu & taze çekilmiş karabiber", amount: "1 çay kaşığı"),
            Ingredient(name: "Taze biberiye / fesleğen / maydanoz", amount: "1 tutam"),
            Ingredient(name: "Şefin özel sosu ve narenciye kabuğu rendesi", amount: "1 tatlı kaşığı")
        ]
        
        let sampleInstructions = [
            "Tüm taze malzemeleri yıkayın, kurulayın ve oda sıcaklığına getirin.",
            "Tavayı veya fırını ideal pişirme derecesine ısıtın ve aromatik otları zeytinyağı ile buluşturun.",
            "\(dishName) malzemesini altın sarısı kıvama gelene ve karamelize olana kadar özenle pişirin.",
            "Lezzet ve suların dengelenmesi için piştikten sonra 3-5 dakika dinlendirin.",
            "Sanatsal şef dokunuşuyla tabaklayın, sos gezdirin ve taze mikro filizlerle süsleyin."
        ]
        
        return FoodRecipe(
            title: dishName,
            cuisine: cuisine,
            description: "\(cuisine.rawValue) dokunuşlarıyla hazırlanan, modern gastronomi teknikleriyle harmanlanmış enfes bir \(dishName) deneyimi.",
            prepTime: "15 dk",
            cookTime: "25 dk",
            calories: "\(Int.random(in: 380...650)) kcal",
            servings: "2-4 Porsiyon",
            difficulty: .medium,
            ingredients: sampleIngredients,
            instructions: sampleInstructions,
            chefTip: "En iyi lezzet ve sunum görseli için servis öncesi hafifçe zeytinyağı gezdirip sıcak servis yapın.",
            promptUsed: craftFoodPrompt(dishName: dishName)
        )
    }
}
