import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'api_service.dart';

class IAPService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  
  // Product IDs - ต้องตรงกับที่ตั้งใน Play Store / App Store
  static const String monthlyProductId = 'webgo_monthly_sub';
  static const String quarterlyProductId = 'webgo_quarterly_sub';
  static const String semiAnnualProductId = 'webgo_semiannual_sub';
  static const String yearlyProductId = 'webgo_yearly_sub';

  // Pro Product IDs (up to 5 devices)
  static const String proMonthlyProductId = 'webgo_pro_monthly_sub';
  static const String proYearlyProductId = 'webgo_pro_yearly_sub';

  static final Set<String> _productIds = {
    monthlyProductId,
    quarterlyProductId,
    semiAnnualProductId,
    yearlyProductId,
    proMonthlyProductId,
    proYearlyProductId,
  };
  
  static List<ProductDetails> products = [];
  static bool isAvailable = false;
  
  // Current user email for verification
  static String? userEmail;

  // Callbacks
  static Function(PurchaseDetails)? onPurchaseSuccess;
  static Function(String)? onPurchaseError;

  // Initialize IAP
  static Future<void> init() async {
    isAvailable = await _iap.isAvailable();
    
    if (!isAvailable) {
      debugPrint('IAP not available');
      return;
    }
    
    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (error) => debugPrint('IAP Error: $error'),
    );
    
    // Load products
    await loadProducts();
  }
  
  // Load products from store
  static Future<void> loadProducts() async {
    if (!isAvailable) return;
    
    final response = await _iap.queryProductDetails(_productIds);
    
    if (response.error != null) {
      debugPrint('Error loading products: ${response.error}');
      return;
    }
    
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }
    
    products = response.productDetails;
    debugPrint('Loaded ${products.length} products');
  }

  // Handle purchase updates
  static void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      _handlePurchase(purchase);
    }
  }
  
  static Future<void> _handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.pending) {
      debugPrint('Purchase pending...');
      return;
    }
    
    if (purchase.status == PurchaseStatus.error) {
      onPurchaseError?.call(purchase.error?.message ?? 'Purchase failed');
      return;
    }
    
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      
      // Verify purchase on server
      final valid = await _verifyPurchase(purchase);
      
      if (valid) {
        onPurchaseSuccess?.call(purchase);
      } else {
        onPurchaseError?.call('Purchase verification failed');
      }
    }
    
    // Complete purchase
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }
  
  // Verify purchase receipt with server (Google Play / App Store)
  static Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    try {
      debugPrint('Verifying purchase: ${purchase.productID}');
      debugPrint('Platform: ${Platform.isAndroid ? "android" : "ios"}');

      final result = await ApiService.verifyPurchaseReceipt(
        email: userEmail ?? '',
        productId: purchase.productID,
        receiptData: purchase.verificationData.serverVerificationData,
        platform: Platform.isAndroid ? 'android' : 'ios',
      );

      debugPrint('Verify result: $result');
      return result['success'] == true;
    } catch (e) {
      debugPrint('Verify error: $e');
      return false;
    }
  }
  
  // Buy subscription
  static Future<bool> buySubscription(String productId) async {
    if (!isAvailable) {
      onPurchaseError?.call('Store not available');
      return false;
    }
    
    final product = products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found'),
    );
    
    final purchaseParam = PurchaseParam(productDetails: product);
    
    try {
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      onPurchaseError?.call('Purchase error: $e');
      return false;
    }
  }

  // Restore purchases
  static Future<void> restorePurchases() async {
    if (!isAvailable) return;
    await _iap.restorePurchases();
  }
  
  // Get product by ID
  static ProductDetails? getProduct(String productId) {
    try {
      return products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }
  
  // Get products
  static ProductDetails? get monthlyProduct => getProduct(monthlyProductId);
  static ProductDetails? get quarterlyProduct => getProduct(quarterlyProductId);
  static ProductDetails? get semiAnnualProduct => getProduct(semiAnnualProductId);
  static ProductDetails? get yearlyProduct => getProduct(yearlyProductId);
  static ProductDetails? get proMonthlyProduct => getProduct(proMonthlyProductId);
  static ProductDetails? get proYearlyProduct => getProduct(proYearlyProductId);
  
  // Dispose
  static void dispose() {
    _subscription?.cancel();
  }
}
