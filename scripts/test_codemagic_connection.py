#!/usr/bin/env python3
"""
🧪 TESTE BÁSICO CODEMAGIC API - KM$ FLUTTER
==========================================

Teste simples para verificar conexão e funcionalidades básicas
"""

import requests
import json

# Configuração
API_TOKEN = "XCUldLgleC4AoYk-stiZe0tMjul8_nei2WX2WdEbbsQ"
BASE_URL = "https://api.codemagic.io"

def test_connection():
    """🔌 Testa conexão básica"""
    print("🔌 Testando conexão com Codemagic API...")
    
    headers = {
        "Content-Type": "application/json",
        "x-auth-token": API_TOKEN
    }
    
    try:
        response = requests.get(f"{BASE_URL}/apps", headers=headers)
        print(f"Status: {response.status_code}")
        
        if response.status_code == 200:
            apps = response.json()
            print(f"✅ Sucesso! {len(apps.get('applications', []))} aplicações encontradas:")
            
            for app in apps.get('applications', []):
                app_name = app.get('appName', 'N/A')
                app_id = app.get('_id', 'N/A')
                repo_url = app.get('repository', {}).get('repositoryUrl', 'N/A')
                
                print(f"  📱 {app_name}")
                print(f"     ID: {app_id}")
                print(f"     Repo: {repo_url}")
                print()
                
                # Testar builds recentes para esta app
                test_recent_builds(app_id, app_name)
                
            return True
        else:
            print(f"❌ Erro: {response.status_code}")
            print(f"Resposta: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Erro na conexão: {e}")
        return False

def test_recent_builds(app_id, app_name):
    """📋 Testa busca de builds recentes"""
    headers = {
        "Content-Type": "application/json", 
        "x-auth-token": API_TOKEN
    }
    
    try:
        response = requests.get(
            f"{BASE_URL}/builds?appId={app_id}&limit=5",
            headers=headers
        )
        
        if response.status_code == 200:
            builds_data = response.json()
            builds = builds_data.get('builds', [])
            
            print(f"  📋 Últimos {len(builds)} builds:")
            for build in builds:
                status = build.get('status', 'unknown')
                branch = build.get('branch', 'N/A')
                started_at = build.get('startedAt', 'N/A')
                
                status_emoji = {
                    'finished': '✅',
                    'failed': '❌',
                    'building': '🔧',
                    'queued': '⏳'
                }.get(status, '❓')
                
                print(f"    {status_emoji} {status} - {branch} - {started_at}")
        
    except Exception as e:
        print(f"    ❌ Erro ao buscar builds: {e}")

def suggest_next_steps():
    """🎯 Sugere próximos passos"""
    print("\n🎯 PRÓXIMOS PASSOS SUGERIDOS:")
    print("1. 🚀 Disparar build manual para testar")
    print("2. 🔗 Configurar webhook GitHub para automação")
    print("3. 📢 Configurar notificações Slack/Discord")
    print("4. 📊 Implementar monitoramento contínuo")
    print()
    print("💡 COMANDOS DISPONÍVEIS:")
    print("  python scripts/codemagic_integration.py  # Menu interativo")
    print("  python scripts/quick_build.py             # Build rápido") 
    print("  python scripts/webhook_integration.py     # Servidor webhooks")

if __name__ == "__main__":
    print("🧪 TESTE CODEMAGIC API - KM$ FLUTTER")
    print("=" * 40)
    
    if test_connection():
        suggest_next_steps()
    else:
        print("\n❌ FALHA NA CONEXÃO!")
        print("Verifique:")
        print("- Token API válido")
        print("- Conexão com internet")
        print("- Rate limits não excedidos")