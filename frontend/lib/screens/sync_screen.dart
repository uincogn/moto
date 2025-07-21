import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sync_service.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await ApiService.isLoggedIn();
    final userData = await ApiService.getUserData();
    
    setState(() {
      _isLoggedIn = isLoggedIn;
      _userData = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronização'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ChangeNotifierProvider.value(
        value: SyncService.instance,
        child: Consumer<SyncService>(
          builder: (context, syncService, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status de Login
                  _buildLoginStatusCard(),
                  
                  const SizedBox(height: 16),
                  
                  // Status de Sincronização
                  if (_isLoggedIn) ...[
                    _buildSyncStatusCard(syncService),
                    
                    const SizedBox(height: 16),
                    
                    // Botões de Ação
                    _buildActionButtons(syncService),
                    
                    const SizedBox(height: 24),
                    
                    // Informações de Sincronização
                    _buildSyncInfoCard(syncService),
                  ] else ...[
                    _buildLoginPromptCard(),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isLoggedIn ? Colors.green : Colors.grey,
              ),
              child: Icon(
                _isLoggedIn ? Icons.cloud_done : Icons.cloud_off,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isLoggedIn ? 'Conectado à Nuvem' : 'Modo Offline',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _isLoggedIn 
                      ? 'Email: ${_userData?['email'] ?? 'N/A'}'
                      : 'Faça login para sincronizar seus dados',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoggedIn)
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _handleLogout,
                tooltip: 'Sair',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusCard(SyncService syncService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  syncService.isSyncing ? Icons.sync : Icons.sync_disabled,
                  color: syncService.isSyncing ? AppTheme.primaryColor : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  'Status da Sincronização',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Text(
              syncService.syncStatus,
              style: TextStyle(
                fontSize: 16,
                color: syncService.isSyncing ? AppTheme.primaryColor : Colors.grey[600],
              ),
            ),
            
            if (syncService.isSyncing) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: syncService.syncProgress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                '${(syncService.syncProgress * 100).toInt()}% concluído',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
            
            if (syncService.lastSyncTime != null) ...[
              const SizedBox(height: 12),
              Text(
                'Última sincronização: ${_formatDateTime(syncService.lastSyncTime!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(SyncService syncService) {
    return Column(
      children: [
        // Sincronização Completa
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: syncService.isSyncing ? null : () => _performSync(syncService.fullSync),
            icon: const Icon(Icons.sync),
            label: const Text('Sincronização Completa'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Botões de Upload/Download
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: syncService.isSyncing ? null : () => _performSync(syncService.uploadOnly),
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Enviar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: syncService.isSyncing ? null : () => _performSync(syncService.downloadOnly),
                icon: const Icon(Icons.cloud_download),
                label: const Text('Baixar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSyncInfoCard(SyncService syncService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Como funciona a sincronização',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            const _InfoItem(
              icon: Icons.sync,
              title: 'Sincronização Completa',
              description: 'Envia seus dados locais e baixa dados do servidor. Recomendado para manter tudo atualizado.',
            ),
            
            const _InfoItem(
              icon: Icons.cloud_upload,
              title: 'Apenas Enviar',
              description: 'Envia apenas seus dados locais para o servidor. Use quando quiser fazer backup.',
            ),
            
            const _InfoItem(
              icon: Icons.cloud_download,
              title: 'Apenas Baixar',
              description: 'Baixa apenas dados do servidor. Use em um novo dispositivo para recuperar dados.',
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Estratégia de Conflitos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Em caso de conflito, o dado mais recente sempre prevalece (last-write-wins). '
                    'Certifique-se de sincronizar regularmente para evitar perda de dados.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPromptCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Faça login para sincronizar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Para sincronizar seus dados entre dispositivos, você precisa estar logado em uma conta Premium.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              icon: const Icon(Icons.login),
              label: const Text('Fazer Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performSync(Future<SyncResult> Function() syncFunction) async {
    try {
      final result = await syncFunction();
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair? Você ainda poderá usar o app offline.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await ApiService.logout();
      await _checkLoginStatus();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout realizado com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withAlpha(51),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}