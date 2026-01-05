import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/api_service.dart';
import '../utils/theme_extension.dart';

class TransporterHelpScreen extends StatefulWidget {
  const TransporterHelpScreen({super.key});

  @override
  State<TransporterHelpScreen> createState() => _TransporterHelpScreenState();
}

class _TransporterHelpScreenState extends State<TransporterHelpScreen> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    if (_subjectController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService().post('/support/tickets', data: {
        'subject': _subjectController.text,
        'message': _messageController.text,
        'user_type': 'transporter',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Votre demande a été envoyée avec succès'),
            backgroundColor: AppColors.success,
          ),
        );
        _subjectController.clear();
        _messageController.clear();
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.orange.withAlpha((0.7 * 255).round())],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Aide Transporteur',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Icon(Icons.local_shipping, size: 60, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    'Espace Transporteur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toutes les ressources pour réussir',
                    style: TextStyle(color: Colors.white.withAlpha((0.9 * 255).round())),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Guide du transporteur',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _GuideCard(
                    icon: Icons.add_road,
                    title: 'Créer un trajet',
                    description: 'Apprenez à publier vos trajets disponibles',
                  ),
                  _GuideCard(
                    icon: Icons.people,
                    title: 'Gérer les réservations',
                    description: 'Accepter et gérer les demandes de transport',
                  ),
                  _GuideCard(
                    icon: Icons.payments,
                    title: 'Recevoir les paiements',
                    description: 'Configurer vos informations bancaires',
                  ),
                  _GuideCard(
                    icon: Icons.verified_user,
                    title: 'Vérification du compte',
                    description: 'Processus de vérification et badges',
                  ),
                  
                  const SizedBox(height: 32),
                  
                  const Text(
                    'Questions fréquentes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _FAQCard(
                    question: 'Comment fixer mes tarifs ?',
                    answer: 'Vous êtes libre de fixer vos tarifs en fonction '
                        'de la distance, du poids et de l\'urgence.',
                  ),
                  _FAQCard(
                    question: 'Quand suis-je payé ?',
                    answer: 'Le paiement est effectué 24h après la confirmation '
                        'de livraison par le client.',
                  ),
                  _FAQCard(
                    question: 'Puis-je annuler un trajet ?',
                    answer: 'Oui, mais des frais peuvent s\'appliquer si des '
                        'réservations ont déjà été confirmées.',
                  ),
                  _FAQCard(
                    question: 'Comment obtenir le badge vérifié ?',
                    answer: 'Complétez 10 livraisons avec succès et maintenez '
                        'une note moyenne de 4.5 étoiles.',
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withAlpha((0.1 * 255).round()),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withAlpha((0.3 * 255).round())),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.tips_and_updates, color: Colors.blue, size: 40),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Conseil du jour',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Maintenez une bonne communication avec vos '
                                'clients pour obtenir de meilleures notes.',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  const Text(
                    'Besoin d\'aide supplémentaire ?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.04 * 255).round()),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _subjectController,
                          decoration: InputDecoration(
                            labelText: 'Sujet',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: context.surfaceColor,
                            prefixIcon: const Icon(Icons.subject, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: context.surfaceColor,
                            prefixIcon: const Icon(Icons.message, color: AppColors.primary),
                          ),
                          maxLines: 5,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitTicket,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              disabledBackgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Envoyer',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  _ContactCard(
                    icon: Icons.phone,
                    title: 'Support transporteur',
                    subtitle: '+33 1 23 45 67 90',
                    onTap: () {},
                  ),
                  _ContactCard(
                    icon: Icons.email,
                    title: 'Email dédié',
                    subtitle: 'transporteurs@wassali.com',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  
  const _GuideCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.orange),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

class _FAQCard extends StatefulWidget {
  final String question;
  final String answer;
  
  const _FAQCard({
    required this.question,
    required this.answer,
  });

  @override
  State<_FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<_FAQCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 12),
                Text(
                  widget.answer,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.orange),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
    );
  }
}
