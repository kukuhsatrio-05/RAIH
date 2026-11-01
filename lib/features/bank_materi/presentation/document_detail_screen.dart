import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/features/bank_materi/presentation/widgets/detail_header_card.dart';
import 'package:raih/features/bank_materi/presentation/widgets/detail_rating_section.dart';
import 'package:raih/features/bank_materi/presentation/widgets/detail_header_background.dart';
import 'package:raih/features/bank_materi/presentation/widgets/detail_description_section.dart';
import 'package:raih/features/bank_materi/presentation/widgets/detail_contributor_section.dart';
import 'package:raih/features/bank_materi/presentation/widgets/detail_preview_section.dart';
import 'package:raih/features/bank_materi/presentation/widgets/detail_download_button.dart';
import 'package:raih/features/bank_materi/presentation/bank_materi_controller.dart';

class DocumentDetailView extends ConsumerStatefulWidget {
  final String documentId;
  const DocumentDetailView({super.key, required this.documentId});

  @override
  ConsumerState<DocumentDetailView> createState() => _DocumentDetailViewState();
}

class _DocumentDetailViewState extends ConsumerState<DocumentDetailView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(documentDetailViewModelPod(widget.documentId));
    final viewModel = ref.read(
      documentDetailViewModelPod(widget.documentId).notifier,
    );
    final document = state.document;

    if (document == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            // Latar Belakang Biru Ornamen Lingkaran
            const DetailHeaderBackground(),

            // Konten Utama
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tombol Back
                    _buildBackButton(context),

                    // Header & Statistik
                    DetailHeaderCard(document: document),
                    const SizedBox(height: 20),

                    // Section Deskripsi
                    DetailDescriptionSection(
                      description: document.description,
                      isExpanded: state.isDescriptionExpanded,
                      onToggleExpand: () => viewModel.toggleDescription(),
                    ),
                    const SizedBox(height: 20),

                    // Section Kontributor
                    DetailContributorSection(
                      initials: document.authorInitials,
                      name: document.authorName,
                      role: document.authorRole,
                    ),
                    const SizedBox(height: 20),

                    // Section Pratinjau Dokumen
                    DetailPreviewSection(
                      fileType: document.fileType,
                      fileSizeMB: document.fileSizeMB,
                      totalPages: document.totalPages,
                    ),
                    const SizedBox(height: 24),

                    // Tombol Download
                    DetailDownloadButton(onPressed: () {}),
                    const SizedBox(height: 24),

                    // Section Rating
                    DetailRatingSection(
                      averageRating: document.rating,
                      userRating: state.userRating,
                      onRatingChanged: (int rating) {
                        viewModel.setUserRating(rating);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: CircleAvatar(
          backgroundColor: Colors.black.withValues(alpha:0.15),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
