import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../../widgets/shared_login_widgets.dart';
import '../alumni_dashboard/alumni_dashboard_screen.dart';

/// Alumni login screen with username/password fields and demo credentials.
///
/// Demo credentials → username: alumni  |  password: alumni123
class AlumniLoginScreen extends StatefulWidget {
  const AlumniLoginScreen({super.key});

  @override
  State<AlumniLoginScreen> createState() => _AlumniLoginScreenState();
}

class _AlumniLoginScreenState extends State<AlumniLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _fillDemoCredentials() {
    setState(() {
      _identifierCtrl.text = 'alumni';
      _passwordCtrl.text = 'alumni123';
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Brief processing delay for smooth feedback
    await Future.delayed(const Duration(milliseconds: 250));

    final error = context.read<AuthProvider>().loginAsAlumni(
          _identifierCtrl.text,
          _passwordCtrl.text,
        );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  error,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Login successful! Welcome to your Alumni Dashboard.',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.accent,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AlumniDashboardScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Alumni Login',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final r = Responsive(constraints.maxWidth);

          // Tablet / Desktop — centred card.
          if (!r.isMobile) {
            return SharedDesktopLoginBody(
              accentColor: AppColors.accent,
              icon: Icons.workspace_premium_rounded,
              welcomeTitle: 'Welcome, Alumni',
              welcomeSub: 'Sign in to view your alumni profile',
              formKey: _formKey,
              identifierCtrl: _identifierCtrl,
              passwordCtrl: _passwordCtrl,
              obscurePassword: _obscurePassword,
              isLoading: _isLoading,
              onToggleObscure: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              onSubmit: _submit,
              demoUser: 'alumni',
              demoPass: 'alumni123',
              onQuickFill: _fillDemoCredentials,
            );
          }

          // Mobile layout.
          return SingleChildScrollView(
            child: Column(
              children: [
                // ── Coloured header ──────────────────────────────────────────
                Container(
                  width: double.infinity,
                  color: AppColors.accent,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.workspace_premium_rounded,
                            color: Colors.white, size: 38),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Welcome, Alumni',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sign in to view your alumni profile',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // ── Form ─────────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SharedLoginForm(
                    formKey: _formKey,
                    identifierCtrl: _identifierCtrl,
                    passwordCtrl: _passwordCtrl,
                    obscurePassword: _obscurePassword,
                    isLoading: _isLoading,
                    accentColor: AppColors.accent,
                    onToggleObscure: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    onSubmit: _submit,
                    demoUser: 'alumni',
                    demoPass: 'alumni123',
                    onQuickFill: _fillDemoCredentials,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
