import 'package:flutter/material.dart';
import 'package:flutter_clubapp/l10n/app_localizations.dart';

class PushNotificationsScreen extends StatefulWidget {
  const PushNotificationsScreen({super.key});

  @override
  State<PushNotificationsScreen> createState() =>
      _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  bool _notificationsEnabled = true;
  bool _flashPromos = true;
  bool _squadAlerts = true;
  bool _chatMessages = true;
  bool _newFeatures = false;
  bool _quietHoursEnabled = false;
  TimeOfDay _quietHoursFrom = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursTo = const TimeOfDay(hour: 8, minute: 0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.pushNotificationsTitle,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            isDark,
            children: [
              SwitchListTile(
                title: Text(
                  AppLocalizations.of(context)!.enableNotifications,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.enableNotificationsDesc,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                secondary: Icon(
                  Icons.notifications_outlined,
                  color: Colors.blueAccent,
                ),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                },
              ),
            ],
          ),
          if (_notificationsEnabled) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(
              AppLocalizations.of(context)!.notificationTypes,
            ),
            const SizedBox(height: 8),
            _buildSection(
              isDark,
              children: [
                SwitchListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.flashPromos,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      AppLocalizations.of(context)!.flashPromosDesc,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
                  value: _flashPromos,
                  onChanged: (value) {
                    setState(() => _flashPromos = value);
                  },
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                SwitchListTile(
                  title: Row(
                    children: [
                      Icon(Icons.group, color: Colors.purple, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.squadAlerts,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      AppLocalizations.of(context)!.squadAlertsDesc,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
                  value: _squadAlerts,
                  onChanged: (value) {
                    setState(() => _squadAlerts = value);
                  },
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                SwitchListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.chatMessages,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      AppLocalizations.of(context)!.chatMessagesDesc,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
                  value: _chatMessages,
                  onChanged: (value) {
                    setState(() => _chatMessages = value);
                  },
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                SwitchListTile(
                  title: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.pink, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.newFeatures,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      AppLocalizations.of(context)!.newFeaturesDesc,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
                  value: _newFeatures,
                  onChanged: (value) {
                    setState(() => _newFeatures = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(AppLocalizations.of(context)!.quietHours),
            const SizedBox(height: 8),
            _buildSection(
              isDark,
              children: [
                SwitchListTile(
                  title: Row(
                    children: [
                      Icon(Icons.volume_off, color: Colors.grey, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.dontDisturb,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      AppLocalizations.of(context)!.dontDisturbDesc,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
                  value: _quietHoursEnabled,
                  onChanged: (value) {
                    setState(() => _quietHoursEnabled = value);
                  },
                ),
                if (_quietHoursEnabled) ...[
                  const Divider(height: 1, indent: 56, endIndent: 16),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTimePicker(
                            isDark,
                            AppLocalizations.of(context)!.from,
                            _quietHoursFrom,
                            (time) {
                              setState(() => _quietHoursFrom = time);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTimePicker(
                            isDark,
                            AppLocalizations.of(context)!.to,
                            _quietHoursTo,
                            (time) {
                              setState(() => _quietHoursTo = time);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSection(bool isDark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTimePicker(
    bool isDark,
    String label,
    TimeOfDay time,
    Function(TimeOfDay) onChanged,
  ) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              '$hour:$minute $period',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
