import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Requests gallery/photo-library permission before opening the image picker.
/// Returns [true] if permission is granted, [false] otherwise.
class GalleryPermissionHelper {
  GalleryPermissionHelper._();

  static Future<bool> requestAndCheck(BuildContext context) async {
    final permission = _galleryPermission;
    final status = await permission.status;

    if (status.isGranted || status.isLimited) return true;

    if (status.isPermanentlyDenied) {
      if (context.mounted) await _showSettingsDialog(context);
      return false;
    }

    final result = await permission.request();
    if (result.isGranted || result.isLimited) return true;

    if (result.isPermanentlyDenied && context.mounted) {
      await _showSettingsDialog(context);
    }
    return false;
  }

  static Permission get _galleryPermission {
    if (Platform.isAndroid) {
      // Android 13+ uses READ_MEDIA_IMAGES; older uses READ_EXTERNAL_STORAGE.
      return Permission.photos;
    }
    return Permission.photos;
  }

  static Future<void> _showSettingsDialog(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'permissions.gallery_title'.tr(),
          style: tt.titleMedium?.copyWith(color: cs.onSurface),
        ),
        content: Text(
          'permissions.gallery_message'.tr(),
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'common.cancel'.tr(),
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              openAppSettings();
            },
            child: Text('permissions.open_settings'.tr()),
          ),
        ],
      ),
    );
  }
}
