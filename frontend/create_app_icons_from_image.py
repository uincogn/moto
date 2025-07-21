#!/usr/bin/env python3
"""
Script para converter imagem em ícones de aplicativo Android
Cria ícones em diferentes resoluções para o Motouber
"""

from PIL import Image, ImageDraw, ImageFilter
import os

def create_circular_icon(image_path, output_path, size):
    """Cria um ícone circular a partir de uma imagem"""
    
    # Abrir a imagem original
    img = Image.open(image_path)
    
    # Redimensionar mantendo proporção
    img = img.resize((size, size), Image.Resampling.LANCZOS)
    
    # Converter para RGBA se necessário
    if img.mode != 'RGBA':
        img = img.convert('RGBA')
    
    # Criar máscara circular
    mask = Image.new('L', (size, size), 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse((0, 0, size, size), fill=255)
    
    # Aplicar máscara circular
    output = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    output.paste(img, (0, 0))
    output.putalpha(mask)
    
    # Salvar
    output.save(output_path, 'PNG')
    print(f"Ícone criado: {output_path} ({size}x{size})")

def create_app_icons():
    """Cria todos os ícones necessários para Android"""
    
    # Caminho da imagem original
    source_image = "attached_assets/Screenshot_20250717-132558_1752769696374.png"
    
    # Verificar se a imagem existe
    if not os.path.exists(source_image):
        print(f"Erro: Imagem não encontrada: {source_image}")
        return
    
    # Tamanhos de ícones Android
    icon_sizes = {
        'mipmap-mdpi': 48,
        'mipmap-hdpi': 72,
        'mipmap-xhdpi': 96,
        'mipmap-xxhdpi': 144,
        'mipmap-xxxhdpi': 192
    }
    
    # Base do diretório de recursos Android
    base_dir = "android/app/src/main/res"
    
    # Criar ícones para cada densidade
    for density, size in icon_sizes.items():
        # Criar diretório se não existir
        icon_dir = os.path.join(base_dir, density)
        os.makedirs(icon_dir, exist_ok=True)
        
        # Caminho do ícone
        icon_path = os.path.join(icon_dir, "ic_launcher.png")
        
        # Criar ícone circular
        create_circular_icon(source_image, icon_path, size)
    
    print("\n✅ Todos os ícones foram criados com sucesso!")
    print("🎯 Tema: Motociclista com lua - perfeito para o Motouber")
    print("📱 Ícones criados para todas as densidades Android")

if __name__ == "__main__":
    create_app_icons()