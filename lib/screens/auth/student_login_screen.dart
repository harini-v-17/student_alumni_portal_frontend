import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../../widgets/shared_login_widgets.dart';
import '../student/student_dashboard.dart';

/// Student login screen with username/password fields and demo credentials.
///
/// Demo credentials → username: student  |  password: student123
class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final error = context.read<AuthProvider>().loginAsStudent(
          _identifierCtrl.text,
          _passwordCtrl.text,
        );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const StudentDashboard()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Student Login',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final r = Responsive(constraints.maxWidth);

          // Tablet / Desktop — centred card.
          if (!r.isMobile) {
            return SharedDesktopLoginBody(
              accentColor: AppColors.primary,
              icon: Icons.person_outline,
              welcomeTitle: 'Welcome, Student',
              welcomeSub: 'Sign in to access the alumni network',
              formKey: _formKey,
              identifierCtrl: _identifierCtrl,
              passwordCtrl: _passwordCtrl,
              obscurePassword: _obscurePassword,
              isLoading: _isLoading,
              onToggleObscure: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              onSubmit: _submit,
              demoUser: 'student',
              demoPass: 'student123',
            );
          }

          // Mobile — original scrollable layout.
          return SingleChildScrollView(
            child: Column(
              children: [
                // ── Coloured header ──────────────────────────────────────────
                Container(
                  width: double.infinity,
                  color: AppColors.primary,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_outline,
                            color: Colors.white, size: 38),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Welcome, Student',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sign in to access the alumni network',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.72),
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
                    accentColor: AppColors.primary,
                    onToggleObscure: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    onSubmit: _submit,
                    demoUser: 'student',
                    demoPass: 'student123',
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
