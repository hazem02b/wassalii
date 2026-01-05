import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../utils/theme_extension.dart';
import '../utils/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

class TransporterProfileScreen extends StatefulWidget {
  final String? transporterId;
  
  const TransporterProfileScreen({super.key, this.transporterId});

  @override
  State<TransporterProfileScreen> createState() => _TransporterProfileScreenState();
}

class _TransporterProfileScreenState extends State<TransporterProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  Uint8List? _profileImageBytes;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final endpoint = widget.transporterId != null
          ? '/transporters/${widget.transporterId}'
          : '/users/me';
      final response = await ApiService().get(endpoint);
      setState(() {
        _profile = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() => _isUploadingImage = true);

      // Lire les bytes de l'image
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Uploader au serveur avec le bon endpoint
      await ApiService().put('/users/me/profile-picture', data: {
        'profile_picture': base64Image,
      });

      // Mettre à jour l'UI
      setState(() {
        _profileImageBytes = bytes;
        if (_profile != null) {
          _profile!['profile_picture'] = base64Image;
        }
        _isUploadingImage = false;
      });

      // Recharger le profil depuis le serveur pour être sûr
      await _loadProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo de profil mise à jour avec succès'),
            backgroundColor: Color(0xFFFF9800),
          ),
        );
      }
    } catch (e) {
      setState(() => _isUploadingImage = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'upload: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFF9800)),
        ),
      );
    }

    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).profile),
          backgroundColor: const Color(0xFFFF9800),
          foregroundColor: Colors.white,
        ),
        body: Center(child: Text(AppLocalizations.of(context).profileNotFound)),
      );
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isOwnProfile = widget.transporterId == null || 
                        widget.transporterId == authProvider.currentUser?.id.toString();

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.surfaceColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context).transporterProfile,
          style: TextStyle(color: context.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header orange avec info utilisateur
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFFF9800),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImageBytes != null
                            ? MemoryImage(_profileImageBytes!)
                            : _profile?['profile_picture'] != null
                                ? MemoryImage(base64Decode(_profile!['profile_picture']))
                                : null,
                        child: _profileImageBytes == null && _profile?['profile_picture'] == null
                            ? const Icon(Icons.person, size: 60, color: Color(0xFFFF9800))
                            : null,
                      ),
                      if (isOwnProfile)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _isUploadingImage ? null : _pickAndUploadProfileImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9800),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: _isUploadingImage
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _profile!['first_name'] ?? 'oussema bellili',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _profile!['email'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(AppLocalizations.of(context).activeTrips, '0'),
                      _buildStatItem(AppLocalizations.of(context).totalRevenue, '0€'),
                      _buildStatItem(AppLocalizations.of(context).rating, '0'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Informations Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).information,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Email
                  _buildInfoItem(
                    Icons.email,
                    AppLocalizations.of(context).email,
                    _profile!['email'] ?? 'transporteur@wassali.com',
                    const Color(0xFFFF9800),
                  ),
                  const SizedBox(height: 12),

                  // Téléphone
                  _buildInfoItem(
                    Icons.phone,
                    AppLocalizations.of(context).phone,
                    _profile!['phone'] ?? '+216 98 765 432',
                    const Color(0xFFFF9800),
                  ),

                  const SizedBox(height: 24),

                  // Bouton Modifier le profil
                  _buildMenuButton(
                    icon: Icons.edit,
                    label: AppLocalizations.of(context).modifyProfile,
                    onTap: () {
                      Navigator.pushNamed(context, '/edit-profile');
                    },
                  ),
                  const SizedBox(height: 12),

                  // Bouton Paramètres
                  _buildMenuButton(
                    icon: Icons.settings,
                    label: AppLocalizations.of(context).settings,
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  const SizedBox(height: 12),

                  // Bouton Aide & Support
                  _buildMenuButton(
                    icon: Icons.help_outline,
                    label: AppLocalizations.of(context).helpAndSupport,
                    onTap: () {
                      // Navigator.pushNamed(context, '/support');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context).helpPageComing)),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Déconnexion
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        AppLocalizations.of(context).disconnect,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(AppLocalizations.of(context).logoutConfirmation),
                            content: Text(AppLocalizations.of(context).logoutMessage),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(AppLocalizations.of(context).cancel),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(AppLocalizations.of(context).disconnect, style: const TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true && mounted) {
                          await authProvider.logout();
                          if (mounted) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF9800),
        unselectedItemColor: context.textSecondary,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: AppLocalizations.of(context).dashboard),
          BottomNavigationBarItem(icon: const Icon(Icons.route), label: AppLocalizations.of(context).trips),
          BottomNavigationBarItem(icon: const Icon(Icons.add_circle), label: AppLocalizations.of(context).create),
          BottomNavigationBarItem(icon: const Icon(Icons.message), label: AppLocalizations.of(context).messages),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: AppLocalizations.of(context).profile),
        ],
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/transporter-dashboard');
          if (index == 1) Navigator.pushNamed(context, '/my-trips');
          if (index == 2) Navigator.pushNamed(context, '/create-trip');
          if (index == 3) Navigator.pushNamed(context, '/messages');
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.isDarkMode ? Colors.transparent : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: context.isDarkMode ? Colors.transparent : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: context.textSecondary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: context.textPrimary,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: context.textTertiary),
          ],
        ),
      ),
    );
  }
}
