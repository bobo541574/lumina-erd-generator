import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../domain/services/export_service.dart';

class PreviewPane extends StatelessWidget {
  final String content;
  final ExportFormat format;
  final String projectName;

  const PreviewPane({
    super.key,
    required this.content,
    required this.format,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToolbar(context),
        Expanded(child: _buildCodeView(context)),
      ],
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Icon(Icons.code, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            '${format.displayName} Preview',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${content.length} chars',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Spacer(),
          _buildActionChip(
            context,
            icon: Icons.copy,
            label: 'Copy',
            onPressed: () => _copyToClipboard(context),
          ),
          const SizedBox(width: 8),
          _buildActionChip(
            context,
            icon: Icons.save_alt,
            label: 'Save',
            onPressed: () => _saveToFile(context),
          ),
          if (format == ExportFormat.html) ...[
            const SizedBox(width: 8),
            _buildActionChip(
              context,
              icon: Icons.open_in_new,
              label: 'Open',
              onPressed: () => _openInBrowser(context),
              isPrimary: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    if (isPrimary) {
      return FilledButton.tonalIcon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildCodeView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          content,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            height: 1.5,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${format.displayName} copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveToFile(BuildContext context) async {
    final fileName = ExportService.getFileName(projectName, format);

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save ${format.displayName} File',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: [format.extension.replaceAll('.', '')],
    );

    if (result == null) return;

    try {
      await File(result).writeAsString(content);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to $result'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving file: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _openInBrowser(BuildContext context) async {
    final tempDir = await Directory.systemTemp.createTemp('erd_export_');
    final file = File('${tempDir.path}/erd_preview.html');
    await file.writeAsString(content);

    try {
      if (Platform.isMacOS) {
        await Process.run('open', [file.path]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [file.path]);
      } else if (Platform.isWindows) {
        await Process.run('start', [file.path]);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open browser: $e')));
      }
    }
  }
}
