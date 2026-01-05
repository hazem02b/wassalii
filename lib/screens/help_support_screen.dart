import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/api_service.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
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
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 100, 24, 32),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((0.2 * 255).round()),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.support_agent, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Comment pouvons-nous vous aider ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Notre équipe est là pour vous',
                    style: TextStyle(color: Colors.white.withAlpha((0.9 * 255).round()), fontSize: 15),
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
                    'Questions fréquentes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _FAQCard(
                    question: 'Comment réserver un transport ?',
                    answer: 'Recherchez un trajet, sélectionnez un transporteur, '
                        'puis confirmez votre réservation.',
                  ),
                  _FAQCard(
                    question: 'Comment suivre mon colis ?',
                    answer: 'Accédez à "Mes réservations" pour voir le statut '
                        'de votre colis en temps réel.',
                  ),
                  _FAQCard(
                    question: 'Quels moyens de paiement acceptez-vous ?',
                    answer: 'Nous acceptons les cartes bancaires, PayPal et '
                        'les paiements en espèces.',
                  ),
                  _FAQCard(
                    question: 'Que faire en cas de problème ?',
                    answer: 'Contactez notre support via le formulaire ci-dessous '
                        'ou appelez-nous directement.',
                  ),
                  
                  const SizedBox(height: 32),
                  
                  const Text(
                    'Contactez-nous',
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
                      color: Colors.white,
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
                            prefixIcon: const Icon(Icons.subject, color: AppColors.primary),
                            filled: true,
                            fillColor: AppColors.backgroundLight,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 80),
                              child: Icon(Icons.message, color: AppColors.primary),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundLight,
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
                              backgroundColor: AppColors.primary,
                              disabledBackgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
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
                  
                  Text(
                    'Autres moyens de contact',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  
                  _ContactCard(
                    icon: Icons.phone,
                    title: 'Téléphone',
                    subtitle: '+33 1 23 45 67 89',
                    onTap: () {},
                  ),
                  _ContactCard(
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: 'support@wassali.com',
                    onTap: () {},
                  ),
                  _ContactCard(
                    icon: Icons.schedule,
                    title: 'Horaires',
                    subtitle: 'Lun-Ven: 9h-18h',
                    onTap: null,
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
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
    );
  }
}
