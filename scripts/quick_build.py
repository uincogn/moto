#!/usr/bin/env python3
"""
⚡ QUICK BUILD SCRIPT - KM$ FLUTTER
==================================

Script rápido para disparar builds do KM$ via Codemagic API
Ideal para automação e integração com outros sistemas.

Usage:
  python quick_build.py [app_id] [workflow_id] [branch]

Exemplo:
  python quick_build.py 5c9c064185dd2310123b8e96 release main
"""

import requests
import sys
import json
from datetime import datetime

# Configuração
API_TOKEN = "XCUldLgleC4AoYk-stiZe0tMjul8_nei2WX2WdEbbsQ"
BASE_URL = "https://api.codemagic.io"

def trigger_quick_build(app_id=None, workflow_id="default", branch="main"):
    """🚀 Dispara build rápido"""
    
    headers = {
        "Content-Type": "application/json",
        "x-auth-token": API_TOKEN
    }
    
    # Se app_id não foi fornecido, busca automaticamente
    if not app_id:
        print("🔍 Buscando aplicações disponíveis...")
        try:
            response = requests.get(f"{BASE_URL}/apps", headers=headers)
            response.raise_for_status()
            
            apps = response.json().get('applications', [])
            if not apps:
                print("❌ Nenhuma aplicação encontrada!")
                return False
            
            print("📱 Aplicações disponíveis:")
            for i, app in enumerate(apps):
                print(f"  {i+1}. {app.get('appName', 'N/A')} ({app.get('_id', 'N/A')})")
            
            if len(apps) == 1:
                app_id = apps[0].get('_id')
                print(f"🎯 Usando aplicação: {apps[0].get('appName')} ({app_id})")
            else:
                choice = input("➡️ Escolha o número da aplicação: ").strip()
                try:
                    app_index = int(choice) - 1
                    app_id = apps[app_index].get('_id')
                    print(f"🎯 Selecionado: {apps[app_index].get('appName')} ({app_id})")
                except (ValueError, IndexError):
                    print("❌ Seleção inválida!")
                    return False
        
        except requests.exceptions.RequestException as e:
            print(f"❌ Erro ao buscar aplicações: {e}")
            return False
    
    # Dispara o build
    payload = {
        "appId": app_id,
        "workflowId": workflow_id,
        "branch": branch,
        "environment": {
            "variables": {
                "BUILD_TIMESTAMP": datetime.now().isoformat(),
                "BUILD_MODE": "automated",
                "TRIGGERED_BY": "quick_build_script"
            }
        }
    }
    
    print(f"🚀 Disparando build...")
    print(f"   App ID: {app_id}")
    print(f"   Workflow: {workflow_id}")
    print(f"   Branch: {branch}")
    
    try:
        response = requests.post(f"{BASE_URL}/builds", headers=headers, json=payload)
        response.raise_for_status()
        
        result = response.json()
        build_id = result.get('build', {}).get('_id')
        
        if build_id:
            print(f"✅ Build disparado com sucesso!")
            print(f"   Build ID: {build_id}")
            print(f"   🔗 Monitor: https://codemagic.io/app/{app_id}/build/{build_id}")
            return build_id
        else:
            print("❌ Falha ao obter Build ID da resposta")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ Erro ao disparar build: {e}")
        if hasattr(e, 'response') and e.response:
            print(f"   Detalhes: {e.response.text}")
        return False

def main():
    """🎯 Função principal"""
    print("⚡ QUICK BUILD - KM$ FLUTTER")
    print("=" * 30)
    
    # Parse argumentos
    app_id = sys.argv[1] if len(sys.argv) > 1 else None
    workflow_id = sys.argv[2] if len(sys.argv) > 2 else "default"
    branch = sys.argv[3] if len(sys.argv) > 3 else "main"
    
    # Dispara build
    build_id = trigger_quick_build(app_id, workflow_id, branch)
    
    if build_id:
        print(f"\n🎉 BUILD INICIADO COM SUCESSO!")
        print(f"Build ID: {build_id}")
        sys.exit(0)
    else:
        print(f"\n❌ FALHA AO INICIAR BUILD!")
        sys.exit(1)

if __name__ == "__main__":
    main()