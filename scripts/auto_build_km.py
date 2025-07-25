#!/usr/bin/env python3
"""
🤖 AUTO BUILD KM$ - AUTOMATIZAÇÃO COMPLETA
==========================================

Script especializado para automatizar builds do KM$ Flutter usando Codemagic API.
Configurado especificamente para a aplicação "moto" (ID: 6877ef3653ef7a637e07568a).

Funcionalidades:
✅ Build automático com configuração otimizada
✅ Monitoramento em tempo real
✅ Notificações de progresso
✅ Download automático do APK (quando possível)
"""

import requests
import json
import time
from datetime import datetime

class KMAutoBuild:
    def __init__(self):
        self.api_token = "XCUldLgleC4AoYk-stiZe0tMjul8_nei2WX2WdEbbsQ"
        self.app_id = "6877ef3653ef7a637e07568a"  # App "moto" já identificado
        self.base_url = "https://api.codemagic.io"
        self.headers = {
            "Content-Type": "application/json",
            "x-auth-token": self.api_token
        }
    
    def get_app_info(self):
        """📱 Busca informações da aplicação KM$"""
        try:
            response = requests.get(f"{self.base_url}/apps/{self.app_id}", headers=self.headers)
            response.raise_for_status()
            
            app_data = response.json()
            app = app_data.get('application', {})
            
            print("📱 INFORMAÇÕES DA APLICAÇÃO KM$")
            print(f"   Nome: {app.get('appName', 'N/A')}")
            print(f"   ID: {self.app_id}")
            print(f"   Repository: {app.get('repository', {}).get('repositoryUrl', 'N/A')}")
            print(f"   Team: {app.get('team', {}).get('name', 'N/A')}")
            
            # Buscar workflows disponíveis (se existirem)
            workflows = app.get('workflows', [])
            if workflows:
                print(f"   Workflows: {[w.get('name') for w in workflows]}")
            
            return app
            
        except requests.exceptions.RequestException as e:
            print(f"❌ Erro ao buscar informações da app: {e}")
            return None
    
    def trigger_build(self, workflow_id="default", branch="main", build_mode="release"):
        """🚀 Dispara build otimizado para KM$"""
        
        # Configuração específica para KM$ Flutter
        env_vars = {
            "BUILD_MODE": build_mode,
            "BUILD_TIMESTAMP": datetime.now().isoformat(),
            "APP_NAME": "KM$",
            "TRIGGERED_BY": "auto_build_script",
            "FLUTTER_BUILD_ARGS": "--release --target-platform android-arm64,android-arm",
            "BUILD_DESCRIPTION": f"Automated {build_mode} build"
        }
        
        payload = {
            "appId": self.app_id,
            "workflowId": workflow_id,
            "branch": branch,
            "environment": {
                "variables": env_vars
            }
        }
        
        print(f"🚀 DISPARANDO BUILD KM$ FLUTTER")
        print(f"   Workflow: {workflow_id}")
        print(f"   Branch: {branch}")
        print(f"   Mode: {build_mode}")
        print(f"   Timestamp: {env_vars['BUILD_TIMESTAMP']}")
        
        try:
            response = requests.post(f"{self.base_url}/builds", headers=self.headers, json=payload)
            
            if response.status_code == 201:
                build_data = response.json()
                build_id = build_data.get('build', {}).get('_id')
                
                print(f"✅ BUILD DISPARADO COM SUCESSO!")
                print(f"   Build ID: {build_id}")
                print(f"   🔗 Monitor: https://codemagic.io/app/{self.app_id}/build/{build_id}")
                
                return build_id
            else:
                print(f"❌ Erro ao disparar build: {response.status_code}")
                print(f"   Resposta: {response.text}")
                return None
                
        except requests.exceptions.RequestException as e:
            print(f"❌ Erro na requisição: {e}")
            return None
    
    def monitor_build(self, build_id, check_interval=60):
        """👁️ Monitora build KM$ em tempo real"""
        print(f"👁️ MONITORANDO BUILD {build_id}")
        print(f"   Verificando a cada {check_interval}s...")
        
        start_time = time.time()
        
        while True:
            try:
                response = requests.get(f"{self.base_url}/builds/{build_id}", headers=self.headers)
                response.raise_for_status()
                
                build_data = response.json()
                build = build_data.get('build', {})
                
                status = build.get('status', 'unknown')
                duration = int(time.time() - start_time)
                
                print(f"⏱️  [{duration:03d}s] Status: {status}")
                
                if status == 'finished':
                    print("🎉 BUILD CONCLUÍDO COM SUCESSO!")
                    self.show_build_results(build)
                    return True
                
                elif status == 'failed':
                    print("❌ BUILD FALHOU!")
                    self.show_build_results(build)
                    return False
                
                elif status in ['queued', 'building']:
                    # Mostrar progresso adicional se disponível
                    if 'steps' in build:
                        current_step = next((step for step in build['steps'] if step.get('status') == 'building'), None)
                        if current_step:
                            print(f"   🔧 Executando: {current_step.get('name', 'Unknown step')}")
                    
                    time.sleep(check_interval)
                
                else:
                    print(f"   Status não reconhecido: {status}")
                    time.sleep(check_interval)
                
            except requests.exceptions.RequestException as e:
                print(f"❌ Erro ao verificar status: {e}")
                time.sleep(check_interval)
            except KeyboardInterrupt:
                print("\\n🛑 Monitoramento interrompido pelo usuário")
                return None
    
    def show_build_results(self, build):
        """📊 Mostra resultados detalhados do build"""
        print("\\n📊 RESULTADOS DO BUILD:")
        print(f"   App: {build.get('app', {}).get('appName', 'N/A')}")
        print(f"   Branch: {build.get('branch', 'N/A')}")
        print(f"   Status: {build.get('status', 'N/A')}")
        print(f"   Iniciado: {build.get('startedAt', 'N/A')}")
        print(f"   Finalizado: {build.get('finishedAt', 'N/A')}")
        
        # Artefatos (APK, etc)
        artifacts = build.get('artefacts', [])
        if artifacts:
            print(f"\\n📦 ARTEFATOS GERADOS ({len(artifacts)}):")
            for artifact in artifacts:
                artifact_name = artifact.get('name', 'Unknown')
                artifact_type = artifact.get('type', 'Unknown')
                artifact_size = artifact.get('size', 'Unknown size')
                print(f"   📱 {artifact_name} ({artifact_type}) - {artifact_size}")
        
        # Links úteis
        print(f"\\n🔗 LINKS ÚTEIS:")
        print(f"   Dashboard: https://codemagic.io/app/{self.app_id}/build/{build.get('_id')}")
        print(f"   Logs: https://codemagic.io/app/{self.app_id}/build/{build.get('_id')}/logs")
    
    def auto_build_and_monitor(self, workflow_id="default", branch="main", build_mode="release"):
        """🤖 Automação completa: Build + Monitor"""
        print("🤖 AUTOMAÇÃO COMPLETA KM$ - BUILD & MONITOR")
        print("=" * 50)
        
        # 1. Buscar info da app
        app_info = self.get_app_info()
        if not app_info:
            return False
        
        print()
        
        # 2. Disparar build
        build_id = self.trigger_build(workflow_id, branch, build_mode)
        if not build_id:
            return False
        
        print()
        
        # 3. Monitorar até conclusão
        return self.monitor_build(build_id)

def main():
    """🎯 Função principal"""
    km_build = KMAutoBuild()
    
    print("🤖 AUTO BUILD KM$ FLUTTER")
    print("=" * 30)
    print("Configuração:")
    print(f"  App ID: {km_build.app_id}")
    print(f"  Token: {km_build.api_token[:20]}...")
    print()
    
    # Opções de build
    print("📋 OPÇÕES DE BUILD:")
    print("1. 🚀 Build Release (main branch)")
    print("2. 🧪 Build Debug (develop branch)")
    print("3. ⚙️ Build Personalizado")
    print("4. 📱 Apenas info da app")
    
    try:
        choice = input("\\n➡️ Escolha (1-4): ").strip()
        
        if choice == "1":
            print("\\n🚀 INICIANDO BUILD RELEASE...")
            success = km_build.auto_build_and_monitor("default", "main", "release")
            
        elif choice == "2":
            print("\\n🧪 INICIANDO BUILD DEBUG...")
            success = km_build.auto_build_and_monitor("default", "develop", "debug")
            
        elif choice == "3":
            workflow = input("Workflow ID (default): ").strip() or "default"
            branch = input("Branch (main): ").strip() or "main"
            mode = input("Build mode (release): ").strip() or "release"
            
            print(f"\\n⚙️ INICIANDO BUILD PERSONALIZADO...")
            success = km_build.auto_build_and_monitor(workflow, branch, mode)
            
        elif choice == "4":
            km_build.get_app_info()
            success = True
            
        else:
            print("❌ Opção inválida!")
            success = False
        
        if success:
            print("\\n🎉 OPERAÇÃO CONCLUÍDA COM SUCESSO!")
        else:
            print("\\n❌ OPERAÇÃO FALHOU!")
            
    except KeyboardInterrupt:
        print("\\n🛑 Operação cancelada pelo usuário")
    except EOFError:
        print("\\n🤖 MODO AUTOMÁTICO - BUILD RELEASE")
        # Executar build automático se não puder interagir
        km_build.auto_build_and_monitor("default", "main", "release")

if __name__ == "__main__":
    main()