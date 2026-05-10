import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/features/associations/domain/models/association.dart';
import 'package:flutter_clubapp/features/associations/presentation/providers/association_provider.dart';

class AssociationDetailsScreen extends ConsumerWidget {
  final Association association;

  const AssociationDetailsScreen({super.key, required this.association});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stateAsync = ref.watch(associationProvider);
    final state = stateAsync.value;

    // Bepaal de huidige lidmaatschapsstatus (safe-navigatie wegens AsyncValue)
    final membership = state?.userAssociations
        .where((m) => m.associationId == association.id)
        .firstOrNull;

    final isMember = membership != null && membership.role == 'member';
    final isPending = membership != null && membership.role == 'pending';
    final isLoading = stateAsync.isLoading || (state?.isLoading ?? false);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF18181B) : Colors.white,
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : Colors.black,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background:
                  association.bannerUrl != null &&
                      association.bannerUrl!.isNotEmpty
                  ? Image.network(association.bannerUrl!, fit: BoxFit.cover)
                  : Container(
                      color: isDark ? Colors.white10 : Colors.black12,
                      child: Icon(
                        Icons.groups,
                        size: 80,
                        color: isDark ? Colors.white24 : Colors.black26,
                      ),
                    ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF18181B) : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF09090B)
                              : Colors.white,
                          width: 4,
                        ),
                        image:
                            association.logoUrl != null &&
                                association.logoUrl!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(association.logoUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child:
                          association.logoUrl == null ||
                              association.logoUrl!.isEmpty
                          ? Icon(
                              Icons.shield,
                              size: 40,
                              color: isDark ? Colors.white54 : Colors.black54,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: -32),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          association.name,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (isMember)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.verified,
                            color: Colors.blueAccent,
                            size: 32,
                          ),
                        ),
                    ],
                  ),

                  if (isMember || isPending) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isMember
                            ? Colors.blueAccent.withValues(alpha: 0.15)
                            : Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isMember
                              ? Colors.blueAccent.withValues(alpha: 0.3)
                              : Colors.amber.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isMember
                                ? Icons.check_circle
                                : Icons.hourglass_empty,
                            size: 18,
                            color: isMember ? Colors.blueAccent : Colors.amber,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isMember
                                ? AppLocalizations.of(
                                    context,
                                  )!.assocActiveMember
                                : AppLocalizations.of(
                                    context,
                                  )!.assocPendingRequest,
                            style: TextStyle(
                              color: isMember
                                  ? Colors.blueAccent
                                  : Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  if (association.tags.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: association.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white10
                                : Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                  ],

                  Text(
                    AppLocalizations.of(context)!.assocAboutTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    association.description != null &&
                            association.description!.isNotEmpty
                        ? association.description!
                        : AppLocalizations.of(context)!.assocNoDescription,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 48),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: _buildActionButton(
                      context,
                      ref,
                      association.id,
                      isMember,
                      isPending,
                      isLoading,
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    String associationId,
    bool isMember,
    bool isPending,
    bool isLoading,
  ) {
    if (isMember) {
      return ShadButton.destructive(
        onPressed: isLoading
            ? null
            : () => ref
                  .read(associationProvider.notifier)
                  .leaveAssociation(associationId),
        child: Text(
          AppLocalizations.of(context)!.assocLeave,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (isPending) {
      return ShadButton.outline(
        onPressed: isLoading
            ? null
            : () => ref
                  .read(associationProvider.notifier)
                  .leaveAssociation(associationId),
        child: Text(
          AppLocalizations.of(context)!.assocCancelRequest,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ShadButton(
      backgroundColor: Colors.blueAccent,
      onPressed: isLoading
          ? null
          : () => ref
                .read(associationProvider.notifier)
                .joinAssociation(associationId),
      child: Text(
        AppLocalizations.of(context)!.assocRequestMembership,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
