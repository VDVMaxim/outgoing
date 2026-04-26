import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../providers/association_provider.dart';

class AssociationsSettingsScreen extends ConsumerStatefulWidget {
  const AssociationsSettingsScreen({super.key});

  @override
  ConsumerState<AssociationsSettingsScreen> createState() => _AssociationsSettingsScreenState();
}

class _AssociationsSettingsScreenState extends ConsumerState<AssociationsSettingsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(associationProvider.notifier).loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(associationProvider);
    final textColor = isDark ? Colors.white : Colors.black;

    // Filter de lijst op basis van de zoekopdracht
    final filteredAssociations = state.allAssociations.where((assoc) {
      return assoc.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

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
          'Verenigingen zoeken',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Zoekbalk sectie
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: textColor),
              cursorColor: textColor,
              decoration: InputDecoration(
                hintText: 'Zoek op naam...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          
          Expanded(
            child: state.isLoading && state.allAssociations.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredAssociations.length,
                    itemBuilder: (context, index) {
                      final association = filteredAssociations[index];
                      
                      // Controleer de lidmaatschapsstatus (veiligere methode via iterable)
                      final membership = state.userAssociations
                          .where((m) => m.associationId == association.id)
                          .firstOrNull;

                      final isMember = membership != null && membership.role == 'member';
                      final isPending = membership != null && membership.role == 'pending';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(12),
                          border: isMember 
                            ? Border.all(color: Colors.blueAccent, width: 1.5)
                            : (isPending ? Border.all(color: Colors.amber.withValues(alpha: 0.5), width: 1) : null),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isMember 
                                  ? Colors.blueAccent.withValues(alpha: 0.2)
                                  : (isPending ? Colors.amber.withValues(alpha: 0.1) : (isDark ? Colors.white10 : Colors.grey[200])),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isMember ? Icons.verified : (isPending ? Icons.hourglass_empty : Icons.shield),
                              color: isMember 
                                  ? Colors.blueAccent 
                                  : (isPending ? Colors.amber : (isDark ? Colors.white54 : Colors.black54)),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            association.name,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: isMember ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: isPending 
                            ? const Text('In afwachting van goedkeuring', style: TextStyle(color: Colors.amber, fontSize: 11))
                            : (isMember ? const Text('Actief lid', style: TextStyle(color: Colors.blueAccent, fontSize: 11)) : null),
                          trailing: _buildActionButton(association.id, isMember, isPending, state.isLoading),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String associationId, bool isMember, bool isPending, bool isLoading) {
    if (isMember) {
      return ShadButton.destructive(
        size: ShadButtonSize.sm,
        onPressed: isLoading ? null : () => ref.read(associationProvider.notifier).leaveAssociation(associationId),
        child: const Text('Verlaten'),
      );
    }

    if (isPending) {
      return ShadButton.outline(
        size: ShadButtonSize.sm,
        onPressed: isLoading ? null : () => ref.read(associationProvider.notifier).leaveAssociation(associationId),
        child: const Text('Annuleren'),
      );
    }

    return ShadButton(
      size: ShadButtonSize.sm,
      backgroundColor: Colors.blueAccent,
      onPressed: isLoading ? null : () => ref.read(associationProvider.notifier).joinAssociation(associationId),
      child: const Text('Verzoek sturen'),
    );
  }
}