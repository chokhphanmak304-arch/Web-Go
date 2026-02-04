import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/branding_service.dart';

class BrandingScreen extends StatefulWidget {
  const BrandingScreen({super.key});

  @override
  State<BrandingScreen> createState() => _BrandingScreenState();
}

class _BrandingScreenState extends State<BrandingScreen> {
  final _nameController = TextEditingController();
  int _selectedColor = BrandingService.colorValue;
  String? _logoPath = BrandingService.logoPath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = BrandingService.appName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.chooseLogoImage,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.blue[600], size: 26),
                  ),
                  title: Text(AppLocalizations.of(context)!.takePhoto, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(AppLocalizations.of(context)!.useCamera),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickFromCamera();
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.photo_library, color: Colors.green[600], size: 26),
                  ),
                  title: Text(AppLocalizations.of(context)!.photoGallery, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(AppLocalizations.of(context)!.chooseFromLibrary),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickFromGallery();
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.folder_open, color: Colors.orange[600], size: 26),
                  ),
                  title: Text(AppLocalizations.of(context)!.browseFiles, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(AppLocalizations.of(context)!.chooseFromFiles),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickFromFile();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera, maxWidth: 512, maxHeight: 512);
    if (image != null) {
      final path = await BrandingService.saveLogo(File(image.path));
      setState(() => _logoPath = path);
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512);
    if (image != null) {
      final path = await BrandingService.saveLogo(File(image.path));
      setState(() => _logoPath = path);
    }
  }

  Future<void> _pickFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final path = await BrandingService.saveLogo(file);
      setState(() => _logoPath = path);
    }
  }

  Future<void> _removeLogo() async {
    await BrandingService.clearLogo();
    setState(() => _logoPath = null);
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await BrandingService.saveAppName(_nameController.text);
    await BrandingService.saveColor(_selectedColor);
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.brandingSaved),
          backgroundColor: Color(_selectedColor),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _resetToDefault() async {
    await BrandingService.resetToDefault();
    setState(() {
      _nameController.text = BrandingService.defaultAppName;
      _selectedColor = BrandingService.defaultColorValue;
      _logoPath = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.resetToDefaultBranding)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(_selectedColor);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.customizeApp, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Card
            _buildPreviewCard(color),
            const SizedBox(height: 30),

            // App Name
            Text(AppLocalizations.of(context)!.appName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterAppName,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color, width: 2),
                ),
                prefixIcon: Icon(Icons.edit, color: color),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // App Color
            Text(AppLocalizations.of(context)!.appColor, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 12),
            _buildColorPicker(),
            const SizedBox(height: 24),

            // App Logo
            Text(AppLocalizations.of(context)!.appLogo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 12),
            _buildLogoPicker(color),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(AppLocalizations.of(context)!.saveChanges, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),

            // Reset Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _resetToDefault,
                child: Text(AppLocalizations.of(context)!.resetToDefault, style: TextStyle(color: Colors.grey[600])),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard(Color color) {
    final name = _nameController.text.trim().isEmpty ? BrandingService.defaultAppName : _nameController.text.trim();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Mock AppBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: color,
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text(name.isNotEmpty ? name[0] : 'W', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const SizedBox(width: 8),
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  const Icon(Icons.settings, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Icon(Icons.logout, color: Colors.white, size: 20),
                ],
              ),
            ),
            // Mock body
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[50],
              child: Column(
                children: [
                  _buildLogoPreview(40),
                  const SizedBox(height: 8),
                  Text(AppLocalizations.of(context)!.preview, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoPreview(double size) {
    if (_logoPath != null && File(_logoPath!).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(File(_logoPath!), width: size, height: size, fit: BoxFit.contain),
      );
    }
    return Image.asset(BrandingService.defaultLogoAsset, width: size, height: size, fit: BoxFit.contain);
  }

  Widget _buildColorPicker() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: BrandingService.presetColors.map((bc) {
        final isSelected = _selectedColor == bc.value;
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = bc.value),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bc.color,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
              boxShadow: isSelected ? [BoxShadow(color: bc.color.withOpacity(0.5), blurRadius: 8)] : null,
            ),
            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 24) : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLogoPicker(Color color) {
    return Row(
      children: [
        // Current logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildLogoPreview(80),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: _pickLogo,
                icon: const Icon(Icons.image, size: 18),
                label: Text(AppLocalizations.of(context)!.chooseLogo),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              if (_logoPath != null) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _removeLogo,
                  icon: const Icon(Icons.close, size: 16),
                  label: Text(AppLocalizations.of(context)!.removeCustomLogo),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
