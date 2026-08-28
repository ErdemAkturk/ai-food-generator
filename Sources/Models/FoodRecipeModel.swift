import Foundation

// MARK: - Food Recipe Data Models

public struct FoodRecipe: Identifiable, Codable, Hashable {
    public let id: UUID
    public let title: String
    public let cuisine: Cuisine
    public let description: String
    public let prepTime: String
    public let cookTime: String
    public let calories: String
    public let servings: String
    public let difficulty: Difficulty
    public let ingredients: [Ingredient]
    public let instructions: [String]
    public let chefTip: String
    public let promptUsed: String
    public var imageURL: URL?
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        title: String,
        cuisine: Cuisine = .international,
        description: String,
        prepTime: String = "15 dk",
        cookTime: String = "25 dk",
        calories: String = "480 kcal",
        servings: String = "2-4 Porsiyon",
        difficulty: Difficulty = .medium,
        ingredients: [Ingredient],
        instructions: [String],
        chefTip: String,
        promptUsed: String,
        imageURL: URL? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.cuisine = cuisine
        self.description = description
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.calories = calories
        self.servings = servings
        self.difficulty = difficulty
        self.ingredients = ingredients
        self.instructions = instructions
        self.chefTip = chefTip
        self.promptUsed = promptUsed
        self.imageURL = imageURL
        self.createdAt = createdAt
    }
}

public struct Ingredient: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let amount: String
    public var isChecked: Bool

    public init(id: UUID = UUID(), name: String, amount: String, isChecked: Bool = false) {
        self.id = id
        self.name = name
        self.amount = amount
        self.isChecked = isChecked
    }
}

public enum Cuisine: String, CaseIterable, Codable, Identifiable {
    case international = "Uluslararası"
    case italian = "İtalyan"
    case turkish = "Türk Mutfağı"
    case japanese = "Japon"
    case french = "Fransız"
    case mexican = "Meksika"
    case mediterranean = "Akdeniz"
    
    public var id: String { self.rawValue }
    
    public var icon: String {
        switch self {
        case .international: return "globe.europe.africa.fill"
        case .italian: return "fork.knife"
        case .turkish: return "flame.fill"
        case .japanese: return "fish.fill"
        case .french: return "wineglass.fill"
        case .mexican: return "leaf.fill"
        case .mediterranean: return "sun.max.fill"
        }
    }
}

public enum Difficulty: String, CaseIterable, Codable {
    case easy = "Kolay"
    case medium = "Orta"
    case hard = "Zor"
}

public enum PresentationStyle: String, CaseIterable, Identifiable {
    case michelin = "Michelin Yıldızlı Şef Sunumu"
    case rustic = "Rustik / Sıcak Ev Yapımı"
    case modernStudio = "Modern Stüdyo & Reklam"
    case streetFood = "Sokak Lezzeti (Street Food)"
    
    public var id: String { self.rawValue }
    
    public var promptDescription: String {
        switch self {
        case .michelin:
            return "gourmet Michelin-star plating, artistic sauce drizzle, microgreens garnish, dark slate plate, luxury restaurant atmosphere, soft cinematic bokeh, ultra-detailed 8k food photography"
        case .rustic:
            return "warm rustic ceramic bowl, steam rising, wooden table background, natural window light, fresh herbs scattered, homestyle comfort food, authentic texture"
        case .modernStudio:
            return "bright studio lighting, high key commercial food photography, crisp focus, vibrant colors, glistening textures, professional magazine cover aesthetic"
        case .streetFood:
            return "vibrant street food presentation, sizzling hot, authentic packaging, close-up macro details, savory dripping sauces, energetic atmosphere"
        }
    }
}

public enum LightingStyle: String, CaseIterable, Identifiable {
    case softStudio = "Yumuşak Stüdyo Işığı"
    case goldenHour = "Altın Saat / Sıcak Işık"
    case moody = "Dramatik / Koyu Arka Plan"
    case daylight = "Doğal Gün Işığı"
    
    public var id: String { self.rawValue }
    
    public var promptDescription: String {
        switch self {
        case .softStudio:
            return "soft diffused studio lighting, balanced illumination, crisp reflections"
        case .goldenHour:
            return "warm golden hour lighting, gentle highlights, inviting glow"
        case .moody:
            return "moody dark background, dramatic rim lighting, high contrast highlights"
        case .daylight:
            return "bright airy morning daylight, fresh and vibrant atmosphere"
        }
    }
}
