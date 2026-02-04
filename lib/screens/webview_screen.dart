import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/branding_service.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _checkConnectivityAndInit();
  }

  Future<void> _checkConnectivityAndInit() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() { _hasError = true; _errorMessage = ''; _isLoading = false; });
      return;
    }
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() { _isLoading = true; _hasError = false; }),
          onProgress: (progress) => setState(() => _loadingProgress = progress),
          onPageFinished: (_) {
            setState(() => _isLoading = false);
            _injectBlockingScript();
          },
          onWebResourceError: (error) {
            // ไม่แสดง error สำหรับ resource ที่ไม่ใช่หน้าหลัก (เช่น รูปภาพ, scripts)
            if (error.isForMainFrame ?? true) {
              setState(() { _hasError = true; _errorMessage = error.description; _isLoading = false; });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            // บล็อก intent://, market://, app links ที่พยายามเปิดแอปอื่น
            if (url.startsWith('intent://') ||
                url.startsWith('market://') ||
                url.startsWith('app://') ||
                url.startsWith('aliapp://') ||
                url.startsWith('taobao://') ||
                url.contains('play.google.com/store')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _injectBlockingScript() {
    // Inject JavaScript เพื่อบล็อก app evoke และ popup เปิดแอป
    const script = '''
(function() {
  // ซ่อน popup Open in App และ banner ต่างๆ
  var style = document.createElement("style");
  style.textContent = "[class*=callapp],[class*=open-app],[class*=download-app],[class*=app-banner],[class*=smart-banner],[id*=callapp],[id*=open-app]{display:none!important;height:0!important;overflow:hidden!important;}";
  document.head.appendChild(style);

  // บล็อก link clicks ที่จะเปิดแอป
  document.addEventListener("click", function(e) {
    var a = e.target.closest("a");
    if (a && a.href) {
      var h = a.href.toLowerCase();
      if (h.indexOf("intent:") === 0 || h.indexOf("aliapp:") === 0 || h.indexOf("taobao:") === 0 || h.indexOf("market:") === 0) {
        e.preventDefault();
        e.stopPropagation();
        return false;
      }
    }
  }, true);

  // ลบ iframe ที่พยายามเปิดแอป
  setInterval(function() {
    var iframes = document.querySelectorAll("iframe");
    for (var i = 0; i < iframes.length; i++) {
      var src = iframes[i].src || "";
      if (src.indexOf("intent:") === 0 || src.indexOf("aliapp:") === 0) {
        iframes[i].parentNode.removeChild(iframes[i]);
      }
    }
  }, 300);

  // ปิด popup dialog ถ้ามี
  setInterval(function() {
    var dialogs = document.querySelectorAll("[class*=dialog],[class*=modal],[class*=popup]");
    for (var i = 0; i < dialogs.length; i++) {
      var text = dialogs[i].innerText || "";
      if (text.indexOf("App") > -1 && (text.indexOf("Open") > -1 || text.indexOf("Continue") > -1 || text.indexOf("Download") > -1)) {
        dialogs[i].style.display = "none";
        var closeBtn = dialogs[i].querySelector("[class*=close]");
        if (closeBtn) closeBtn.click();
      }
    }
  }, 500);
})();
''';
    _controller?.runJavaScript(script);
  }

  Future<void> _refresh() async {
    if (_controller == null) {
      _checkConnectivityAndInit();
      return;
    }
    setState(() { _hasError = false; _isLoading = true; });
    await _controller!.reload();
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(children: [Icon(Icons.logout, color: BrandingService.primaryColor), SizedBox(width: 10), Text(AppLocalizations.of(context)!.exit)]),
        content: Text(AppLocalizations.of(context)!.exitConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.grey[600]))),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); Navigator.pop(context); },
            style: ElevatedButton.styleFrom(backgroundColor: BrandingService.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text(AppLocalizations.of(context)!.confirm, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(_errorMessage.isEmpty ? AppLocalizations.of(context)!.noInternet : '${AppLocalizations.of(context)!.failedToLoadPage}\n$_errorMessage', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _checkConnectivityAndInit,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.tryAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor: BrandingService.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.grey[600]),
              label: Text(AppLocalizations.of(context)!.chooseDifferentUrl, style: TextStyle(color: Colors.grey[600])),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller != null && await _controller!.canGoBack()) { await _controller!.goBack(); return false; }
        _showExitDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                BrandingService.appName.isNotEmpty ? BrandingService.appName[0] : 'W',
                style: TextStyle(color: BrandingService.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(widget.url.replaceAll('https://', '').replaceAll('http://', ''), style: const TextStyle(fontSize: 14, color: Colors.white), overflow: TextOverflow.ellipsis)),
          ]),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh, tooltip: AppLocalizations.of(context)!.refresh),
            IconButton(icon: const Icon(Icons.logout), onPressed: _showExitDialog, tooltip: AppLocalizations.of(context)!.exit),
          ],
        ),
        body: Stack(children: [
          if (_hasError || _controller == null) _buildErrorWidget() else WebViewWidget(controller: _controller!),
          if (_isLoading) Column(children: [
            LinearProgressIndicator(
              value: _loadingProgress / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(BrandingService.primaryColor),
            ),
          ]),
        ]),
      ),
    );
  }
}
