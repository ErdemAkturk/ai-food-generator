import streamlit as st
import io
import time
from PIL import Image
from generator import (
    craft_food_prompt, 
    generate_image_pollinations, 
    generate_image_openai, 
    generate_sample_recipe,
    STYLE_PRESETS,
    LIGHTING_PRESETS
)

# Page configuration
st.set_page_config(
    page_title="GourmetAI - AI Food & Recipe Generator",
    page_icon="🍳",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS for styling
st.markdown("""
<style>
    .main-header {
        font-size: 2.4rem;
        font-weight: 800;
        background: linear-gradient(90deg, #FF4B4B, #FF8C00);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        margin-bottom: 0.2rem;
    }
    .sub-header {
        font-size: 1.1rem;
        color: #666;
        margin-bottom: 1.5rem;
    }
    .recipe-card {
        background-color: #f9f9fb;
        border-radius: 12px;
        padding: 20px;
        border: 1px solid #e1e4e8;
    }
    .badge {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 20px;
        background: #ffe8e8;
        color: #d93838;
        font-weight: 600;
        font-size: 0.85rem;
        margin-right: 6px;
    }
</style>
""", unsafe_allow_html=True)

# Session state initialization for history
if "history" not in st.session_state:
    st.session_state.history = []

# Sidebar Controls
with st.sidebar:
    st.image("https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500&q=80", use_container_width=True)
    st.title("⚙️ AI Configuration")
    
    engine = st.selectbox(
        "Image Engine",
        options=["Pollinations AI (FLUX - Free / Fast)", "OpenAI DALL-E 3 (Requires API Key)"],
        index=0
    )
    
    openai_key = ""
    if "OpenAI" in engine:
        openai_key = st.text_input("OpenAI API Key", type="password", placeholder="sk-...")
        dalle_quality = st.selectbox("DALL-E Quality", ["standard", "hd"])
    
    st.divider()
    st.subheader("🎨 Culinary Photography")
    
    selected_style = st.selectbox("Presentation Style", list(STYLE_PRESETS.keys()), index=0)
    selected_lighting = st.selectbox("Lighting Style", list(LIGHTING_PRESETS.keys()), index=1)
    
    aspect_ratio = st.selectbox(
        "Aspect Ratio / Resolution",
        ["1:1 Square (1024x1024)", "16:9 Landscape (1280x720)", "9:16 Portrait (720x1280)"]
    )
    
    # Dimension mapping
    dim_map = {
        "1:1 Square (1024x1024)": (1024, 1024),
        "16:9 Landscape (1280x720)": (1280, 720),
        "9:16 Portrait (720x1280)": (720, 1280)
    }
    img_width, img_height = dim_map[aspect_ratio]
    
    st.divider()
    st.caption("🚀 Powered by Flux / DALL-E 3 & GourmetAI Prompt Engine")

# Main Page Header
st.markdown('<div class="main-header">🍳 GourmetAI — AI Food & Recipe Generator</div>', unsafe_allow_html=True)
st.markdown('<div class="sub-header">Generate photorealistic AI gourmet food visuals and step-by-step culinary recipes in seconds.</div>', unsafe_allow_html=True)

# Form Inputs
col_dish, col_cuisine = st.columns([3, 1])

with col_dish:
    dish_name = st.text_input("🍽️ Dish or Food Name", placeholder="e.g. Creamy Truffle Fettuccine with Fresh Shaved Truffles and Crispy Sage")

with col_cuisine:
    cuisine = st.selectbox("🌍 Cuisine", ["International", "Italian", "Turkish", "Japanese", "French", "Mexican", "Asian Fusion", "Mediterranean", "American BBQ"])

extra_details = st.text_input("✨ Extra Visual Details (Optional)", placeholder="e.g. steam rising, golden crispy crust, microgreens garnish, wooden table")

generate_btn = st.button("🚀 Generate AI Food Image & Recipe", type="primary", use_container_width=True)

if generate_btn:
    if not dish_name.strip():
        st.warning("⚠️ Please enter a dish or food name to continue.")
    else:
        with st.spinner("🧑‍🍳 Master AI Chef is cooking your image & recipe..."):
            start_time = time.time()
            
            # 1. Craft AI Prompt
            enhanced_prompt = craft_food_prompt(
                dish_name=dish_name,
                style=selected_style,
                lighting=selected_lighting,
                extra_details=extra_details
            )
            
            # 2. Generate Image
            image = None
            error_msg = None
            try:
                if "OpenAI" in engine:
                    image = generate_image_openai(
                        prompt=enhanced_prompt,
                        api_key=openai_key,
                        quality=dalle_quality
                    )
                else:
                    image = generate_image_pollinations(
                        prompt=enhanced_prompt,
                        width=img_width,
                        height=img_height,
                        model="flux"
                    )
            except Exception as e:
                error_msg = str(e)
            
            elapsed = round(time.time() - start_time, 2)
            
            if error_msg:
                st.error(f"❌ Image Generation Failed: {error_msg}")
            else:
                # 3. Generate Recipe
                recipe = generate_sample_recipe(dish_name, cuisine=cuisine)
                
                # Save to history
                st.session_state.history.insert(0, {
                    "dish": dish_name,
                    "image": image,
                    "recipe": recipe,
                    "prompt": enhanced_prompt
                })

# Display the latest result
if st.session_state.history:
    latest = st.session_state.history[0]
    st.divider()
    
    col_img, col_rec = st.columns([1, 1], gap="large")
    
    with col_img:
        st.subheader("📸 AI Generated Food Visual")
        st.image(latest["image"], caption=f"✨ {latest['dish']}", use_container_width=True)
        
        # Download Image Button
        buf = io.BytesIO()
        latest["image"].save(buf, format="PNG")
        byte_im = buf.getvalue()
        
        filename = f"{latest['dish'].lower().replace(' ', '_')[:30]}_ai.png"
        st.download_button(
            label="💾 Download HD Image (.PNG)",
            data=byte_im,
            file_name=filename,
            mime="image/png",
            use_container_width=True
        )
        
        with st.expander("🔍 View AI Prompt Used"):
            st.code(latest["prompt"], language="text")

    with col_rec:
        rec = latest["recipe"]
        st.subheader(f"📖 Recipe: {rec['title']}")
        
        st.markdown(f"""
        <span class="badge">🌍 {rec['cuisine']}</span>
        <span class="badge">⏱️ Prep: {rec['prep_time']}</span>
        <span class="badge">🔥 Cook: {rec['cook_time']}</span>
        <span class="badge">⚡ {rec['calories']}</span>
        <span class="badge">👥 {rec['servings']}</span>
        """, unsafe_allow_html=True)
        
        st.write("")
        st.write(rec["description"])
        
        st.markdown("### 🛒 Ingredients")
        for ing in rec["ingredients"]:
            st.markdown(f"- {ing}")
            
        st.markdown("### 🍳 Instructions")
        for i, step in enumerate(rec["instructions"], 1):
            st.markdown(f"**{i}.** {step}")
            
        st.info(f"💡 **Chef's Tip:** {rec['chef_tips']}")
        
        # Recipe download markdown
        recipe_md = f"""# {rec['title']} ({rec['cuisine']})
**Prep Time:** {rec['prep_time']} | **Cook Time:** {rec['cook_time']} | **Calories:** {rec['calories']}

## Description
{rec['description']}

## Ingredients
""" + "\n".join([f"- {item}" for item in rec['ingredients']]) + f"""

## Instructions
""" + "\n".join([f"{i}. {item}" for i, item in enumerate(rec['instructions'], 1)]) + f"""

## Chef's Tip
{rec['chef_tips']}
"""
        st.download_button(
            label="📋 Download Recipe (.MD)",
            data=recipe_md,
            file_name=f"{latest['dish'].lower().replace(' ', '_')[:30]}_recipe.md",
            mime="text/markdown",
            use_container_width=True
        )

# Gallery of previous creations if more than 1
if len(st.session_state.history) > 1:
    st.divider()
    st.subheader("🖼️ Previous Creations Gallery")
    history_cols = st.columns(min(len(st.session_state.history) - 1, 3))
    for idx, item in enumerate(st.session_state.history[1:4]):
        with history_cols[idx]:
            st.image(item["image"], caption=item["dish"], use_container_width=True)
