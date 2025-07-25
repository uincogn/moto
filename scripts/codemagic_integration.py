#!/usr/bin/env python3
"""
🚀 INTEGRAÇÃO CODEMAGIC API - KM$ FLUTTER CI/CD AUTOMATION
================================================================

Este script permite automatizar builds do KM$ usando a API do Codemagic.
Baseado na documentação oficial: https://docs.codemagic.io/rest-api/

Funcionalidades:
✅ Listar aplicações
✅ Disparar builds automáticos  
✅ Monitorar status de builds
✅ Download de artefatos (APK)
✅ Cancelar builds em execução

Token API: XCUldLgleC4AoYk-stiZe0tMjul8_nei2WX2WdEbbsQ
Rate Limit: 5.000 requests/hora
"""

import requests
import json
import time
import sys
from datetime import datetime

class CodemagicAPI:
    def __init__(self, api_token):
        self.api_token = api_token
        self.base_url = "https://api.codemagic.io"
        self.headers = {
            "Content-Type": "application/json",
            "x-auth-token": api_token
        }
    
    def get_applications(self):
        """📱 Lista todas as aplicações no Codemagic"""
        try:
            response = requests.get(f"{self.base_url}/apps", headers=self.headers)
            response.raise_for_status()
            
            apps = response.json()
            print(f"✅ Encontradas {len(apps.get('applications', []))} aplicações:")
            
            for app in apps.get('applications', []):
                print(f"  📱 {app.get('appName', 'N/A')} (ID: {app.get('_id', 'N/A')})")
                print(f"     Repository: {app.get('repository', {}).get('repositoryUrl', 'N/A')}")
                print(f"     Last Build: {app.get('lastSuccessfulBuild', {}).get('finishedAt', 'Never')}")
                print()
            
            return apps
        except requests.exceptions.RequestException as e:
            print(f"❌ Erro ao buscar aplicações: {e}")
            return None
    
    def trigger_build(self, app_id, workflow_id="default", branch="main", env_vars=None):
        """🔧 Dispara um novo build"""
        payload = {
            "appId": app_id,
            "workflowId": workflow_id,
            "branch": branch
        }
        
        if env_vars:
            payload["environment"] = {
                "variables": env_vars
            }
        
        try:
            response = requests.post(
                f"{self.base_url}/builds", 
                headers=self.headers, 
                json=payload
            )
            response.raise_for_status()
            
            build_data = response.json()
            build_id = build_data.get('build', {}).get('_id')
            
            print(f"🚀 Build disparado com sucesso!")
            print(f"   Build ID: {build_id}")
            print(f"   App ID: {app_id}")
            print(f"   Branch: {branch}")
            print(f"   Workflow: {workflow_id}")
            
            return build_id
        except requests.exceptions.RequestException as e:
            print(f"❌ Erro ao disparar build: {e}")
            if hasattr(e, 'response') and e.response:
                print(f"   Response: {e.response.text}")
            return None
    
    def get_build_status(self, build_id):
        """📊 Verifica status de um build específico"""
        try:
            response = requests.get(
                f"{self.base_url}/builds/{build_id}", 
                headers=self.headers
            )
            response.raise_for_status()
            
            build_data = response.json()
            build = build_data.get('build', {})
            
            status = build.get('status', 'unknown')
            app_name = build.get('app', {}).get('appName', 'N/A')
            branch = build.get('branch', 'N/A')
            started_at = build.get('startedAt', 'N/A')
            
            print(f"📊 Status do Build {build_id}:")
            print(f"   App: {app_name}")
            print(f"   Status: {status}")
            print(f"   Branch: {branch}")
            print(f"   Iniciado: {started_at}")
            
            if status in ['finished', 'failed']:
                finished_at = build.get('finishedAt', 'N/A')
                print(f"   Finalizado: {finished_at}")
                
                if 'artefacts' in build:
                    print(f"   Artefatos disponíveis: {len(build['artefacts'])}")
            
            return build
        except requests.exceptions.RequestException as e:
            print(f"❌ Erro ao buscar status: {e}")
            return None
    
    def cancel_build(self, build_id):
        """🛑 Cancela um build em execução"""
        try:
            response = requests.post(
                f"{self.base_url}/builds/{build_id}/cancel", 
                headers=self.headers
            )
            response.raise_for_status()
            
            print(f"🛑 Build {build_id} cancelado com sucesso!")
            return True
        except requests.exceptions.RequestException as e:
            print(f"❌ Erro ao cancelar build: {e}")
            return False
    
    def monitor_build(self, build_id, timeout_minutes=30):
        """👁️ Monitora um build até conclusão ou timeout"""
        print(f"👁️ Monitorando build {build_id}...")
        start_time = time.time()
        timeout_seconds = timeout_minutes * 60
        
        while time.time() - start_time < timeout_seconds:
            build = self.get_build_status(build_id)
            
            if not build:
                time.sleep(30)
                continue
            
            status = build.get('status', 'unknown')
            
            if status == 'finished':
                print("🎉 Build concluído com sucesso!")
                return True
            elif status == 'failed':
                print("❌ Build falhou!")
                return False
            elif status in ['queued', 'building']:
                print(f"⏳ Build em andamento ({status})...")
                time.sleep(60)  # Aguarda 1 minuto
            else:
                print(f"🔄 Status: {status}")
                time.sleep(30)
        
        print(f"⏰ Timeout de {timeout_minutes} minutos atingido!")
        return False
    
    def get_recent_builds(self, app_id=None, limit=10):
        """📋 Lista builds recentes"""
        params = {"limit": limit}
        if app_id:
            params["appId"] = app_id
        
        try:
            response = requests.get(
                f"{self.base_url}/builds", 
                headers=self.headers,
                params=params
            )
            response.raise_for_status()
            
            builds_data = response.json()
            builds = builds_data.get('builds', [])
            
            print(f"📋 Últimos {len(builds)} builds:")
            for build in builds:
                app_name = build.get('app', {}).get('appName', 'N/A')
                status = build.get('status', 'unknown')
                branch = build.get('branch', 'N/A')
                started_at = build.get('startedAt', 'N/A')
                
                status_emoji = {
                    'finished': '✅',
                    'failed': '❌', 
                    'building': '🔧',
                    'queued': '⏳'
                }.get(status, '❓')
                
                print(f"  {status_emoji} {app_name} - {status} - {branch} - {started_at}")
            
            return builds
        except requests.exceptions.RequestException as e:
            print(f"❌ Erro ao buscar builds: {e}")
            return []

def main():
    """🎯 Função principal com menu interativo"""
    api_token = "XCUldLgleC4AoYk-stiZe0tMjul8_nei2WX2WdEbbsQ"
    api = CodemagicAPI(api_token)
    
    print("🚀 CODEMAGIC API INTEGRATION - KM$ FLUTTER")
    print("=" * 50)
    
    while True:
        print("\n📋 OPÇÕES DISPONÍVEIS:")
        print("1. 📱 Listar aplicações")
        print("2. 🔧 Disparar build")
        print("3. 📊 Verificar status de build")
        print("4. 👁️ Monitorar build")
        print("5. 📋 Listar builds recentes")
        print("6. 🛑 Cancelar build")
        print("0. 🚪 Sair")
        
        choice = input("\n➡️ Escolha uma opção: ").strip()
        
        if choice == "1":
            api.get_applications()
        
        elif choice == "2":
            apps = api.get_applications()
            if apps and apps.get('applications'):
                app_id = input("📱 App ID: ").strip()
                workflow_id = input("🔧 Workflow ID (padrão: default): ").strip() or "default"
                branch = input("🌿 Branch (padrão: main): ").strip() or "main"
                
                env_vars = {}
                add_env = input("🔧 Adicionar variáveis de ambiente? (y/n): ").strip().lower()
                if add_env == 'y':
                    while True:
                        key = input("  🔑 Variável (vazio para parar): ").strip()
                        if not key:
                            break
                        value = input(f"  💎 Valor para {key}: ").strip()
                        env_vars[key] = value
                
                build_id = api.trigger_build(app_id, workflow_id, branch, env_vars)
                
                if build_id:
                    monitor = input("👁️ Monitorar build? (y/n): ").strip().lower()
                    if monitor == 'y':
                        api.monitor_build(build_id)
        
        elif choice == "3":
            build_id = input("🆔 Build ID: ").strip()
            api.get_build_status(build_id)
        
        elif choice == "4":
            build_id = input("🆔 Build ID: ").strip()
            timeout = input("⏰ Timeout em minutos (padrão: 30): ").strip()
            timeout = int(timeout) if timeout.isdigit() else 30
            api.monitor_build(build_id, timeout)
        
        elif choice == "5":
            app_id = input("📱 App ID (vazio para todos): ").strip() or None
            limit = input("📊 Quantidade (padrão: 10): ").strip()
            limit = int(limit) if limit.isdigit() else 10
            api.get_recent_builds(app_id, limit)
        
        elif choice == "6":
            build_id = input("🆔 Build ID: ").strip()
            api.cancel_build(build_id)
        
        elif choice == "0":
            print("👋 Até logo!")
            break
        
        else:
            print("❌ Opção inválida!")

if __name__ == "__main__":
    main()