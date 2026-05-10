import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';
import 'package:flutter_clubapp/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:flutter_clubapp/features/squad/presentation/providers/squad_provider.dart';

import 'package:flutter_clubapp/core/widgets/user_avatar.dart';
import 'package:flutter_clubapp/features/profile/screens/public_profile_screen.dart';

class SquadScreen extends ConsumerStatefulWidget {
  const SquadScreen({super.key});

  @override
  ConsumerState<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends ConsumerState<SquadScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _showLocationRationaleDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.squadLocationRequired),
        content: Text(l10n.squadLocationDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.settingsCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.squadEnableLocation),
          ),
        ],
      ),
    );
    if (result == true && mounted) {
      await ref.read(squadProvider.notifier).requestLocationPermission();
    }
  }

  Future<void> _handleCreateSquad() async {
    final l10n = AppLocalizations.of(context)!;
    final userProfile = ref.read(userProfileProvider);
    if (!userProfile.hasNickname) {
      _showNicknameRequiredDialog();
      return;
    }

    final squadNotifier = ref.read(squadProvider.notifier);
    final hasPermission = await squadNotifier.checkLocationPermission();
    if (!hasPermission) {
      await _showLocationRationaleDialog();
      if (!await squadNotifier.checkLocationPermission()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.squadLocationRequired),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    setState(() => _isLoading = true);
    final result = await squadNotifier.createSquad();
    setState(() => _isLoading = false);
    if (result.status == SquadConnectionStatus.error && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? l10n.squadError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleJoinSquad() async {
    final l10n = AppLocalizations.of(context)!;
    if (_pinController.text.length != 6) {
      ShadSonner.of(context).show(
        ShadToast.raw(
          variant: ShadToastVariant.destructive,
          description: Text(l10n.squadWrongPin),
        ),
      );
      return;
    }

    final userProfile = ref.read(userProfileProvider);

    if (!userProfile.hasNickname) {
      _showNicknameRequiredDialog();
      return;
    }

    final squadNotifier = ref.read(squadProvider.notifier);
    final hasPermission = await squadNotifier.checkLocationPermission();
    if (!hasPermission) {
      await _showLocationRationaleDialog();
      if (!await squadNotifier.checkLocationPermission()) {
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
    final result = await squadNotifier.joinSquad(_pinController.text);
    setState(() => _isLoading = false);
    if (result.status == SquadConnectionStatus.error && mounted) {
      ShadSonner.of(context).show(
        ShadToast.raw(
          variant: ShadToastVariant.destructive,
          description: Text(result.errorMessage ?? l10n.squadFailedToJoin),
        ),
      );
    } else if (result.status == SquadConnectionStatus.connected) {
      _pinController.clear();
    }
  }

  void _showNicknameRequiredDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.squadNicknameRequired),
        content: Text(l10n.squadNicknameRequiredDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final squadState = ref.watch(squadProvider);
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.squadTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: squadState.isInSquad
          ? _buildActiveSquadView(squadState, isDark, l10n)
          : _buildJoinCreateView(isDark, l10n),
    );
  }

  Widget _buildJoinCreateView(bool isDark, AppLocalizations l10n) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.groups,
                size: 100,
                color: isDark ? Colors.white24 : Colors.black26,
              ),
              const SizedBox(height: 32),
              Text(
                l10n.squadSubtitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.squadDesc,
                style: const TextStyle(color: Colors.grey, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ShadButton(
                  onPressed: _isLoading ? null : _handleCreateSquad,
                  child: Text(
                    l10n.squadCreate,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.squadOr,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 32),
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
                height: 56,
                child: ShadButton.secondary(
                  onPressed: _isLoading ? null : _handleJoinSquad,
                  child: Text(
                    l10n.squadJoin,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildActiveSquadView(
    SquadProviderState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final members = state.members;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black12,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.squadPinLabel,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.squadPin ?? '',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black,
                      letterSpacing: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            l10n.squadMembers(members.length),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  onTap: () {
                    if (!member.isCurrentUser && member.odmemberId.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PublicProfileScreen(userId: member.odmemberId),
                        ),
                      );
                    }
                  },
                  leading: UserAvatar(
                    name: member.nickname,
                    imageUrl: member.avatarUrl,
                    size: 48,
                    isOnline: member.isOnline,
                    isSpeaking: member.isSpeaking,
                  ),
                  title: Text(
                    member.nickname,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    member.isCurrentUser
                        ? l10n.squadSharingOn
                        : l10n.squadSharingLive,
                    style: TextStyle(
                      color: member.isOnline ? Colors.green : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ShadButton.destructive(
              onPressed: () {
                ref.read(squadProvider.notifier).leaveSquad();
              },
              child: Text(
                l10n.squadLeave,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
