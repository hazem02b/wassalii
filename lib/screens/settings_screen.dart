import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../services/language_service.dart';
import '../utils/app_localizations.dart';
import '../widgets/restart_widget.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentLanguage = 'fr';
  String _currentLanguageName = 'Français';

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final name = await languageProvider.getCurrentLanguageName();
    setState(() {
      _currentLanguage = languageProvider.locale.languageCode;
      _currentLanguageName = name;
    });
  }

  Future<void> _showLanguageDialog() async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LanguageService.supportedLanguages.map((lang) {
            final isSelected = lang['code'] == _currentLanguage;
            return ListTile(
              leading: Text(
                lang['flag']!,
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(lang['name']!),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Color(0xFF2196F3))
                  : null,
              selected: isSelected,
              onTap: () => Navigator.pop(context, lang['code']),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );

    if (selected != null && selected != _currentLanguage) {
      // Synchroniser les deux providers
      await languageProvider.setLanguage(selected);
      await settingsProvider.setLocale(selected);
      await _loadCurrentLanguage();
      
      if (mounted) {
        // Redémarrer l'application pour appliquer la nouvelle langue
        RestartWidget.restartApp(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Langue changée: $_currentLanguageName'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
      
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isTransporter = authProvider.currentUser?.userType.toString().contains('transporter') ?? false;
    final primaryColor = isTransporter ? const Color(0xFFFF9800) : const Color(0xFF2196F3);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        title: Text(
          AppLocalizations.of(context).settings,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section Langue
          _buildSection(
            title: AppLocalizations.of(context).language,
            primaryColor: primaryColor,
            children: [
              _buildSettingTile(
                icon: Icons.language,
                title: AppLocalizations.of(context).appLanguage,
                subtitle: _currentLanguageName,
                primaryColor: primaryColor,
                onTap: _showLanguageDialog,
              ),
            ],
          ),

          // Section Apparence
          _buildSection(
            title: AppLocalizations.of(context).appearance,
            primaryColor: primaryColor,
            children: [
              Consumer<SettingsProvider>(
                builder: (context, settingsProvider, _) {
                  return _buildSwitchTile(
                    icon: Icons.dark_mode,
                    title: AppLocalizations.of(context).darkMode,
                    subtitle: AppLocalizations.of(context).enableDarkMode,
                    primaryColor: primaryColor,
                    value: settingsProvider.isDarkMode,
                    onChanged: (value) {
                      settingsProvider.toggleTheme();
                    },
                  );
                },
              ),
            ],
          ),

          // Section Compte
          _buildSection(
            title: AppLocalizations.of(context).account,
            primaryColor: primaryColor,
            children: [
              _buildSettingTile(
                icon: Icons.person,
                title: AppLocalizations.of(context).profile,
                subtitle: AppLocalizations.of(context).editInformation,
                primaryColor: primaryColor,
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              const Divider(height: 1, indent: 72),
              _buildSettingTile(
                icon: Icons.lock,
                title: AppLocalizations.of(context).changePassword,
                subtitle: AppLocalizations.of(context).accountSecurity,
                primaryColor: primaryColor,
                onTap: () {
                  Navigator.pushNamed(context, '/change-password');
                },
              ),
            ],
          ),

          // Section Aide
          _buildSection(
            title: AppLocalizations.of(context).helpSupport,
            primaryColor: primaryColor,
            children: [
              _buildSettingTile(
                icon: Icons.help_outline,
                title: AppLocalizations.of(context).helpCenter,
                subtitle: AppLocalizations.of(context).faqGuides,
                primaryColor: primaryColor,
                onTap: () {
                  Navigator.pushNamed(context, '/help');
                },
              ),
              const Divider(height: 1, indent: 72),
              _buildSettingTile(
                icon: Icons.info_outline,
                title: AppLocalizations.of(context).about,
                subtitle: 'Version 1.0.0',
                primaryColor: primaryColor,
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Wassali',
                    applicationVersion: '1.0.0',
                    applicationIcon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    children: const [
                      Text('Application de livraison de colis entre la Tunisie et la France.'),
                    ],
                  );
                },
              ),
            ],
          ),

          // Section Déconnexion
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
              ),
              title: Text(
                AppLocalizations.of(context).disconnect,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.red),
              onTap: _handleLogout,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Color primaryColor,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: primaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color primaryColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: primaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: primaryColor,
      ),
    );
  }
}
