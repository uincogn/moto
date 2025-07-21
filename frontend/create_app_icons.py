#!/usr/bin/env python3
"""
Script para gerar ícones do app Motouber em diferentes resoluções
Baseado na imagem do motociclista tocando a lua
"""

import os
from xml.dom import minidom

# Tamanhos necessários para Android
ICON_SIZES = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192
}

def create_icon_svg(size):
    """Cria SVG do ícone em tamanho específico"""
    return f'''<svg width="{size}" height="{size}" viewBox="0 0 {size} {size}" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <radialGradient id="skyGradient" cx="50%" cy="30%" r="80%">
      <stop offset="0%" style="stop-color:#2C3E50;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#1A252F;stop-opacity:1" />
    </radialGradient>
    <radialGradient id="moonGradient" cx="30%" cy="30%" r="70%">
      <stop offset="0%" style="stop-color:#F8F8FF;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#E6E6FA;stop-opacity:1" />
    </radialGradient>
  </defs>
  
  <!-- Rounded background -->
  <rect width="{size}" height="{size}" rx="{size//8}" ry="{size//8}" fill="url(#skyGradient)"/>
  
  <!-- Moon -->
  <circle cx="{size//2}" cy="{size//3.2}" r="{size//7}" fill="url(#moonGradient)" stroke="#D3D3D3" stroke-width="1"/>
  <circle cx="{size//2.2}" cy="{size//3.5}" r="{size//64}" fill="#C0C0C0" opacity="0.6"/>
  <circle cx="{size//1.9}" cy="{size//3.1}" r="{size//96}" fill="#C0C0C0" opacity="0.5"/>
  <circle cx="{size//2.1}" cy="{size//2.9}" r="{size//77}" fill="#C0C0C0" opacity="0.4"/>
  
  <!-- Ground -->
  <path d="M 0 {size*0.73} Q {size*0.25} {size*0.625} {size*0.5} {size*0.65} Q {size*0.75} {size*0.677} {size} {size*0.73} L {size} {size} L 0 {size} Z" fill="#1A1A1A"/>
  
  <!-- Motorcycle and rider -->
  <g transform="translate({size//2},{size*0.69}) scale({size/160})">
    <!-- Motorcycle body -->
    <ellipse cx="0" cy="8" rx="12" ry="4" fill="#2C3E50"/>
    
    <!-- Wheels -->
    <circle cx="-10" cy="12" r="6" fill="#34495E" stroke="#4A6741" stroke-width="1"/>
    <circle cx="10" cy="12" r="6" fill="#34495E" stroke="#4A6741" stroke-width="1"/>
    
    <!-- Rider -->
    <ellipse cx="-2" cy="0" rx="3" ry="6" fill="#E74C3C"/>
    <circle cx="-2" cy="-4" r="2.5" fill="#F39C12"/>
    
    <!-- Rider arm reaching for moon -->
    <path d="M -4 -2 Q -8 -12 -6 -20" stroke="#E74C3C" stroke-width="2" fill="none" stroke-linecap="round"/>
    <circle cx="-6" cy="-20" r="1.5" fill="#F39C12"/>
    
    <!-- Handlebar -->
    <line x1="-8" y1="2" x2="2" y2="2" stroke="#4A6741" stroke-width="1.5"/>
  </g>
  
  <!-- App name for larger icons -->
  {"" if size < 144 else f'<text x="{size//2}" y="{size*0.91}" text-anchor="middle" font-family="Arial, sans-serif" font-size="{size//14}" font-weight="bold" fill="#FFFFFF">MOTOUBER</text>'}
</svg>'''

def main():
    """Gera todos os ícones necessários"""
    android_path = "android/app/src/main/res"
    
    for folder, size in ICON_SIZES.items():
        # Criar diretório se não existir
        icon_dir = os.path.join(android_path, folder)
        os.makedirs(icon_dir, exist_ok=True)
        
        # Criar arquivo SVG
        svg_content = create_icon_svg(size)
        svg_path = os.path.join(icon_dir, "ic_launcher.svg")
        
        with open(svg_path, 'w', encoding='utf-8') as f:
            f.write(svg_content)
        
        print(f"✅ Criado: {svg_path} ({size}x{size})")
    
    print(f"\n🎉 Todos os ícones criados com sucesso!")
    print(f"📱 Tema: Motociclista tocando a lua")
    print(f"🎨 Estilo: Silhueta noturna com gradientes")

if __name__ == "__main__":
    main()