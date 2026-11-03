import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';

// ─── Shared login form widgets (used by both login screens) ───────────────────

/// Desktop/Tablet — centred card layout.
class SharedDesktopLoginBody extends StatelessWidget {
  final Color accentColor;
  final IconData icon;
  final String welcomeTitle;
  final String welcomeSub;
  final GlobalKey<FormState> formKey;
  final TextEditingController identifierCtrl;
  final TextEditingController passwordCtrl;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;
  final String demoUser;
  final String demoPass;
  final VoidCallback? onQuickFill;

  const SharedDesktopLoginBody({
    super.key,
    required this.accentColor,
    required this.icon,
    required this.welcomeTitle,
    required this.welcomeSub,
    required this.formKey,
    required this.identifierCtrl,
    required this.passwordCtrl,
    required this.obscurePassword,
    required this.isLoading,
    required this.onToggleObscure,
    required this.onSubmit,
    required this.demoUser,
    required this.demoPass,
    this.onQuickFill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: Center(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: Breakpoints.maxFormWidth),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header band
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.fromLTRB(32, 32, 32, 28),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon,
                              color: Colors.white, size: 38),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          welcomeTitle,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          welcomeSub,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  // Form body
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(32, 28, 32, 32),
                    child: SharedLoginForm(
                      formKey: formKey,
                      identifierCtrl: identifierCtrl,
                      passwordCtrl: passwordCtrl,
                      obscurePassword: obscurePassword,
                      isLoading: isLoading,
                      accentColor: accentColor,
                      onToggleObscure: onToggleObscure,
                      onSubmit: onSubmit,
                      demoUser: demoUser,
                      demoPass: demoPass,
                      onQuickFill: onQuickFill,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared form fields for student and alumni login.
class SharedLoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController identifierCtrl;
  final TextEditingController passwordCtrl;
  final bool obscurePassword;
  final bool isLoading;
  final Color accentColor;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;
  final String demoUser;
  final String demoPass;
  final VoidCallback? onQuickFill;

  const SharedLoginForm({
    super.key,
    required this.formKey,
    required this.identifierCtrl,
    required this.passwordCtrl,
    required this.obscurePassword,
    required this.isLoading,
    required this.accentColor,
    required this.onToggleObscure,
    required this.onSubmit,
    required this.demoUser,
    required this.demoPass,
    this.onQuickFill,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username / email
          _label('Username or Email'),
          const SizedBox(height: 8),
          TextFormField(
            controller: identifierCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: _decoration(
              hint: 'e.g. $demoUser or $demoUser@university.edu',
              icon: Icons.person_outline,
              accentColor: accentColor,
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Username or email is required'
                : null,
          ),
          const SizedBox(height: 20),

          // Password
          _label('Password'),
          const SizedBox(height: 8),
          TextFormField(
            controller: passwordCtrl,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmit(),
            decoration: _decoration(
              hint: 'Enter password',
              icon: Icons.lock_outline,
              accentColor: accentColor,
              suffix: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: onToggleObscure,
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 4) return 'Password must be at least 4 characters';
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Sign In button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                textStyle: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Sign In'),
            ),
          ),
          const SizedBox(height: 24),

          // Demo credentials hint
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onQuickFill,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: accentColor.withOpacity(0.3), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 15, color: accentColor),
                        const SizedBox(width: 6),
                        Text(
                          'Demo Credentials',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                        if (onQuickFill != null) ...[
                          const Spacer(),
                          Text(
                            'Tap to autofill',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Username:  $demoUser',
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Password:  ${demoUser}123',
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ),
            //),
        //  ),
       ],
      )
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      );

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    required Color accentColor,
    Widget? suffix,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            color: AppColors.textSecondary, fontSize: 13.5),
        prefixIcon:
            Icon(icon, color: AppColors.textSecondary, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );
}

