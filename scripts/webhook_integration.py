#!/usr/bin/env python3
"""
🔗 WEBHOOK INTEGRATION - KM$ FLUTTER
====================================

Sistema de webhooks para integração automática entre:
- GitHub push events
- Codemagic builds
- Notificações personalizadas

Este script pode ser usado para:
✅ Receber webhooks do GitHub
✅ Disparar builds automáticos no Codemagic
✅ Enviar notificações (Slack, Discord, etc.)
✅ Filtrar branches e eventos específicos
"""

from flask import Flask, request, jsonify
import requests
import hmac
import hashlib
import json
from datetime import datetime

app = Flask(__name__)

# Configuração
CODEMAGIC_API_TOKEN = "XCUldLgleC4AoYk-stiZe0tMjul8_nei2WX2WdEbbsQ"
CODEMAGIC_BASE_URL = "https://api.codemagic.io"
GITHUB_WEBHOOK_SECRET = "your_github_webhook_secret"  # Configure no GitHub
SLACK_WEBHOOK_URL = "your_slack_webhook_url"  # Opcional

# Configuração do app KM$
KM_APP_CONFIG = {
    "app_id": "",  # Será preenchido automaticamente
    "workflow_release": "release",
    "workflow_debug": "debug", 
    "auto_build_branches": ["main", "develop", "release/*"],
    "notification_branches": ["main"]
}

def verify_github_signature(payload_body, signature_header):
    """🔐 Verifica assinatura do webhook GitHub"""
    if not signature_header or not GITHUB_WEBHOOK_SECRET:
        return False
    
    expected_signature = hmac.new(
        GITHUB_WEBHOOK_SECRET.encode(),
        payload_body,
        hashlib.sha1
    ).hexdigest()
    
    return hmac.compare_digest(
        f"sha1={expected_signature}",
        signature_header
    )

def trigger_codemagic_build(app_id, workflow_id, branch, commit_info=None):
    """🚀 Dispara build no Codemagic"""
    headers = {
        "Content-Type": "application/json",
        "x-auth-token": CODEMAGIC_API_TOKEN
    }
    
    env_vars = {
        "WEBHOOK_TRIGGERED": "true",
        "BUILD_TIMESTAMP": datetime.now().isoformat()
    }
    
    if commit_info:
        env_vars.update({
            "COMMIT_SHA": commit_info.get("sha", ""),
            "COMMIT_MESSAGE": commit_info.get("message", ""),
            "COMMIT_AUTHOR": commit_info.get("author", "")
        })
    
    payload = {
        "appId": app_id,
        "workflowId": workflow_id,
        "branch": branch,
        "environment": {
            "variables": env_vars
        }
    }
    
    try:
        response = requests.post(
            f"{CODEMAGIC_BASE_URL}/builds",
            headers=headers,
            json=payload
        )
        response.raise_for_status()
        
        result = response.json()
        build_id = result.get('build', {}).get('_id')
        
        return {
            "success": True,
            "build_id": build_id,
            "message": f"Build {build_id} disparado com sucesso"
        }
    
    except requests.exceptions.RequestException as e:
        return {
            "success": False,
            "error": str(e),
            "message": "Erro ao disparar build no Codemagic"
        }

def send_slack_notification(message, color="good"):
    """📢 Envia notificação para Slack"""
    if not SLACK_WEBHOOK_URL:
        return
    
    payload = {
        "attachments": [{
            "color": color,
            "text": message,
            "footer": "KM$ CI/CD Integration",
            "ts": int(datetime.now().timestamp())
        }]
    }
    
    try:
        requests.post(SLACK_WEBHOOK_URL, json=payload)
    except:
        pass  # Notificação falhou, mas não interrompe o processo

def should_trigger_build(branch, branches_config):
    """🎯 Verifica se deve disparar build para a branch"""
    for pattern in branches_config:
        if pattern.endswith("/*"):
            prefix = pattern[:-2]
            if branch.startswith(prefix):
                return True
        elif pattern == branch:
            return True
    return False

def get_workflow_for_branch(branch):
    """🔧 Determina workflow baseado na branch"""
    if branch in ["main", "master"] or branch.startswith("release/"):
        return KM_APP_CONFIG["workflow_release"]
    else:
        return KM_APP_CONFIG["workflow_debug"]

@app.route('/webhook/github', methods=['POST'])
def github_webhook():
    """📨 Endpoint para receber webhooks do GitHub"""
    
    # Verificar assinatura
    signature = request.headers.get('X-Hub-Signature')
    if not verify_github_signature(request.data, signature):
        return jsonify({"error": "Invalid signature"}), 401
    
    # Processar payload
    payload = request.json
    event_type = request.headers.get('X-GitHub-Event')
    
    print(f"📨 Webhook recebido: {event_type}")
    
    # Processar push events
    if event_type == 'push':
        branch = payload.get('ref', '').replace('refs/heads/', '')
        repository = payload.get('repository', {}).get('name', 'unknown')
        
        # Informações do commit
        commits = payload.get('commits', [])
        if commits:
            latest_commit = commits[-1]
            commit_info = {
                "sha": latest_commit.get('id', ''),
                "message": latest_commit.get('message', ''),
                "author": latest_commit.get('author', {}).get('name', '')
            }
        else:
            commit_info = None
        
        print(f"📍 Push para {repository}/{branch}")
        
        # Verificar se deve disparar build
        if should_trigger_build(branch, KM_APP_CONFIG["auto_build_branches"]):
            
            # Buscar app_id se não configurado
            if not KM_APP_CONFIG["app_id"]:
                headers = {
                    "Content-Type": "application/json",
                    "x-auth-token": CODEMAGIC_API_TOKEN
                }
                
                try:
                    response = requests.get(f"{CODEMAGIC_BASE_URL}/apps", headers=headers)
                    apps = response.json().get('applications', [])
                    if apps:
                        KM_APP_CONFIG["app_id"] = apps[0].get('_id')
                except:
                    return jsonify({"error": "Não foi possível encontrar app_id"}), 500
            
            # Determinar workflow
            workflow_id = get_workflow_for_branch(branch)
            
            # Disparar build
            result = trigger_codemagic_build(
                KM_APP_CONFIG["app_id"],
                workflow_id,
                branch,
                commit_info
            )
            
            if result["success"]:
                message = f"🚀 Build disparado para {repository}/{branch}\nBuild ID: {result['build_id']}"
                
                if branch in KM_APP_CONFIG["notification_branches"]:
                    send_slack_notification(message)
                
                return jsonify({
                    "message": "Build disparado com sucesso",
                    "build_id": result["build_id"],
                    "branch": branch,
                    "workflow": workflow_id
                })
            else:
                send_slack_notification(f"❌ Erro ao disparar build para {repository}/{branch}: {result['message']}", "danger")
                return jsonify({"error": result["message"]}), 500
        
        else:
            print(f"⏭️ Branch {branch} não configurada para build automático")
            return jsonify({"message": f"Branch {branch} ignorada"})
    
    # Outros eventos
    return jsonify({"message": f"Evento {event_type} processado"})

@app.route('/webhook/codemagic', methods=['POST'])
def codemagic_webhook():
    """📨 Endpoint para receber webhooks do Codemagic (build status)"""
    payload = request.json
    
    build_id = payload.get('build', {}).get('_id')
    status = payload.get('build', {}).get('status')
    app_name = payload.get('build', {}).get('app', {}).get('appName', 'KM$')
    branch = payload.get('build', {}).get('branch')
    
    print(f"📊 Build Update: {build_id} - {status}")
    
    # Notificar apenas builds principais
    if branch in KM_APP_CONFIG["notification_branches"]:
        if status == 'finished':
            message = f"✅ Build concluído com sucesso!\nApp: {app_name}\nBranch: {branch}\nBuild ID: {build_id}"
            send_slack_notification(message)
        
        elif status == 'failed':
            message = f"❌ Build falhou!\nApp: {app_name}\nBranch: {branch}\nBuild ID: {build_id}"
            send_slack_notification(message, "danger")
    
    return jsonify({"message": "Webhook processado"})

@app.route('/status', methods=['GET'])
def status():
    """📊 Status do webhook service"""
    return jsonify({
        "service": "KM$ Webhook Integration",
        "status": "running",
        "timestamp": datetime.now().isoformat(),
        "config": {
            "auto_build_branches": KM_APP_CONFIG["auto_build_branches"],
            "notification_branches": KM_APP_CONFIG["notification_branches"],
            "app_id_configured": bool(KM_APP_CONFIG["app_id"]),
            "slack_configured": bool(SLACK_WEBHOOK_URL)
        }
    })

if __name__ == '__main__':
    print("🔗 WEBHOOK INTEGRATION - KM$ FLUTTER")
    print("=" * 40)
    print("📍 Endpoints disponíveis:")
    print("  📨 POST /webhook/github - Recebe webhooks do GitHub")
    print("  📨 POST /webhook/codemagic - Recebe webhooks do Codemagic")  
    print("  📊 GET /status - Status do serviço")
    print()
    print("🚀 Iniciando servidor...")
    
    app.run(host='0.0.0.0', port=5001, debug=True)