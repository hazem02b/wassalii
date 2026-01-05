import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../services/storage_service.dart';
import '../utils/theme_extension.dart';
import '../utils/app_localizations.dart';

/// Page d'accueil client - Design moderne identique à la version web
class HomeClientScreen extends StatefulWidget {
  const HomeClientScreen({super.key});

  @override
  State<HomeClientScreen> createState() => _HomeClientScreenState();
}

class _HomeClientScreenState extends State<HomeClientScreen> {
  int _selectedIndex = 0;
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final StorageService _storageService = StorageService();
  List<Map<String, String>> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _refreshUserProfile();
  }

  void _loadRecentSearches() {
    setState(() {
      _recentSearches = _storageService.getRecentSearches();
      // Si aucune recherche n'est sauvegardée, charger simplement une liste vide
      // Les recherches seront ajoutées quand l'utilisateur effectuera des recherches
    });
  }
  
  Future<void> _refreshUserProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.refreshCurrentUser();
    } catch (e) {
      // Ignorer les erreurs silencieusement
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      return;
    }

    // Sauvegarder la recherche
    await _storageService.addRecentSearch(
      _fromController.text,
      _toController.text,
    );
    
    // Recharger les recherches depuis le stockage
    _loadRecentSearches();

    Navigator.pushNamed(
      context,
      '/search',
      arguments: {
        'from': _fromController.text,
        'to': _toController.text,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final userName = user?.firstName ?? user?.email?.split('@')[0] ?? 'Utilisateur';

    final List<Widget> pages = [
      _buildHomePage(userName),
      const Center(child: Text('Bookings')),
      const Center(child: Text('Messages')),
      const Center(child: Text('Profile')),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, AppLocalizations.of(context).home, 0),
                _buildNavItem(Icons.search, AppLocalizations.of(context).search, 1),
                _buildNavItem(Icons.list_alt, AppLocalizations.of(context).bookings, 2),
                _buildNavItem(Icons.message, AppLocalizations.of(context).messages, 3),
                _buildNavItem(Icons.person, AppLocalizations.of(context).profile, 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () async {
        if (index == 0) {
          setState(() {
            _selectedIndex = 0;
          });
        } else if (index == 1) {
          Navigator.pushNamed(context, '/search');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/my-bookings');
        } else if (index == 3) {
          Navigator.pushNamed(context, '/messages');
        } else if (index == 4) {
          await Navigator.pushNamed(context, '/profile');
          // Recharger le profil et les recherches au retour
          _refreshUserProfile();
          _loadRecentSearches();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF0066FF) : const Color(0xFF9CA3AF),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF0066FF) : const Color(0xFF9CA3AF),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage(String userName) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header avec gradient bleu
            Container(
              decoration: BoxDecoration(
                gradient: context.isDarkMode
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF1E1E1E), Color(0xFF2D2D2D)],
                      )
                    : const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
                      ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Salutation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AppLocalizations.of(context).hello}, $userName!',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: context.isDarkMode ? Colors.white : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(context).whereToSend,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: context.isDarkMode ? Colors.white70 : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          // Avatar
                          GestureDetector(
                            onTap: () async {
                              await Navigator.pushNamed(context, '/profile');
                              _refreshUserProfile();
                            },
                            child: Container(
                              key: ValueKey(user?.avatar?.hashCode ?? 0),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: user?.avatar != null && user!.avatar!.isNotEmpty
                                    ? Image.memory(
                                        base64Decode(user.avatar!),
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 24,
                                          );
                                        },
                                      )
                                    : const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Formulaire de recherche
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Champ De
                            _buildSearchField(
                              controller: _fromController,
                              hint: AppLocalizations.of(context).from,
                              icon: Icons.location_on_outlined,
                            ),
                            const SizedBox(height: 16),
                            
                            // Champ À
                            _buildSearchField(
                              controller: _toController,
                              hint: AppLocalizations.of(context).to,
                              icon: Icons.location_on_outlined,
                            ),
                            const SizedBox(height: 16),
                            
                            // Boutons Date, Poids, Prix
                            Row(
                              children: [
                                _buildOptionChip('Date', Icons.calendar_today),
                                const SizedBox(width: 12),
                                _buildOptionChip('Poids', Icons.scale_outlined),
                                const SizedBox(width: 12),
                                _buildOptionChip('Prix', Icons.attach_money),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Bouton de recherche
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _handleSearch,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0066FF),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context).searchTransporters,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Section Recherches récentes
            if (_recentSearches.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recherches récentes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Liste des recherches récentes
                    ...(_recentSearches.map((search) => _buildRecentSearchCard(
                      from: search['from']!,
                      to: search['to']!,
                    ))),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF0066FF)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionChip(String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF0066FF)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0066FF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearchCard({
    required String from,
    required String to,
  }) {
    return GestureDetector(
      onTap: () {
        // Remplir les champs avec la recherche récente
        _fromController.text = from;
        _toController.text = to;
        
        // Naviguer vers la recherche
        Navigator.pushNamed(
          context,
          '/search',
          arguments: {
            'from': from,
            'to': to,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.location_on_outlined,
                color: context.isDarkMode ? Colors.white : const Color(0xFF0066FF),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$from → $to',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).today,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: context.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
