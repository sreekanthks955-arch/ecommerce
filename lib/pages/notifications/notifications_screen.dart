import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controllers.dart';
import '../../services/app_theme.dart';
import '../../widgets/shop_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifCtrl = Get.find<NotificationController>();
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Obx(() {
            if (notifCtrl.unreadCount > 0) {
              return TextButton(
                onPressed: notifCtrl.markAllAsRead,
                child: const Text('Mark all read'),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (notifCtrl.notifications.isEmpty) {
          return const EmptyState(
            title: 'No notifications',
            message: 'You are all caught up! Check back for updates.',
            icon: Icons.notifications_none_outlined,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          itemCount: notifCtrl.notifications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = notifCtrl.notifications[index];
            final unread = !item.isRead;

            return InkWell(
              onTap: () => notifCtrl.markAsRead(item.id),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? (unread ? const Color(0xFF1E283E) : AppTheme.darkCard)
                      : (unread ? const Color(0xFFF2F5FF) : Colors.white),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: unread
                        ? AppTheme.blue.withValues(alpha: 0.3)
                        : (isDark ? AppTheme.darkBorder : AppTheme.border),
                    width: unread ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: item.isOrder
                          ? (isDark
                              ? const Color(0xFF1E3A8A)
                              : const Color(0xFFE0E7FF))
                          : (isDark
                              ? const Color(0xFF3730A3)
                              : const Color(0xFFEDE9FE)),
                      child: Icon(
                        item.icon,
                        size: 20,
                        color: item.isOrder ? AppTheme.blue : AppTheme.purple,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontWeight: unread
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    fontSize: 14,
                                    color: AppTheme.textColor(context),
                                  ),
                                ),
                              ),
                              Text(
                                item.time,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.muted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.message,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppTheme.subtleColor(context),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (unread) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: const BoxDecoration(
                          color: AppTheme.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
