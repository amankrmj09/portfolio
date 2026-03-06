import 'package:flutter/material.dart';
import 'package:portfolio/widgets/k.image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/models/project_model/project.model.dart';
import '../../../infrastructure/theme/colors.dart';

class WorkMobileView extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onClose;

  const WorkMobileView({super.key, required this.project, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColor.darkNavy, // ✅ Modern blackish-bluish
      extendBodyBehindAppBar: true,
      appBar: _buildModernAppBar(context),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 80,
            left: 16,
            right: 16,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Scrollable Images
              _buildImageCarousel(),
              const SizedBox(height: 24),

              // 2. Project Name
              _buildTitle(),
              const SizedBox(height: 16),

              // 3. Tech Stack Chips
              if (project.techStack.isNotEmpty) ...[
                _buildTechStackSection(),
                const SizedBox(height: 20),
              ],

              // 4. Large Description
              _buildDescription(),
              const SizedBox(height: 24),

              // 5. GitHub Link
              if (project.url.isNotEmpty) _buildLink(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _buildModernAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              KColor.darkNavy.withValues(alpha: 0.9),
              KColor.deepNavy.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: KColor.accentBlue.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              _buildBackButton(context),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  project.name,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 56), // Balance back button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: onClose ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              KColor.darkRed.withValues(alpha: 0.5),
              KColor.darkerRed.withValues(alpha: 0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: KColor.alertRed.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: Colors.white.withValues(alpha: 0.95),
          size: 22,
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: project.images.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(
            right: index < project.images.length - 1 ? 12 : 0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 340,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: KColor.accentBlue.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: KImage(url: project.images[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      project.name,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Colors.white.withValues(alpha: 0.95),
        fontFamily: 'Poppins',
        letterSpacing: 0.3,
        height: 1.3,
      ),
    );
  }

  Widget _buildTechStackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tech Stack',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.95),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: project.techStack
              .map(
                (tech) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        KColor.accentBlue.withValues(alpha: 0.3),
                        KColor.deepNavy.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: KColor.accentBlue.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tech,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      project.largeDescription,
      style: TextStyle(
        fontSize: 15,
        color: Colors.white.withValues(alpha: 0.8),
        fontFamily: 'Poppins',
        height: 1.6,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildLink() {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(project.url);
        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
            webOnlyWindowName: '_blank',
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              KColor.accentBlue.withValues(alpha: 0.3),
              KColor.deepNavy.withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: KColor.accentBlue.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: KColor.accentBlue.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.code_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'View on GitHub',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white.withValues(alpha: 0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
