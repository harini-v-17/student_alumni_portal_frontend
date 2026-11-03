import 'package:flutter/material.dart';
import '../models/alumni_model.dart';
import '../utils/constants.dart';

/// Represents a job or internship opportunity posted by an alumni.
class JobOpportunity {
  final String id;
  final String title;
  final String company;
  final String location;
  final String type; // e.g. Full-time, Internship, Remote
  final String description;
  final String postedBy;
  final String postedDate;
  final String contactEmail;

  const JobOpportunity({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.description,
    required this.postedBy,
    required this.postedDate,
    required this.contactEmail,
  });
}

/// Represents a mentorship query from a student to alumni.
class MentorshipQuery {
  final String id;
  final String studentName;
  final String studentEmail;
  final String studentBatch;
  final String topic;
  final String message;
  final String requestedDate;
  String status; // 'Pending', 'Accepted', 'Completed'

  MentorshipQuery({
    required this.id,
    required this.studentName,
    required this.studentEmail,
    required this.studentBatch,
    required this.topic,
    required this.message,
    required this.requestedDate,
    this.status = 'Pending',
  });
}

/// Manages the alumni list, search query and domain filter,
/// as well as opportunities and student mentorship queries.
class AlumniProvider extends ChangeNotifier {
  String _searchQuery = '';
  String _selectedDomain = 'All';

  // ─── Opportunities State ───────────────────────────────────────────────────
  final List<JobOpportunity> _jobOpportunities = [
    const JobOpportunity(
      id: 'job1',
      title: 'Associate Software Engineer',
      company: 'Microsoft',
      location: 'Bengaluru / Hybrid',
      type: 'Full-time',
      description:
          'Open for 2024 & 2025 batch graduates. Experience with React, Node.js or C#/.NET is preferred.',
      postedBy: 'Priya Nair',
      postedDate: 'Yesterday',
      contactEmail: 'priya.nair@example.com',
    ),
    const JobOpportunity(
      id: 'job2',
      title: 'Machine Learning & NLP Intern',
      company: 'Google',
      location: 'Hyderabad / Remote',
      type: 'Internship',
      description:
          '3-month summer internship working with transformer models and large dataset pipelines.',
      postedBy: 'Arjun Sharma',
      postedDate: '3 days ago',
      contactEmail: 'arjun.sharma@example.com',
    ),
    const JobOpportunity(
      id: 'job3',
      title: 'Cloud DevOps Associate',
      company: 'Amazon',
      location: 'Chennai / Hybrid',
      type: 'Full-time',
      description:
          'Managing AWS cloud infrastructure, Docker containers and CI/CD pipelines.',
      postedBy: 'Kavitha Ramachandran',
      postedDate: '5 days ago',
      contactEmail: 'kavitha.r@example.com',
    ),
  ];

  // ─── Mentorship Queries State ──────────────────────────────────────────────
  final List<MentorshipQuery> _mentorshipQueries = [
    MentorshipQuery(
      id: 'mq1',
      studentName: 'Aditya Kumar',
      studentEmail: 'aditya.k@university.edu',
      studentBatch: '2025',
      topic: 'Resume Review & Technical Interview Prep',
      message:
          'Hi! I am applying for SDE roles in top tech companies. Would appreciate your review on my projects and interview guidance.',
      requestedDate: 'Today, 10:30 AM',
      status: 'Pending',
    ),
    MentorshipQuery(
      id: 'mq2',
      studentName: 'Sneha Patel',
      studentEmail: 'sneha.p@university.edu',
      studentBatch: '2026',
      topic: 'Full Stack Career Roadmap',
      message:
          'Hello Priya, I am exploring cloud technologies alongside React. Could you share some guidance on building production-grade projects?',
      requestedDate: 'Yesterday',
      status: 'Accepted',
    ),
  ];

  // ─── Getters ────────────────────────────────────────────────────────────────

  String get searchQuery => _searchQuery;
  String get selectedDomain => _selectedDomain;
  List<JobOpportunity> get jobOpportunities =>
      List.unmodifiable(_jobOpportunities);
  List<MentorshipQuery> get mentorshipQueries =>
      List.unmodifiable(_mentorshipQueries);

  /// Returns the full list of alumni filtered by search query and domain.
  List<AlumniModel> get filteredAlumni {
    return kSampleAlumni.where((alumni) {
      final query = _searchQuery.toLowerCase();
      final matchesSearch = query.isEmpty ||
          alumni.name.toLowerCase().contains(query) ||
          alumni.company.toLowerCase().contains(query) ||
          alumni.designation.toLowerCase().contains(query) ||
          alumni.skills.join(' ').toLowerCase().contains(query);

      final matchesDomain =
          _selectedDomain == 'All' || alumni.domain == _selectedDomain;

      return matchesSearch && matchesDomain;
    }).toList();
  }

  /// Returns the 5 most recently added alumni (last 5 in the sample list).
  List<AlumniModel> get recentAlumni {
    final list = kSampleAlumni;
    if (list.length <= 5) return list;
    return list.sublist(list.length - 5);
  }

  // ─── Actions ────────────────────────────────────────────────────────────────

  /// Updates the search query and notifies listeners to rebuild the UI.
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Updates the selected domain filter and notifies listeners.
  void setDomainFilter(String domain) {
    _selectedDomain = domain;
    notifyListeners();
  }

  /// Resets search and domain filter back to defaults.
  void clearFilters() {
    _searchQuery = '';
    _selectedDomain = 'All';
    notifyListeners();
  }

  /// Adds a new job or internship opportunity.
  void addJobOpportunity(JobOpportunity job) {
    _jobOpportunities.insert(0, job);
    notifyListeners();
  }

  /// Updates status of a student mentorship query ('Accepted', 'Completed', 'Declined').
  void updateQueryStatus(String queryId, String newStatus) {
    final index = _mentorshipQueries.indexWhere((q) => q.id == queryId);
    if (index != -1) {
      _mentorshipQueries[index].status = newStatus;
      notifyListeners();
    }
  }

  /// Adds a new mentorship request sent by a student or alumnus.
  void sendMentorshipQuery({
    required String studentName,
    required String studentEmail,
    required String studentBatch,
    required String topic,
    required String message,
  }) {
    _mentorshipQueries.insert(
      0,
      MentorshipQuery(
        id: 'mq_${DateTime.now().millisecondsSinceEpoch}',
        studentName: studentName,
        studentEmail: studentEmail,
        studentBatch: studentBatch,
        topic: topic,
        message: message,
        requestedDate: 'Just now',
        status: 'Pending',
      ),
    );
    notifyListeners();
  }
}
