"""
GourmetAI - Command Line Interface (CLI)
Generate gourmet food images directly from your terminal.

Usage:
    python cli.py --dish "Gourmet Cheeseburger with Truffle Fries" --output "burger.png"
"""

import argparse
import os
import sys

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
        sys.stderr.reconfigure(encoding='utf-8', errors='replace')
    except Exception:
        pass

from generator import (
    craft_food_prompt, 
    generate_image_pollinations, 
    generate_image_openai, 
    STYLE_PRESETS, 
    LIGHTING_PRESETS
)

def main():
    parser = argparse.ArgumentParser(description="Generate AI Food Images via CLI")
    parser.add_argument("--dish", "-d", type=str, required=True, help="Name of the food / dish to generate")
    parser.add_argument("--style", "-s", type=str, default="Michelin Star Fine Dining", choices=list(STYLE_PRESETS.keys()), help="Food photography style")
    parser.add_argument("--lighting", "-l", type=str, default="Soft Studio Diffused", choices=list(LIGHTING_PRESETS.keys()), help="Lighting setup")
    parser.add_argument("--engine", "-e", type=str, default="pollinations", choices=["pollinations", "openai"], help="Image generation backend engine")
    parser.add_argument("--output", "-o", type=str, default="generated_food.png", help="Output file path for saving the image")
    parser.add_argument("--width", type=int, default=1024, help="Image width in pixels")
    parser.add_argument("--height", type=int, default=1024, help="Image height in pixels")
    
    args = parser.parse_args()
    
    print(f"\n👨‍🍳 [GourmetAI] Crafting visual prompt for: '{args.dish}'...")
    prompt = craft_food_prompt(dish_name=args.dish, style=args.style, lighting=args.lighting)
    print(f"✨ Enriched Prompt: {prompt}\n")
    
    print(f"🚀 Generating image with engine: '{args.engine}'...")
    
    try:
        if args.engine == "openai":
            image = generate_image_openai(prompt=prompt)
        else:
            image = generate_image_pollinations(prompt=prompt, width=args.width, height=args.height)
            
        output_dir = os.path.dirname(args.output)
        if output_dir and not os.path.exists(output_dir):
            os.makedirs(output_dir, exist_ok=True)
            
        image.save(args.output)
        print(f"✅ Success! Image saved to: {os.path.abspath(args.output)}\n")
        
    except Exception as e:
        print(f"❌ Error generating image: {e}")

if __name__ == "__main__":
    main()
