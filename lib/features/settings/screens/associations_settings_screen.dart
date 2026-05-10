import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter_clubapp/features/associations/presentation/providers/association_provider.dart';
import 'association_details_screen.dart';

class AssociationsSettingsScreen extends ConsumerStatefulWidget {
  const AssociationsSettingsScreen({super.key});

  @override
  ConsumerState<AssociationsSettingsScreen> createState() =>
      _AssociationsSettingsScreenState();
}

class _AssociationsSettingsScreenState
    extends ConsumerState<AssociationsSettingsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentMode = ref.watch(themeProvider);
    final isDark =
        currentMode == ThemeMode.dark ||
        (currentMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    final l10n = AppLocalizations.of(context)!;
    final associationsAsync = ref.watch(associationProvider);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.assocSearchTitle,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: l10n.assocSearchHint,
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) =>
                  setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),
          Expanded(
            child: associationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  l10n.eventsError,
                  style: TextStyle(color: textColor),
                ),
              ),
              data: (state) {
                final filteredList = state.associations.where((assoc) {
                  return assoc.name.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.assocSearchHint,
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final assoc = filteredList[index];
                    final isUserMember = state.userAssociations.any(
                      (m) => m.associationId == assoc.id,
                    );

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AssociationDetailsScreen(association: assoc),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white10
                              : Colors.black.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent.withValues(
                              alpha: 0.2,
                            ),
                            backgroundImage: assoc.logoUrl != null
                                ? NetworkImage(assoc.logoUrl!)
                                : null,
                            child: assoc.logoUrl == null
                                ? Text(
                                    assoc.name.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.blueAccent,
                                    ),
                                  )
                                : null,
                          ),
                          title: Text(
                            assoc.name,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            isUserMember
                                ? l10n.assocActive
                                : l10n.assocSearchHint,
                            style: TextStyle(
                              color: isUserMember ? Colors.green : Colors.grey,
                            ),
                          ),
                          trailing: ShadButton.outline(
                            size: ShadButtonSize.sm,
                            onPressed: () {
                              if (isUserMember) {
                                ref
                                    .read(associationProvider.notifier)
                                    .leaveAssociation(assoc.id);
                              } else {
                                ref
                                    .read(associationProvider.notifier)
                                    .joinAssociation(assoc.id);
                              }
                            },
                            child: Text(
                              isUserMember
                                  ? l10n.assocLeave
                                  : l10n.assocSendRequest,
                              style: TextStyle(
                                color: isUserMember
                                    ? Colors.redAccent
                                    : textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
