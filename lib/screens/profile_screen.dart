import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/user_service.dart';
import '../constants/app_colors.dart';
import 'login_screen.dart';
import '../utils/theme_extension.dart';
import '../utils/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

/// Page de profil client - Design moderne identique à la version web
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isEditing = false;
  bool _isUploadingImage = false;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  String? _successMessage;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _userStats;
  Uint8List? _profileImageBytes;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
    _loadUserStats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    
    try {
      final data = await _userService.getCurrentUser();
      if (!mounted) return;
      
      setState(() {
        _userData = data;
        _nameController.text = data['name'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _addressController.text = data['address'] ?? '';
        _emailController.text = data['email'] ?? '';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erreur de chargement: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadUserStats() async {
    try {
      final stats = await _userService.getUserStats();
      if (!mounted) return;
      
      setState(() {
        _userStats = stats;
      });
    } catch (e) {
      // Silently fail - stats are optional
    }
  }

  Future<void> _handleUpdateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await _userService.updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _successMessage = 'Profil mis à jour avec succès';
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil mis à jour avec succès'),
          backgroundColor: AppColors.success,
        ),
      );

      // Recharger les données
      await _loadUserData();
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleChangePassword() async {
    if (_oldPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer votre ancien mot de passe'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).pleaseEnterNewPassword),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Les mots de passe ne correspondent pas'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le mot de passe doit contenir au moins 6 caractères'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _userService.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (!mounted) return;

      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mot de passe modifié avec succès'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      String errorMessage = 'Erreur lors du changement de mot de passe';
      
      // Extract error message from DioException
      if (e.toString().contains('Current password is incorrect')) {
        errorMessage = 'L\'ancien mot de passe est incorrect';
      } else if (e.toString().contains('400')) {
        errorMessage = 'L\'ancien mot de passe est incorrect';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Session expirée. Veuillez vous reconnecter';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Erreur serveur. Veuillez réessayer';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() => _isUploadingImage = true);

      final bytes = await image.readAsBytes();
      
      setState(() {
        _profileImageBytes = bytes;
      });

      // Upload l'image au serveur
      await _uploadProfileImage(bytes);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection de l\'image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _uploadProfileImage(Uint8List imageBytes) async {
    try {
      final base64Image = base64Encode(imageBytes);
      
      final response = await _userService.updateProfilePicture(base64Image);
      
      if (response['success'] == true) {
        // Mettre à jour l'AuthProvider pour que l'avatar se mette à jour partout dans l'app
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.refreshCurrentUser();
        
        // Recharger le profil depuis le serveur
        await _loadUserData();
        
        if (mounted) {
          setState(() {
            _isUploadingImage = false;
            // Réinitialiser pour afficher l'image depuis le serveur
            _profileImageBytes = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo de profil mise à jour avec succès'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        throw Exception(response['message'] ?? 'Erreur lors de la mise à jour');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).cancel),
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
    final bool isClient = _userData?['role'] == 'client';
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _isLoading && _userData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Header avec gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: Theme.of(context).brightness == Brightness.dark
                          ? LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF1E1E1E), Color(0xFF2D2D2D)],
                            )
                          : const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
                            ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        children: [
                          // App bar
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                Text(
                                  AppLocalizations.of(context).myProfile,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.logout, color: Colors.white),
                                  onPressed: _handleLogout,
                                ),
                              ],
                            ),
                          ),
                          
                          // Avatar
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  key: ValueKey(_userData?['profile_picture']?.hashCode ?? DateTime.now().millisecondsSinceEpoch),
                                  radius: 50,
                                  backgroundColor: const Color(0xFF0066FF),
                                  backgroundImage: _profileImageBytes != null
                                      ? MemoryImage(_profileImageBytes!)
                                      : _userData?['profile_picture'] != null
                                          ? MemoryImage(base64Decode(_userData!['profile_picture']))
                                          : null,
                                  child: _profileImageBytes == null && _userData?['profile_picture'] == null
                                      ? Text(
                                          (_userData?['name'] ?? 'U')[0].toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 40,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _isUploadingImage ? null : _pickProfileImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: _isUploadingImage
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066FF)),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.camera_alt,
                                            size: 20,
                                            color: Color(0xFF0066FF),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Nom et email
                          Text(
                            _userData?['name'] ?? 'Utilisateur',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _userData?['email'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Badge rôle
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isClient ? 'Client' : 'Transporteur',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Tabs
                          TabBar(
                            indicatorColor: Colors.white,
                            indicatorWeight: 3,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white70,
                            labelStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            tabs: [
                              Tab(text: AppLocalizations.of(context).informationTab),
                              Tab(text: AppLocalizations.of(context).statisticsTab),
                              Tab(text: AppLocalizations.of(context).securityTab),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // TabBarView
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab 1: Informations
                        _buildInfoTab(),
                        
                        // Tab 2: Statistiques
                        _buildStatsTab(isClient),
                        
                        // Tab 3: Sécurité
                        _buildSecurityTab(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email (non-editable)
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.email, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 12),
                  Text(
                    _userData?['email'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Nom
            Text(
              AppLocalizations.of(context).fullName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _nameController,
              icon: Icons.person,
              enabled: _isEditing,
              hint: AppLocalizations.of(context).yourFullName,
            ),
            const SizedBox(height: 24),

            // Téléphone
            Text(
              AppLocalizations.of(context).phone,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _phoneController,
              icon: Icons.phone,
              enabled: _isEditing,
              hint: AppLocalizations.of(context).yourPhoneNumber,
            ),
            const SizedBox(height: 24),

            // Adresse
            Text(
              AppLocalizations.of(context).address,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _addressController,
              icon: Icons.location_on,
              enabled: _isEditing,
              maxLines: 2,
              hint: AppLocalizations.of(context).yourFullAddress,
            ),
            const SizedBox(height: 32),

            // Boutons d'action
            if (_isEditing)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleUpdateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text(
                              'Enregistrer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        _loadUserData();
                        setState(() => _isEditing = false);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context).cancel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: const Icon(Icons.edit),
                  label: Text(
                    AppLocalizations.of(context).editProfileButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
            const SizedBox(height: 24),
            
            // Menu items
            if (!_isEditing) ...[
              _buildMenuButton(
                icon: Icons.list_alt,
                title: 'Mes réservations',
                onTap: () => Navigator.pushNamed(context, '/my-bookings'),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                icon: Icons.settings,
                title: 'Paramètres',
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                icon: Icons.help_outline,
                title: 'Aide et support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fonctionnalité à venir')),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsTab(bool isClient) {
    return RefreshIndicator(
      onRefresh: _loadUserStats,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: _userStats == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).loadingStatistics,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).myStatistics,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).activityOverview,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  if (isClient) ...[
                    // Client stats
                    _buildStatCard(
                      icon: Icons.shopping_bag,
                      title: AppLocalizations.of(context).totalReservations,
                      value: '${_userStats!['total_bookings'] ?? 0}',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      icon: Icons.access_time,
                      title: AppLocalizations.of(context).activeReservations,
                      value: '${_userStats!['active_bookings'] ?? 0}',
                      color: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      icon: Icons.check_circle,
                      title: AppLocalizations.of(context).completedReservations,
                      value: '${_userStats!['completed_bookings'] ?? 0}',
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      icon: Icons.attach_money,
                      title: AppLocalizations.of(context).totalSpent,
                      value: '${(_userStats!['total_spent'] ?? 0).toStringAsFixed(2)} DH',
                      color: const Color(0xFF8B5CF6),
                    ),
                  ] else ...[
                    // Transporter stats
                    _buildStatCard(
                      icon: Icons.local_shipping,
                      title: AppLocalizations.of(context).totalTrips,
                      value: '${_userStats!['total_trips'] ?? 0}',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      icon: Icons.attach_money,
                      title: AppLocalizations.of(context).totalRevenue,
                      value: '${(_userStats!['total_revenue'] ?? 0).toStringAsFixed(2)} DH',
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      icon: Icons.trending_up,
                      title: AppLocalizations.of(context).activeTripsStats,
                      value: '${_userStats!['active_trips'] ?? 0}',
                      color: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      icon: Icons.people,
                      title: 'Clients Servis',
                      value: '${_userStats!['total_clients'] ?? 0}',
                      color: const Color(0xFF8B5CF6),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Changer le Mot de Passe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Assurez-vous que votre mot de passe contient au moins 6 caractères',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          // Ancien mot de passe
          const Text(
            'Ancien mot de passe',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          _buildPasswordField(
            controller: _oldPasswordController,
            obscure: _obscureOldPassword,
            onToggle: () => setState(() => _obscureOldPassword = !_obscureOldPassword),
            hint: 'Entrez votre ancien mot de passe',
          ),
          const SizedBox(height: 24),

          // Nouveau mot de passe
          const Text(
            'Nouveau mot de passe',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          _buildPasswordField(
            controller: _newPasswordController,
            obscure: _obscureNewPassword,
            onToggle: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
            hint: 'Entrez un nouveau mot de passe',
          ),
          const SizedBox(height: 24),

          // Confirmer le mot de passe
          const Text(
            'Confirmer le mot de passe',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          _buildPasswordField(
            controller: _confirmPasswordController,
            obscure: _obscureConfirmPassword,
            onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            hint: 'Confirmez votre nouveau mot de passe',
          ),
          const SizedBox(height: 32),

          // Bouton
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _handleChangePassword,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Icon(Icons.lock_reset),
              label: Text(
                _isLoading ? 'Modification en cours...' : 'Changer le mot de passe',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Info section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pour des raisons de sécurité, vous serez déconnecté après avoir changé votre mot de passe.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF9CA3AF),
            ),
            onPressed: onToggle,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    int maxLines = 1,
    String? hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? context.surfaceColor : context.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          prefixIcon: Icon(icon, color: enabled ? const Color(0xFF0066FF) : const Color(0xFF9CA3AF)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
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
          border: Border.all(color: context.borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF0066FF), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}
