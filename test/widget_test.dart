import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:aluminiportal/main.dart';
import 'package:aluminiportal/providers/auth_provider.dart';
import 'package:aluminiportal/providers/alumni_provider.dart';
import 'package:aluminiportal/screens/alumni_dashboard/alumni_dashboard_screen.dart';
import 'package:aluminiportal/screens/student/student_dashboard.dart';

void main() {
  testWidgets('App launches and shows welcome screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentAlumniPortalApp());
    await tester.pump();
    // The welcome screen should show the portal title.
    expect(find.text('University Alumni Portal'), findsOneWidget);
  });

  testWidgets('Welcome screen shows Student Login and Alumni Login buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentAlumniPortalApp());
    await tester.pump();
    expect(find.text('Student Login'), findsOneWidget);
    expect(find.text('Alumni Login'), findsOneWidget);
  });

  testWidgets(
      'AuthProvider loginAsStudent returns error for wrong password',
      (WidgetTester tester) async {
    final auth = AuthProvider();
    final error = auth.loginAsStudent('student', 'wrongpassword');
    expect(error, isNotNull);
    expect(auth.isLoggedIn, isFalse);
  });

  testWidgets(
      'AuthProvider loginAsStudent succeeds with correct credentials',
      (WidgetTester tester) async {
    final auth = AuthProvider();
    final error = auth.loginAsStudent('student', 'student123');
    expect(error, isNull);
    expect(auth.isLoggedIn, isTrue);
    expect(auth.currentUser?.role, UserRole.student);
  });

  testWidgets(
      'AuthProvider loginAsAlumni returns error for wrong password',
      (WidgetTester tester) async {
    final auth = AuthProvider();
    final error = auth.loginAsAlumni('alumni', 'wrongpassword');
    expect(error, isNotNull);
    expect(auth.isLoggedIn, isFalse);
  });

  testWidgets(
      'AuthProvider loginAsAlumni succeeds with correct credentials',
      (WidgetTester tester) async {
    final auth = AuthProvider();
    final error = auth.loginAsAlumni('alumni', 'alumni123');
    expect(error, isNull);
    expect(auth.isLoggedIn, isTrue);
    expect(auth.currentUser?.role, UserRole.alumni);
  });

  testWidgets(
      'AuthProvider loginAsAlumni succeeds with registered sample alumni email',
      (WidgetTester tester) async {
    final auth = AuthProvider();
    final error = auth.loginAsAlumni('arjun.sharma@example.com', 'alumni123');
    expect(error, isNull);
    expect(auth.isLoggedIn, isTrue);
    expect(auth.currentUser?.name, 'Arjun Sharma');
    expect(auth.currentUser?.role, UserRole.alumni);
  });

  testWidgets(
      'AuthProvider logoutAlumni clears alumni session properly',
      (WidgetTester tester) async {
    final auth = AuthProvider();
    auth.loginAsAlumni('alumni', 'alumni123');
    expect(auth.isLoggedIn, isTrue);

    auth.logoutAlumni();
    expect(auth.isLoggedIn, isFalse);
    expect(auth.currentUser, isNull);
  });

  testWidgets(
      'AuthProvider updateAlumniProfile modifies current user attributes',
      (WidgetTester tester) async {
    final auth = AuthProvider();
    auth.loginAsAlumni('alumni', 'alumni123');
    expect(auth.currentUser?.designation, 'Senior Software Engineer');

    auth.updateAlumniProfile(
      designation: 'Principal Engineer',
      company: 'Microsoft HQ',
    );
    expect(auth.currentUser?.designation, 'Principal Engineer');
    expect(auth.currentUser?.company, 'Microsoft HQ');
  });

  testWidgets(
      'AlumniProvider job opportunities and mentorship queries work correctly',
      (WidgetTester tester) async {
    final provider = AlumniProvider();
    expect(provider.jobOpportunities.isNotEmpty, isTrue);

    final initialCount = provider.jobOpportunities.length;
    provider.addJobOpportunity(
      const JobOpportunity(
        id: 'test_job',
        title: 'Flutter Developer',
        company: 'InnovateTech',
        location: 'Remote',
        type: 'Full-time',
        description: 'Building mobile apps with Flutter.',
        postedBy: 'Test Alumni',
        postedDate: 'Today',
        contactEmail: 'jobs@innovatetech.com',
      ),
    );
    expect(provider.jobOpportunities.length, initialCount + 1);

    expect(provider.mentorshipQueries.isNotEmpty, isTrue);
    final firstQuery = provider.mentorshipQueries.first;
    provider.updateQueryStatus(firstQuery.id, 'Accepted');
    expect(
      provider.mentorshipQueries.firstWhere((q) => q.id == firstQuery.id).status,
      'Accepted',
    );
  });

  testWidgets(
      'AlumniProvider filteredAlumni returns all alumni when no filter',
      (WidgetTester tester) async {
    final provider = AlumniProvider();
    expect(provider.filteredAlumni.isNotEmpty, isTrue);
  });

  testWidgets(
      'AlumniDashboardScreen renders authenticated user and dashboard widgets',
      (WidgetTester tester) async {
    final auth = AuthProvider();
    final alumniProvider = AlumniProvider();
    auth.loginAsAlumni('alumni', 'alumni123');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<AlumniProvider>.value(value: alumniProvider),
        ],
        child: const MaterialApp(
          home: AlumniDashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Priya Nair'), findsOneWidget);
    expect(find.text('Total Alumni'), findsOneWidget);
    expect(find.text('Student Mentorship Queries'), findsOneWidget);
  });

  testWidgets(
      'Alumni Logout immediately clears session and navigates directly to WelcomeScreen',
      (WidgetTester tester) async {
    final auth = AuthProvider();
    final alumniProvider = AlumniProvider();
    auth.loginAsAlumni('alumni', 'alumni123');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<AlumniProvider>.value(value: alumniProvider),
        ],
        child: const MaterialApp(
          home: AlumniDashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Logout button (in AppBar on mobile/tablet or in Sidebar on desktop)
    final logoutButton = find.byIcon(Icons.logout);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    // 1. Session is immediately cleared
    expect(auth.isLoggedIn, isFalse);
    expect(auth.currentUser, isNull);

    // 2. Direct navigation to the Selection Page (WelcomeScreen)
    // 3. Displays both options
    expect(find.text('University Alumni Portal'), findsOneWidget);
    expect(find.text('Student Login'), findsOneWidget);
    expect(find.text('Alumni Login'), findsOneWidget);
  });

  testWidgets(
      'StudentDashboard renders enhanced student features and existing sections',
      (WidgetTester tester) async {
    final auth = AuthProvider();
    final alumniProvider = AlumniProvider();
    auth.loginAsStudent('student', 'student123');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<AlumniProvider>.value(value: alumniProvider),
        ],
        child: const MaterialApp(
          home: StudentDashboard(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Welcome message
    expect(find.text('Welcome, Rohan Mehta!'), findsOneWidget);

    // Verify 3 newly added features
    expect(find.text('Campus Updates & Alumni Jobs'), findsOneWidget);
    expect(find.text('Placement Preparation Hub'), findsOneWidget);
    expect(find.text('Domain Study Materials & Roadmaps'), findsOneWidget);

    // Verify existing features preserved
    expect(find.text('Explore Career Domains'), findsOneWidget);
    expect(find.text('Recently Added Alumni'), findsOneWidget);
  });
}
