import 'package:flutter/material.dart';
import '../models/alumni_model.dart';

// ─── App Colours ───────────────────────────────────────────────────────────────
class AppColors {
  static const Color primary = Color(0xFF0D2B55); // navy
  static const Color primaryDark = Color(0xFF081A36);
  static const Color primaryLight = Color(0xFF1A3F7A);
  static const Color accent = Color(0xFF00838F); // teal
  static const Color accentLight = Color(0xFFE0F7FA);
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
}

// ─── Domain Info Model ────────────────────────────────────────────────────────
class DomainInfo {
  final String name;
  final IconData icon;
  final Color color;
  final Color lightColor;

  const DomainInfo({
    required this.name,
    required this.icon,
    required this.color,
    required this.lightColor,
  });
}

// ─── Domain Category Model ────────────────────────────────────────────────────
class DomainCategory {
  final String categoryName;
  final List<DomainInfo> domains;

  const DomainCategory({
    required this.categoryName,
    required this.domains,
  });
}

// ─── Domain Categories ────────────────────────────────────────────────────────
const List<DomainCategory> kDomainCategories = [
  DomainCategory(
    categoryName: 'Technology',
    domains: [
      DomainInfo(
        name: 'Data Science',
        icon: Icons.analytics_rounded,
        color: Color(0xFF7C3AED),
        lightColor: Color(0xFFF5F3FF),
      ),
      DomainInfo(
        name: 'Data Engineering',
        icon: Icons.storage_rounded,
        color: Color(0xFF1565C0),
        lightColor: Color(0xFFE3F2FD),
      ),
      DomainInfo(
        name: 'Full Stack Development',
        icon: Icons.code_rounded,
        color: Color(0xFF6A1B9A),
        lightColor: Color(0xFFF3E5F5),
      ),
      DomainInfo(
        name: 'Cloud Computing',
        icon: Icons.cloud_rounded,
        color: Color(0xFF00838F),
        lightColor: Color(0xFFE0F7FA),
      ),
      DomainInfo(
        name: 'Artificial Intelligence & Machine Learning',
        icon: Icons.psychology_rounded,
        color: Color(0xFFE65100),
        lightColor: Color(0xFFFBE9E7),
      ),
      DomainInfo(
        name: 'Cybersecurity',
        icon: Icons.security_rounded,
        color: Color(0xFFC62828),
        lightColor: Color(0xFFFFEBEE),
      ),
      DomainInfo(
        name: 'Mobile App Development',
        icon: Icons.phone_android_rounded,
        color: Color(0xFF2E7D32),
        lightColor: Color(0xFFE8F5E9),
      ),
    ],
  ),
  DomainCategory(
    categoryName: 'Government Careers',
    domains: [
      DomainInfo(
        name: 'UPSC',
        icon: Icons.account_balance_rounded,
        color: Color(0xFF1A237E),
        lightColor: Color(0xFFE8EAF6),
      ),
      DomainInfo(
        name: 'TNPSC',
        icon: Icons.account_balance_rounded,
        color: Color(0xFF004D40),
        lightColor: Color(0xFFE0F2F1),
      ),
      DomainInfo(
        name: 'SSC',
        icon: Icons.description_rounded,
        color: Color(0xFF01579B),
        lightColor: Color(0xFFE1F5FE),
      ),
      DomainInfo(
        name: 'Banking Exams',
        icon: Icons.account_balance_wallet_rounded,
        color: Color(0xFF1B5E20),
        lightColor: Color(0xFFE8F5E9),
      ),
      DomainInfo(
        name: 'Other Government Exams',
        icon: Icons.school_rounded,
        color: Color(0xFF4A148C),
        lightColor: Color(0xFFF3E5F5),
      ),
    ],
  ),
  DomainCategory(
    categoryName: 'Entrepreneurship',
    domains: [
      DomainInfo(
        name: 'Startups & Entrepreneurship',
        icon: Icons.rocket_launch_rounded,
        color: Color(0xFFB71C1C),
        lightColor: Color(0xFFFFEBEE),
      ),
    ],
  ),
];

/// Flat list of all domains across all categories.
final List<DomainInfo> kDomains =
    kDomainCategories.expand((c) => c.domains).toList();

/// Returns [DomainInfo] for a given domain name, or null if not found.
DomainInfo? getDomainInfo(String name) {
  try {
    return kDomains.firstWhere((d) => d.name == name);
  } catch (_) {
    return null;
  }
}

// ─── Sample Alumni Data ───────────────────────────────────────────────────────
final List<AlumniModel> kSampleAlumni = [
  // ── Data Science ────────────────────────────────────────────────────────────
  const AlumniModel(
    id: 'ds1',
    name: 'Arjun Sharma',
    domain: 'Data Science',
    company: 'Google',
    designation: 'Senior Data Scientist',
    batch: '2019',
    email: 'arjun.sharma@example.com',
    bio:
        'Builds large-scale recommendation systems and NLP pipelines at Google. '
        'Passionate about making ML systems explainable and fair. Mentor for '
        'college students interested in deep learning and LLMs.',
    skills: ['Python', 'TensorFlow', 'Spark', 'BigQuery', 'NLP'],
  ),
  const AlumniModel(
    id: 'ds2',
    name: 'Kavitha Ramachandran',
    domain: 'Data Science',
    company: 'Amazon',
    designation: 'Applied Scientist',
    batch: '2020',
    email: 'kavitha.r@example.com',
    bio:
        'Works on demand forecasting and supply chain optimisation models at '
        'Amazon. Speaker at PyCon India 2024. Loves statistical modelling and '
        'causal inference.',
    skills: ['Python', 'R', 'PyTorch', 'Causal Inference', 'SQL'],
  ),

  // ── Data Engineering ─────────────────────────────────────────────────────────
  const AlumniModel(
    id: 'de1',
    name: 'Sneha Pillai',
    domain: 'Data Engineering',
    company: 'Flipkart',
    designation: 'Data Engineer',
    batch: '2021',
    email: 'sneha.pillai@example.com',
    bio:
        'Builds real-time data pipelines using Apache Spark, Kafka and Hadoop '
        'at Flipkart. Speaker at PyData India 2023.',
    skills: ['Apache Spark', 'Kafka', 'Hadoop', 'Hive', 'Airflow'],
  ),
  const AlumniModel(
    id: 'de2',
    name: 'Meena Subramanian',
    domain: 'Data Engineering',
    company: 'Swiggy',
    designation: 'Senior Data Analyst',
    batch: '2018',
    email: 'meena.subramanian@example.com',
    bio:
        'Analyses food delivery patterns and builds BI dashboards at Swiggy '
        'using SQL, Python and Tableau. Ex-Zomato data scientist.',
    skills: ['SQL', 'Python', 'Tableau', 'dbt', 'Snowflake'],
  ),

  // ── Full Stack Development ────────────────────────────────────────────────────
  const AlumniModel(
    id: 'fs1',
    name: 'Priya Nair',
    domain: 'Full Stack Development',
    company: 'Microsoft',
    designation: 'Senior Software Engineer',
    batch: '2020',
    email: 'priya.nair@example.com',
    bio:
        'Full stack developer specialising in React, Node.js and Azure cloud '
        'services. Loves building accessible and inclusive web apps. Active '
        'open-source contributor.',
    skills: ['React', 'Node.js', 'TypeScript', 'Azure', 'GraphQL'],
  ),
  const AlumniModel(
    id: 'fs2',
    name: 'Ananya Reddy',
    domain: 'Full Stack Development',
    company: 'Zoho',
    designation: 'Software Developer',
    batch: '2021',
    email: 'ananya.reddy@example.com',
    bio:
        'Develops enterprise SaaS products at Zoho using Java Spring Boot and '
        'React. Passionate about clean architecture and test-driven development.',
    skills: ['Java', 'Spring Boot', 'React', 'MySQL', 'REST APIs'],
  ),
  const AlumniModel(
    id: 'fs3',
    name: 'Suresh Babu',
    domain: 'Full Stack Development',
    company: 'Freshworks',
    designation: 'Lead Engineer',
    batch: '2017',
    email: 'suresh.babu@example.com',
    bio:
        'Leads a team of 8 engineers building the Freshdesk CRM product. '
        'Expert in micro-services architecture and Kubernetes-based deployments.',
    skills: ['Ruby on Rails', 'Vue.js', 'Docker', 'Kubernetes', 'PostgreSQL'],
  ),

  // ── Cloud Computing ───────────────────────────────────────────────────────────
  const AlumniModel(
    id: 'cc1',
    name: 'Rahul Verma',
    domain: 'Cloud Computing',
    company: 'Amazon Web Services',
    designation: 'Cloud Solutions Architect',
    batch: '2018',
    email: 'rahul.verma@example.com',
    bio:
        'AWS-certified architect designing scalable, highly available systems '
        'for Fortune 500 clients. AWS Community Hero and regular conference speaker.',
    skills: ['AWS', 'Terraform', 'CloudFormation', 'Lambda', 'EKS'],
  ),
  const AlumniModel(
    id: 'cc2',
    name: 'Vikram Singh',
    domain: 'Cloud Computing',
    company: 'Tata Consultancy Services',
    designation: 'DevOps Engineer',
    batch: '2020',
    email: 'vikram.singh@example.com',
    bio:
        'Expert in CI/CD pipelines, Kubernetes, Docker and GCP infrastructure '
        'automation. Certified Kubernetes Administrator (CKA).',
    skills: ['GCP', 'Kubernetes', 'Docker', 'Jenkins', 'Helm'],
  ),

  // ── Artificial Intelligence & Machine Learning ────────────────────────────────
  const AlumniModel(
    id: 'ai1',
    name: 'Karan Mehta',
    domain: 'Artificial Intelligence & Machine Learning',
    company: 'NVIDIA',
    designation: 'Deep Learning Engineer',
    batch: '2019',
    email: 'karan.mehta@example.com',
    bio:
        'Works on GPU-accelerated deep learning frameworks and computer vision '
        'models at NVIDIA. Co-author of two research papers on image segmentation.',
    skills: ['CUDA', 'PyTorch', 'Computer Vision', 'C++', 'ONNX'],
  ),
  const AlumniModel(
    id: 'ai2',
    name: 'Nithya Krishnaswamy',
    domain: 'Artificial Intelligence & Machine Learning',
    company: 'Adobe Research',
    designation: 'Research Scientist',
    batch: '2018',
    email: 'nithya.k@example.com',
    bio:
        'Conducts research on generative AI and multimodal models at Adobe '
        'Research. Published 6 peer-reviewed papers at NeurIPS and CVPR.',
    skills: ['Generative AI', 'Diffusion Models', 'Python', 'JAX', 'MLOps'],
  ),
  const AlumniModel(
    id: 'ai3',
    name: 'Dinesh Kumar',
    domain: 'Artificial Intelligence & Machine Learning',
    company: 'Sanas AI',
    designation: 'ML Engineer',
    batch: '2022',
    email: 'dinesh.kumar@example.com',
    bio:
        'Builds speech processing and accent conversion models at Sanas AI. '
        'Specialist in real-time audio ML pipelines and model optimisation.',
    skills: ['Speech Processing', 'Python', 'TensorFlow', 'FastAPI', 'ONNX'],
  ),

  // ── Cybersecurity ─────────────────────────────────────────────────────────────
  const AlumniModel(
    id: 'cs1',
    name: 'Mohammed Rafi',
    domain: 'Cybersecurity',
    company: 'Deloitte',
    designation: 'Security Consultant',
    batch: '2020',
    email: 'mohammed.rafi@example.com',
    bio:
        'Certified ethical hacker (CEH) with expertise in penetration testing, '
        'vulnerability assessment and SIEM tools. OSCP certified.',
    skills: ['Penetration Testing', 'Metasploit', 'Wireshark', 'SIEM', 'CEH'],
  ),
  const AlumniModel(
    id: 'cs2',
    name: 'Aditya Joshi',
    domain: 'Cybersecurity',
    company: 'IBM Security',
    designation: 'Threat Intelligence Analyst',
    batch: '2019',
    email: 'aditya.joshi@example.com',
    bio:
        'Tracks and analyses advanced persistent threats (APT) at IBM Security. '
        'Specialises in malware reverse engineering and threat hunting.',
    skills: ['Threat Hunting', 'Malware Analysis', 'YARA', 'IDA Pro', 'OSINT'],
  ),

  // ── Mobile App Development ────────────────────────────────────────────────────
  const AlumniModel(
    id: 'mob1',
    name: 'Divya Krishnan',
    domain: 'Mobile App Development',
    company: 'Infosys',
    designation: 'Flutter Developer',
    batch: '2022',
    email: 'divya.krishnan@example.com',
    bio:
        'Builds cross-platform mobile apps using Flutter and Dart. Contributor '
        'to open-source Flutter packages. Google Developer Expert (GDE) nominee.',
    skills: ['Flutter', 'Dart', 'Firebase', 'REST APIs', 'Provider'],
  ),
  const AlumniModel(
    id: 'mob2',
    name: 'Lakshmi Iyer',
    domain: 'Mobile App Development',
    company: 'Ola',
    designation: 'iOS Developer',
    batch: '2021',
    email: 'lakshmi.iyer@example.com',
    bio:
        'Builds the Ola passenger and driver iOS apps using Swift and SwiftUI. '
        'Apple WWDC Scholar 2022.',
    skills: ['Swift', 'SwiftUI', 'UIKit', 'Xcode', 'CoreData'],
  ),

  // ── UPSC ─────────────────────────────────────────────────────────────────────
  const AlumniModel(
    id: 'up1',
    name: 'Bharath Raghavan',
    domain: 'UPSC',
    company: 'Indian Administrative Service',
    designation: 'IAS Officer (District Collector)',
    batch: '2016',
    email: 'bharath.r@example.com',
    bio:
        'Selected in UPSC CSE 2018 (AIR 47). Currently serving as District '
        'Collector in Coimbatore district, Tamil Nadu. Champion of digital '
        'governance and e-services for rural citizens.',
    skills: ['Public Administration', 'Policy Analysis', 'e-Governance', 'Leadership'],
  ),
  const AlumniModel(
    id: 'up2',
    name: 'Soundarya Venkatesh',
    domain: 'UPSC',
    company: 'Indian Police Service',
    designation: 'IPS Officer (Deputy SP)',
    batch: '2017',
    email: 'soundarya.v@example.com',
    bio:
        'Selected in UPSC CSE 2019 (AIR 112). Serving as Deputy Superintendent '
        'of Police in Tamil Nadu cadre. Focus on cybercrime investigation and '
        'women safety initiatives.',
    skills: ['Law Enforcement', 'Criminal Investigation', 'Cybercrime', 'Leadership'],
  ),

  // ── TNPSC ─────────────────────────────────────────────────────────────────────
  const AlumniModel(
    id: 'tn1',
    name: 'Muthukumar Palaniswamy',
    domain: 'TNPSC',
    company: 'Tamil Nadu Government',
    designation: 'Deputy Collector (TNPSC Group 1)',
    batch: '2018',
    email: 'muthukumar.p@example.com',
    bio:
        'Cleared TNPSC Group 1 in 2020 with state rank 15. Currently posted '
        'as Deputy Collector in Madurai. Active in rural development and '
        'welfare scheme implementation.',
    skills: ['Revenue Administration', 'Policy Implementation', 'Tamil', 'Leadership'],
  ),
  const AlumniModel(
    id: 'tn2',
    name: 'Selvi Arumugam',
    domain: 'TNPSC',
    company: 'Tamil Nadu Government',
    designation: 'Commercial Tax Officer (TNPSC Group 2)',
    batch: '2019',
    email: 'selvi.a@example.com',
    bio:
        'Cleared TNPSC Group 2 in 2021. Working as Commercial Tax Officer in '
        'Chennai. Passionate about tax reforms and transparency in government.',
    skills: ['Taxation', 'GST', 'Public Finance', 'Audit'],
  ),

  // ── SSC ───────────────────────────────────────────────────────────────────────
  const AlumniModel(
    id: 'ssc1',
    name: 'Ganesh Murugesan',
    domain: 'SSC',
    company: 'Central Government of India',
    designation: 'Income Tax Inspector (SSC CGL)',
    batch: '2020',
    email: 'ganesh.m@example.com',
    bio:
        'Cleared SSC CGL 2022 and serving as Income Tax Inspector under CBDT. '
        'Based in Chennai. Guides juniors on SSC exam preparation strategies.',
    skills: ['Tax Administration', 'Audit', 'MS Office', 'Accounting'],
  ),
  const AlumniModel(
    id: 'ssc2',
    name: 'Pooja Natarajan',
    domain: 'SSC',
    company: 'Central Government of India',
    designation: 'Sub-Inspector (SSC CPO)',
    batch: '2021',
    email: 'pooja.n@example.com',
    bio:
        'Cleared SSC CPO 2022. Serving as Sub-Inspector in Central Industrial '
        'Security Force (CISF). Interested in cybercrime prevention.',
    skills: ['Security Operations', 'Investigation', 'Physical Fitness', 'Law'],
  ),

  // ── Banking Exams ─────────────────────────────────────────────────────────────
  const AlumniModel(
    id: 'bk1',
    name: 'Ramya Subramaniam',
    domain: 'Banking Exams',
    company: 'State Bank of India',
    designation: 'Probationary Officer (SBI PO)',
    batch: '2021',
    email: 'ramya.s@example.com',
    bio:
        'Cleared SBI PO 2023. Posted at SBI Coimbatore branch. Specialises in '
        'MSME lending and retail banking. Mentors students for banking exams.',
    skills: ['Banking Operations', 'MSME Lending', 'Financial Analysis', 'Customer Service'],
  ),
  const AlumniModel(
    id: 'bk2',
    name: 'Thirumaran Senthil',
    domain: 'Banking Exams',
    company: 'Canara Bank',
    designation: 'Assistant Manager (IBPS PO)',
    batch: '2020',
    email: 'thirumaran.s@example.com',
    bio:
        'Selected through IBPS PO 2022. Working as Assistant Manager at Canara '
        'Bank, Salem. Focus on agri-loans and rural credit disbursement.',
    skills: ['Credit Analysis', 'Agri Finance', 'NPA Management', 'Banking Law'],
  ),

  // ── Other Government Exams ─────────────────────────────────────────────────────
  const AlumniModel(
    id: 'og1',
    name: 'Vignesh Annamalai',
    domain: 'Other Government Exams',
    company: 'Indian Railways',
    designation: 'Junior Engineer (RRB JE)',
    batch: '2021',
    email: 'vignesh.a@example.com',
    bio:
        'Cleared RRB JE 2023. Working as Junior Engineer – Electrical at Southern '
        'Railway, Chennai Division. Responsible for traction sub-station maintenance.',
    skills: ['Electrical Engineering', 'Traction Power', 'Safety', 'Maintenance'],
  ),
  const AlumniModel(
    id: 'og2',
    name: 'Deepa Chandrasekaran',
    domain: 'Other Government Exams',
    company: 'DRDO',
    designation: 'Scientist B (DRDO SET)',
    batch: '2020',
    email: 'deepa.c@example.com',
    bio:
        'Cleared DRDO SET 2022 in Computer Science. Working on embedded systems '
        'for defence applications at DRDO-CAIR, Bengaluru.',
    skills: ['Embedded Systems', 'C/C++', 'RTOS', 'Signal Processing', 'MATLAB'],
  ),

  // ── Startups & Entrepreneurship ───────────────────────────────────────────────
  const AlumniModel(
    id: 'en1',
    name: 'Harish Balakrishnan',
    domain: 'Startups & Entrepreneurship',
    company: 'AgriTech Solutions Pvt. Ltd.',
    designation: 'Co-Founder & CEO',
    batch: '2017',
    email: 'harish.b@example.com',
    bio:
        'Founded AgriTech Solutions in 2020, providing AI-powered crop advisory '
        'services to 50,000+ farmers across Tamil Nadu. Raised ₹4 Cr seed funding. '
        'Y Combinator alumni (W22).',
    skills: ['Entrepreneurship', 'Product Strategy', 'Fundraising', 'AgriTech', 'Leadership'],
  ),
  const AlumniModel(
    id: 'en2',
    name: 'Preethi Saravanan',
    domain: 'Startups & Entrepreneurship',
    company: 'EduMinds Technologies',
    designation: 'Founder & CTO',
    batch: '2018',
    email: 'preethi.s@example.com',
    bio:
        'Built EduMinds, an adaptive learning EdTech platform serving 2 lakh '
        'students across Tier 2 cities. National Startup Award 2023 winner. '
        'Forbes 30 Under 30 India – Education.',
    skills: ['EdTech', 'Product Development', 'Fundraising', 'Business Strategy', 'AI/ML'],
  ),
  const AlumniModel(
    id: 'en3',
    name: 'Sathish Rajendran',
    domain: 'Startups & Entrepreneurship',
    company: 'NexaLogic Labs',
    designation: 'Co-Founder & CXO',
    batch: '2016',
    email: 'sathish.r@example.com',
    bio:
        'Co-founded NexaLogic Labs, a B2B SaaS company automating supply chain '
        'analytics for mid-size manufacturers. 3x revenue growth in 2 years. '
        'Mentor at NASSCOM 10,000 Startups.',
    skills: ['SaaS', 'Supply Chain', 'Sales', 'Product Management', 'Leadership'],
  ),
];
