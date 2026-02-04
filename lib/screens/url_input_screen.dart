import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/branding_service.dart';
import '../services/language_service.dart';
import 'webview_screen.dart';
import 'login_screen.dart';
import 'subscription_screen.dart';
import 'branding_screen.dart';

class UrlInputScreen extends StatefulWidget {
  const UrlInputScreen({super.key});

  @override
  State<UrlInputScreen> createState() => _UrlInputScreenState();
}

class _UrlInputScreenState extends State<UrlInputScreen> {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> _recentUrls = [];
  bool _isLoading = true;
  String? _userEmail;
  SubscriptionInfo? _subscription;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = await AuthService.getCurrentUserEmail();

    // ใช้ key ที่แยกตาม email เพื่อให้แต่ละ user มีประวัติของตัวเอง
    final recentUrlsKey = email != null ? 'recent_urls_$email' : 'recent_urls';

    setState(() {
      _recentUrls = prefs.getStringList(recentUrlsKey) ?? [];
      _userEmail = email;
    });
    
    if (email != null) {
      final result = await ApiService.checkSubscription(email);
      if (result['success'] && result['subscription'] != null) {
        setState(() {
          _subscription = SubscriptionInfo.fromJson(result['subscription']);
        });
      }
    }
    
    setState(() => _isLoading = false);

    // Check if subscription expired and force renewal
    _checkExpiredAndShowDialog();
  }

  void _checkExpiredAndShowDialog() {
    if (_subscription != null && _subscription!.isExpired && _userEmail != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showExpiredForceDialog();
      });
    }
  }

  void _showExpiredForceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber, color: Colors.red, size: 28),
              const SizedBox(width: 10),
              Flexible(child: Text(AppLocalizations.of(context)!.membershipExpired)),
            ],
          ),
          content: Text(AppLocalizations.of(context)!.membershipExpiredMessage),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubscriptionScreen(
                        email: _userEmail!,
                        currentSubscription: _subscription,
                      ),
                    ),
                  );
                  if (result == true) {
                    _loadData();
                  } else {
                    _checkExpiredAndShowDialog();
                  }
                },
                icon: const Icon(Icons.workspace_premium, color: Colors.white),
                label: Text(AppLocalizations.of(context)!.renewPackage, style: const TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: BrandingService.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    // ใช้ key ที่แยกตาม email เพื่อให้แต่ละ user มีประวัติของตัวเอง
    final recentUrlsKey = _userEmail != null ? 'recent_urls_$_userEmail' : 'recent_urls';
    _recentUrls.remove(url);
    _recentUrls.insert(0, url);
    if (_recentUrls.length > 5) _recentUrls = _recentUrls.sublist(0, 5);
    await prefs.setStringList(recentUrlsKey, _recentUrls);
  }

  Future<void> _deleteUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final recentUrlsKey = _userEmail != null ? 'recent_urls_$_userEmail' : 'recent_urls';
    setState(() {
      _recentUrls.remove(url);
    });
    await prefs.setStringList(recentUrlsKey, _recentUrls);
  }

  void _showDeleteConfirmDialog(String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            const SizedBox(width: 10),
            Text(AppLocalizations.of(context)!.deleteHistory),
          ],
        ),
        content: Text(AppLocalizations.of(context)!.deleteHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUrl(url);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatUrl(String url) {
    url = url.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    return url;
  }

  void _navigateToWebView(String url) async {
    if (_subscription == null || !_subscription!.isActive) {
      _showSubscriptionRequired();
      return;
    }
    
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final formattedUrl = _formatUrl(url);
      await _saveUrl(formattedUrl);
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => WebViewScreen(url: formattedUrl)),
      );
    }
  }

  void _showSubscriptionRequired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.orange, size: 28),
            const SizedBox(width: 10),
            Text(AppLocalizations.of(context)!.subscriptionRequired),
          ],
        ),
        content: Text(AppLocalizations.of(context)!.subscriptionExpiredMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openSubscriptionScreen();
            },
            style: ElevatedButton.styleFrom(backgroundColor: BrandingService.primaryColor),
            child: Text(AppLocalizations.of(context)!.viewPlans, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openSubscriptionScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubscriptionScreen(
          email: _userEmail!,
          currentSubscription: _subscription,
        ),
      ),
    );
    if (result == true) {
      _loadData();
    }
  }

  void _openBrandingScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BrandingScreen()),
    );
    if (result == true) {
      await BrandingService.forceReload();
      setState(() {});
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.logout, color: BrandingService.primaryColor),
            SizedBox(width: 10),
            Text(AppLocalizations.of(context)!.signOut),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.signOutConfirm),
            if (_userEmail != null) ...[
              const SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.account(_userEmail!), style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService.logout();
              if (!mounted) return;
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(AppLocalizations.of(context)!.signOut, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final horizontalPadding = isTablet ? size.width * 0.15 : 24.0;

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: BrandingService.primaryColor)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: BrandingService.primaryColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: BrandingService.primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(BrandingService.appName.isNotEmpty ? BrandingService.appName[0] : 'W', style: TextStyle(color: BrandingService.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(width: 10),
            Flexible(child: Text(BrandingService.appName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          // Language Switcher
          PopupMenuButton<String>(
            icon: const Icon(Icons.translate, color: Colors.white),
            tooltip: AppLocalizations.of(context)!.changeLanguage,
            onSelected: (lang) {
              LanguageService().setLocale(Locale(lang));
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    Icon(Icons.check, color: LanguageService().isEnglish ? BrandingService.primaryColor : Colors.transparent, size: 20),
                    const SizedBox(width: 8),
                    const Text('🇺🇸  English'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'th',
                child: Row(
                  children: [
                    Icon(Icons.check, color: LanguageService().isThai ? BrandingService.primaryColor : Colors.transparent, size: 20),
                    const SizedBox(width: 8),
                    const Text('🇹🇭  ไทย'),
                  ],
                ),
              ),
            ],
          ),
          if (_userEmail != null) ...[
            if (_subscription?.isActive == true)
              IconButton(
                icon: const Icon(Icons.palette, color: Colors.white),
                onPressed: _openBrandingScreen,
                tooltip: AppLocalizations.of(context)!.customize,
              ),
            IconButton(
              icon: const Icon(Icons.workspace_premium, color: Colors.white),
              onPressed: _openSubscriptionScreen,
              tooltip: AppLocalizations.of(context)!.subscription,
            ),
            IconButton(
              onPressed: _showLogoutDialog,
              icon: const Icon(Icons.logout, color: Colors.white, size: 20),
              tooltip: AppLocalizations.of(context)!.signOut,
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_subscription != null) _buildSubscriptionCard(isTablet),
                const SizedBox(height: 20),
                if (_userEmail != null) _buildUserBadge(),
                const SizedBox(height: 20),
                _buildTitle(isTablet),
                const SizedBox(height: 40),
                _buildUrlInput(isTablet),
                const SizedBox(height: 25),
                _buildConnectButton(isTablet),
                if (_recentUrls.isNotEmpty) _buildRecentUrls(isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(bool isTablet) {
    final sub = _subscription!;
    final Color statusColor = sub.isActive ? Colors.green : Colors.red;
    final Color bgColor = sub.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1);
    
    return InkWell(
      onTap: _openSubscriptionScreen,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              sub.isActive ? Icons.check_circle : Icons.warning,
              color: statusColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.isTrial ? AppLocalizations.of(context)!.freeTrialPlan : (sub.planType == 'monthly' ? AppLocalizations.of(context)!.monthlyPlan : AppLocalizations.of(context)!.yearlyPlan),
                    style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
                  ),
                  Text(
                    sub.isActive ? AppLocalizations.of(context)!.daysRemaining(sub.daysRemaining) : AppLocalizations.of(context)!.subscriptionExpired,
                    style: TextStyle(fontSize: 12, color: statusColor.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: statusColor, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildUserBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: BrandingService.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, size: 18, color: BrandingService.primaryColor),
            const SizedBox(width: 8),
            Text(
              _userEmail!,
              style: TextStyle(color: BrandingService.primaryColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(bool isTablet) {
    return Center(
      child: Image.asset(
        'assets/logo_odoo.png',
        width: isTablet ? 220 : 180,
        height: isTablet ? 220 : 180,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTitle(bool isTablet) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.connectToWebsite,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isTablet ? 32 : 26,
            fontWeight: FontWeight.bold,
            color: BrandingService.primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppLocalizations.of(context)!.enterUrlToStart,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isTablet ? 18 : 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildUrlInput(bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: BrandingService.primaryColor.withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: _urlController,
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.go,
        onFieldSubmitted: _navigateToWebView,
        style: TextStyle(fontSize: isTablet ? 18 : 16),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.urlHint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(
            Icons.link,
            color: BrandingService.primaryColor,
            size: isTablet ? 28 : 24,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.grey[400]),
            onPressed: () => _urlController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: BrandingService.primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: isTablet ? 20 : 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.pleaseEnterUrl;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildConnectButton(bool isTablet) {
    return SizedBox(
      height: isTablet ? 60 : 50,
      child: ElevatedButton(
        onPressed: () => _navigateToWebView(_urlController.text),
        style: ElevatedButton.styleFrom(
          backgroundColor: BrandingService.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login, size: isTablet ? 26 : 22),
            const SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)!.connect,
              style: TextStyle(
                fontSize: isTablet ? 20 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentUrls(bool isTablet) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          children: [
            Icon(Icons.history, color: Colors.grey[600], size: 20),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.recent,
              style: TextStyle(
                fontSize: isTablet ? 18 : 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ...List.generate(_recentUrls.length, (index) {
          final url = _recentUrls[index];
          return _buildRecentUrlItem(url, isTablet);
        }),
      ],
    );
  }

  Widget _buildRecentUrlItem(String url, bool isTablet) {
    return Dismissible(
      key: Key(url),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Row(
              children: [
                const Icon(Icons.delete_outline, color: Colors.red),
                const SizedBox(width: 10),
                Text(AppLocalizations.of(context)!.deleteHistory),
              ],
            ),
            content: Text(AppLocalizations.of(context)!.deleteHistoryConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.grey[600])),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => _deleteUrl(url),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () {
            _urlController.text = url;
            _navigateToWebView(url);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isTablet ? 16 : 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.language, color: BrandingService.primaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    url,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.grey[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // ปุ่มลบ
                GestureDetector(
                  onTap: () => _showDeleteConfirmDialog(url),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(Icons.close, color: Colors.grey[400], size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
