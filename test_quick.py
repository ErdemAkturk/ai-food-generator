"""
Quick Test Script for GourmetAI
Generates a test food image without needing Streamlit.
"""

import sys

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
        sys.stderr.reconfigure(encoding='utf-8', errors='replace')
    except Exception:
        pass

from generator import craft_food_prompt, generate_image_pollinations

def run_test():
    dish = "Authentic Neapolitan Margherita Pizza with fresh basil and melted buffalo mozzarella"
    print(f"1. Crafting prompt for: {dish}")
    prompt = craft_food_prompt(dish, style="Michelin Star Fine Dining")
    print(f"   Prompt: {prompt}")
    
    print("2. Downloading AI generated image from Pollinations (Flux Engine)...")
    img = generate_image_pollinations(prompt, width=512, height=512)
    
    output_filename = "test_food_output.png"
    img.save(output_filename)
    print(f"3. Done! Image successfully saved as '{output_filename}' (Resolution: {img.size})")

if __name__ == "__main__":
    run_test()
