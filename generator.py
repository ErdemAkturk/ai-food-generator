"""
GourmetAI - Core Generation Engine
Handles prompt enrichment, AI image synthesis (Pollinations.ai & OpenAI DALL-E), and recipe generation.
"""

import os
import io
import urllib.parse
import random
import requests
from PIL import Image

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

# Style presets for food photography
STYLE_PRESETS = {
    "Michelin Star Fine Dining": "gourmet Michelin-star plating, artistic sauce drizzle, microgreens garnish, dark slate plate, luxury restaurant atmosphere, soft cinematic bokeh, ultra-detailed 8k food photography",
    "Cozy Rustic Homestyle": "warm rustic ceramic bowl, steam rising, wooden table background, natural window light, fresh herbs scattered, homestyle comfort food, authentic texture",
    "Modern Commercial / Studio": "bright studio lighting, high key commercial food photography, crisp focus, vibrant colors, glistening textures, professional magazine cover aesthetic",
    "Street Food Close-up": "vibrant street food presentation, sizzling hot, authentic packaging/wax paper, close-up macro details, savory dripping sauces, energetic night market ambiance",
    "Minimalist Contemporary": "minimalist aesthetic, clean white porcelain, elegant geometric plating, negative space, subtle shadows, contemporary culinary art"
}

LIGHTING_PRESETS = {
    "Golden Hour / Warm Light": "warm golden hour lighting, gentle highlights, inviting glow",
    "Soft Studio Diffused": "soft diffused studio lighting, balanced illumination, crisp reflections",
    "Dramatic Moody / Chiaroscuro": "moody dark background, dramatic rim lighting, high contrast highlights",
    "Bright Daylight": "bright airy morning daylight, fresh and vibrant atmosphere"
}

def craft_food_prompt(dish_name: str, 
                      style: str = "Michelin Star Fine Dining", 
                      lighting: str = "Soft Studio Diffused", 
                      extra_details: str = "") -> str:
    """
    Crafts an optimized, detailed prompt for AI image generation models (FLUX, SDXL, DALL-E).
    """
    style_desc = STYLE_PRESETS.get(style, STYLE_PRESETS["Michelin Star Fine Dining"])
    lighting_desc = LIGHTING_PRESETS.get(lighting, LIGHTING_PRESETS["Soft Studio Diffused"])
    
    parts = [
        f"Masterpiece gourmet culinary photography of {dish_name}",
        style_desc,
        lighting_desc,
        "shallow depth of field, 85mm lens f/1.8, award-winning food styling, mouthwatering appetizing texture, photorealistic, 8k resolution"
    ]
    
    if extra_details.strip():
        parts.append(extra_details.strip())
        
    return ", ".join(parts)


def generate_image_pollinations(prompt: str, 
                               width: int = 1024, 
                               height: int = 1024, 
                               model: str = "flux",
                               seed: int = None) -> Image.Image:
    """
    Generates an AI image using Pollinations.ai (Free, Fast, No API key needed).
    Supports models like 'flux', 'turbo'.
    """
    if seed is None:
        seed = random.randint(1, 9999999)
        
    encoded_prompt = urllib.parse.quote(prompt)
    url = f"https://image.pollinations.ai/prompt/{encoded_prompt}?width={width}&height={height}&model={model}&seed={seed}&nologo=true"
    
    response = requests.get(url, timeout=45)
    response.raise_for_status()
    
    image = Image.open(io.BytesIO(response.content))
    return image


def generate_image_openai(prompt: str, 
                          api_key: str = None, 
                          size: str = "1024x1024", 
                          quality: str = "standard") -> Image.Image:
    """
    Generates an AI image using OpenAI DALL-E 3 API.
    """
    from openai import OpenAI
    
    key = api_key or os.getenv("OPENAI_API_KEY")
    if not key:
        raise ValueError("OpenAI API Key is missing. Please set OPENAI_API_KEY in .env or pass it directly.")
        
    client = OpenAI(api_key=key)
    response = client.images.generate(
        model="dall-e-3",
        prompt=prompt,
        size=size,
        quality=quality,
        n=1,
    )
    
    image_url = response.data[0].url
    img_resp = requests.get(image_url, timeout=30)
    img_resp.raise_for_status()
    
    return Image.open(io.BytesIO(img_resp.content))


def generate_sample_recipe(dish_name: str, cuisine: str = "International") -> dict:
    """
    Generates sample structured recipe and nutrition information for the dish.
    """
    return {
        "title": dish_name,
        "cuisine": cuisine,
        "prep_time": "15 mins",
        "cook_time": "25 mins",
        "calories": "480 kcal",
        "servings": "2-4 portions",
        "difficulty": "Medium",
        "description": f"A delightful and flavorful {cuisine.lower()}-inspired preparation of {dish_name}, styled with modern culinary techniques for an exceptional dining experience.",
        "ingredients": [
            f"500g Main ingredient for {dish_name}",
            "2 tbsp Extra virgin olive oil / butter",
            "2 cloves Fresh garlic, minced",
            "1 tsp Sea salt & freshly ground black pepper",
            "Fresh herbs (rosemary, thyme or parsley) for garnish",
            "Chef's special seasoning & citrus zest"
        ],
        "instructions": [
            "Prepare and rinse all fresh ingredients. Pat dry before seasoning.",
            "Heat skillet/oven to the optimal temperature and infuse aromatic herbs with olive oil.",
            f"Cook the {dish_name} until golden brown, tender, and properly caramelized.",
            "Rest for 3-5 minutes to allow juices and flavors to settle.",
            "Plate with artistic flair, drizzle reductions, and garnish with fresh microgreens."
        ],
        "chef_tips": "For the best visual appeal and taste, serve immediately while warm with contrasting garnishes."
    }
