// Clean wrapper: forward to the clean implementation to avoid duplicated/corrupted code.
import 'package:flutter/material.dart';
import 'signup_transporter_screen_clean.dart';

class SignupTransporterScreen extends StatelessWidget {
  const SignupTransporterScreen({super.key});

  @override
  Widget build(BuildContext context) => const SignupTransporterScreenClean();
}
