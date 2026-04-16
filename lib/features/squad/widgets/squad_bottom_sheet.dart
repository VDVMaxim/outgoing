import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/core/services/user_profile_service.dart';
import '../providers/squad_provider.dart';

void showSquadSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const SquadBottomSheet(),
  );
}

class SquadBottomSheet extends StatefulWidget {
  const SquadBottomSheet({super.key});

  @override
  State<SquadBottomSheet> createState() => _SquadBottomSheetState();
}

class _SquadBottomSheetState extends State<SquadBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _pinController = TextEditingController();
  bool _scanning = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    SquadProvider.instance.initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateSquad() async {
    final l10n = AppLocalizations.of(context)!;
    final userProfile = await UserProfileService.getInstance();

    if (!userProfile.hasNickname) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.squadNicknameFirst),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final hasPermission = await SquadProvider.instance
        .checkLocationPermission();
    if (!hasPermission) {
      final granted = await SquadProvider.instance.requestLocationPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.squadLocationRequiredToast),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    setState(() => _isLoading = true);

    final result = await SquadProvider.instance.createSquad();

    setState(() => _isLoading = false);

    if (mounted) {
      setState(() {});
      if (result.status == SquadConnectionStatus.error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.squadError),
            content: Text(result.errorMessage ?? l10n.squadFailedToCreate),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (result.status == SquadConnectionStatus.connected) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _handleJoinSquad(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final pin = _pinController.text.trim();
    if (pin.length != 6) {
      ShadSonner.of(context).show(
        ShadToast.raw(
          variant: ShadToastVariant.destructive,
          description: Text(l10n.squadWrongPin),
        ),
      );
      return;
    }

    final userProfile = await UserProfileService.getInstance();

    if (!userProfile.hasNickname) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.squadNicknameFirst),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final hasPermission = await SquadProvider.instance
        .checkLocationPermission();
    if (!hasPermission) {
      final granted = await SquadProvider.instance.requestLocationPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.squadLocationRequiredToast),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    setState(() => _isLoading = true);

    final result = await SquadProvider.instance.joinSquad(pin);

    setState(() => _isLoading = false);

    if (mounted) {
      setState(() {});
      if (result.status == SquadConnectionStatus.error) {
        ShadSonner.of(context).show(
          ShadToast.raw(
            variant: ShadToastVariant.destructive,
            description: Text(result.errorMessage ?? l10n.squadFailedToJoin),
          ),
        );
      } else if (result.status == SquadConnectionStatus.connected) {
        _pinController.clear();
        Navigator.pop(context);
      }
    }
  }

  void _leaveSquad() {
    SquadProvider.instance.leaveSquad();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: SquadProvider.instance,
      builder: (context, _) {
        final provider = SquadProvider.instance;
        final inSquad = provider.isInSquad;

        return Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF09090B) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.groups,
                            color: Colors.blueAccent,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.squadTitle,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (inSquad)
                      _buildActiveView(context, isDark, l10n, provider)
                    else
                      _buildJoinCreateView(context, isDark, l10n),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }

  Widget _buildActiveView(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    SquadProvider provider,
  ) {
    final state = provider.state;
    final members = state.members;
    final textColor = isDark ? Colors.white : Colors.black;

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.squadPinLabel,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.squadPin ?? '',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  QrImageView(
                    data: 'clubapp://squad/${state.squadPin}',
                    version: QrVersions.auto,
                    size: 160,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(8),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: state.squadPin ?? ''),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.squadPinCopied),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 16, color: Colors.grey),
                    label: Text(
                      l10n.squadCopyPin,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.squadMembers(members.length),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            ...members.map(
              (m) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: UserAvatar(
                  name: m.nickname,
                  imageUrl: m.avatarUrl,
                  size: 48,
                  showStatus: true,
                  isOnline: m.isOnline,
                ),
                title: Text(m.nickname, style: TextStyle(color: textColor)),
                subtitle: Text(
                  m.isCurrentUser
                      ? l10n.squadSharingOn
                      : (m.isOnline
                            ? l10n.squadSharingLive
                            : l10n.squadOffline),
                  style: TextStyle(
                    color: m.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ShadButton.destructive(
                onPressed: _leaveSquad,
                child: Text(l10n.squadLeave),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinCreateView(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(text: l10n.squadCreate),
              Tab(text: l10n.squadJoin),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCreateTab(context, isDark, l10n),
                _buildJoinTab(context, isDark, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateTab(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.groups, size: 64, color: Colors.blueAccent),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.squadSubtitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.squadDesc,
            style: const TextStyle(color: Colors.grey, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ShadButton(
              onPressed: _isLoading ? null : _handleCreateSquad,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, size: 18),
                  const SizedBox(width: 8),
                  Text(l10n.squadCreate),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinTab(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _scanning = !_scanning),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _scanning ? 240 : 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _scanning
                      ? Colors.blueAccent
                      : Colors.grey.withValues(alpha: 0.4),
                  width: _scanning ? 2 : 1,
                ),
              ),
              child: _scanning
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: MobileScanner(
                        onDetect: (capture) {
                          final barcodes = capture.barcodes;
                          for (final barcode in barcodes) {
                            final raw = barcode.rawValue ?? '';
                            final pin = raw.replaceFirst(
                              'clubapp://squad/',
                              '',
                            );
                            if (pin.length == 6) {
                              setState(() => _scanning = false);
                              _pinController.text = pin;
                              _handleJoinSquad(context, l10n);
                              return;
                            }
                          }
                        },
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.blueAccent,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.squadScanQR,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.squadOr,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          ShadInput(
            controller: _pinController,
            placeholder: Text(l10n.squadPinHint),
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ShadButton.secondary(
              onPressed: _isLoading
                  ? null
                  : () => _handleJoinSquad(context, l10n),
              child: Text(l10n.squadJoin),
            ),
          ),
        ],
      ),
    );
  }
}
