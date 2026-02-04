import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/api_service.dart';
import '../services/iap_service.dart';
import '../services/branding_service.dart';

class SubscriptionScreen extends StatefulWidget {
  final String email;
  final SubscriptionInfo? currentSubscription;
  
  const SubscriptionScreen({super.key, required this.email, this.currentSubscription});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isLoading = true;
  bool _isProcessing = false;
  String? _selectedPlan;
  final _testCodeController = TextEditingController();
  bool _isActivatingCode = false;

  @override
  void initState() {
    super.initState();
    _initIAP();
  }

  Future<void> _initIAP() async {
    await IAPService.init();

    // Set user email for receipt verification
    IAPService.userEmail = widget.email;

    // Set callbacks
    IAPService.onPurchaseSuccess = _onPurchaseSuccess;
    IAPService.onPurchaseError = _onPurchaseError;

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _testCodeController.dispose();
    super.dispose();
  }

  void _onPurchaseSuccess(PurchaseDetails purchase) async {
    setState(() => _isProcessing = false);
    
    // Save subscription to server
    String planType;
    if (purchase.productID == IAPService.monthlyProductId) {
      planType = 'monthly';
    } else if (purchase.productID == IAPService.quarterlyProductId) {
      planType = 'quarterly';
    } else if (purchase.productID == IAPService.semiAnnualProductId) {
      planType = 'semiannual';
    } else if (purchase.productID == IAPService.proMonthlyProductId) {
      planType = 'pro_monthly';
    } else if (purchase.productID == IAPService.proYearlyProductId) {
      planType = 'pro_yearly';
    } else {
      planType = 'yearly';
    }
    
    await ApiService.processPayment(
      email: widget.email,
      planType: planType,
      transactionId: purchase.purchaseID ?? 'TXN_${DateTime.now().millisecondsSinceEpoch}',
    );
    
    if (!mounted) return;
    _showSuccessDialog(planType);
  }

  String _localizedPlanType(BuildContext context, String planType) {
    final l10n = AppLocalizations.of(context)!;
    switch (planType) {
      case 'monthly': return l10n.monthly;
      case 'quarterly': return l10n.threeMonths;
      case 'semiannual': return l10n.sixMonths;
      case 'yearly': return l10n.yearly;
      case 'pro_monthly': return l10n.proMonthly;
      case 'pro_yearly': return l10n.proYearly;
      default: return l10n.yearly;
    }
  }

  void _onPurchaseError(String error) {
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error), backgroundColor: Colors.red),
    );
  }

  Future<void> _subscribe() async {
    if (_selectedPlan == null) return;
    
    setState(() => _isProcessing = true);
    
    String productId;
    switch (_selectedPlan) {
      case 'monthly':
        productId = IAPService.monthlyProductId;
        break;
      case 'quarterly':
        productId = IAPService.quarterlyProductId;
        break;
      case 'semiannual':
        productId = IAPService.semiAnnualProductId;
        break;
      case 'pro_monthly':
        productId = IAPService.proMonthlyProductId;
        break;
      case 'pro_yearly':
        productId = IAPService.proYearlyProductId;
        break;
      default:
        productId = IAPService.yearlyProductId;
    }

    final success = await IAPService.buySubscription(productId);
    
    if (!success) {
      setState(() => _isProcessing = false);
    }
    // If success, callback will handle it
  }

  Future<void> _restorePurchases() async {
    setState(() => _isProcessing = true);
    await IAPService.restorePurchases();
    setState(() => _isProcessing = false);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.purchasesRestored), backgroundColor: Colors.green),
    );
  }

  Future<void> _activateTestCode() async {
    final code = _testCodeController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isActivatingCode = true);

    final result = await ApiService.activateTestCode(widget.email, code);

    if (!mounted) return;
    setState(() => _isActivatingCode = false);

    if (result['success'] == true) {
      _testCodeController.clear();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 10),
              Flexible(child: Text(AppLocalizations.of(context)!.success)),
            ],
          ),
          content: Text(AppLocalizations.of(context)!.testCodeActivated),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(backgroundColor: BrandingService.primaryColor),
              child: Text(AppLocalizations.of(context)!.continueBtn, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? AppLocalizations.of(context)!.invalidTestCode),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog(String planType) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 28),
            const SizedBox(width: 10),
            Text(AppLocalizations.of(context)!.success),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.subscriptionNowActive(_localizedPlanType(context, planType)),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: BrandingService.primaryColor),
            child: Text(AppLocalizations.of(context)!.continueBtn, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: BrandingService.primaryColor,
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.subscriptionPlans),
        actions: [
          TextButton(
            onPressed: _restorePurchases,
            child: Text(AppLocalizations.of(context)!.restore, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: BrandingService.primaryColor))
          : Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(isTablet ? 40 : 20),
                        child: Column(
                          children: [
                            if (widget.currentSubscription != null)
                              _buildCurrentStatusCard(isTablet),
                            const SizedBox(height: 20),
                            
                            // Store Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified_user, size: 16, color: Colors.green[700]),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(context)!.securePayment,
                                    style: TextStyle(color: Colors.green[700], fontSize: 11, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Features Comparison
                            _buildFeaturesSection(),
                            const SizedBox(height: 24),

                            // Monthly Plan
                            _buildPlanCard(
                              id: 'monthly',
                              product: IAPService.monthlyProduct,
                              isTablet: isTablet,
                            ),

                            // 3-Month Plan
                            _buildPlanCard(
                              id: 'quarterly',
                              product: IAPService.quarterlyProduct,
                              isTablet: isTablet,
                              savings: '10%',
                            ),

                            // 6-Month Plan
                            _buildPlanCard(
                              id: 'semiannual',
                              product: IAPService.semiAnnualProduct,
                              isTablet: isTablet,
                              savings: '15%',
                            ),

                            // Yearly Plan
                            _buildPlanCard(
                              id: 'yearly',
                              product: IAPService.yearlyProduct,
                              isTablet: isTablet,
                              savings: '25%',
                            ),

                            const SizedBox(height: 30),

                            // Pro Plans Section
                            _buildProSectionHeader(isTablet),
                            const SizedBox(height: 12),

                            // Pro Monthly
                            _buildPlanCard(
                              id: 'pro_monthly',
                              product: IAPService.proMonthlyProduct,
                              isTablet: isTablet,
                              isPro: true,
                            ),

                            // Pro Yearly
                            _buildPlanCard(
                              id: 'pro_yearly',
                              product: IAPService.proYearlyProduct,
                              isTablet: isTablet,
                              savings: '17%',
                              isPro: true,
                            ),

                            // Test Code Section (only in debug mode)
                            if (kDebugMode) ...[
                              const SizedBox(height: 30),
                              _buildTestCodeSection(isTablet),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (_selectedPlan != null) _buildSubscribeButton(isTablet),
                  ],
                ),
                if (_isProcessing)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(color: Colors.white),
                          const SizedBox(height: 16),
                          Text(AppLocalizations.of(context)!.processing, style: const TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: BrandingService.primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.whatYouGet,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: BrandingService.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context)!.compareFreeVsPremium,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Free features
          _buildFeatureHeader(AppLocalizations.of(context)!.freeTrial, Icons.person_outline, Colors.grey),
          const SizedBox(height: 8),
          _buildFeatureRow(Icons.check, AppLocalizations.of(context)!.access1Url, Colors.grey[600]!),
          _buildFeatureRow(Icons.check, AppLocalizations.of(context)!.basicWebview, Colors.grey[600]!),
          _buildFeatureRow(Icons.close, AppLocalizations.of(context)!.customBrandingDisabled, Colors.red[300]!, isDisabled: true),
          _buildFeatureRow(Icons.close, AppLocalizations.of(context)!.multipleUrlsDisabled, Colors.red[300]!, isDisabled: true),

          const Divider(height: 30),

          // Premium features
          _buildFeatureHeader(AppLocalizations.of(context)!.premiumSubscriber, Icons.workspace_premium, BrandingService.primaryColor),
          const SizedBox(height: 8),
          _buildFeatureRow(Icons.check_circle, AppLocalizations.of(context)!.unlimitedUrlAccess, Colors.green),
          _buildFeatureRow(Icons.check_circle, AppLocalizations.of(context)!.fullWebviewFeatures, Colors.green),
          _buildFeatureRow(Icons.check_circle, AppLocalizations.of(context)!.customAppName, Colors.green),
          _buildFeatureRow(Icons.check_circle, AppLocalizations.of(context)!.customAppLogo, Colors.green),
          _buildFeatureRow(Icons.check_circle, AppLocalizations.of(context)!.customAppColorTheme, Colors.green),
          _buildFeatureRow(Icons.check_circle, AppLocalizations.of(context)!.pickFromCameraGallery, Colors.green),
          _buildFeatureRow(Icons.check_circle, AppLocalizations.of(context)!.adFreeExperience, Colors.green),
          _buildFeatureRow(Icons.check_circle, AppLocalizations.of(context)!.earlyAccessNewFeatures, Colors.green),
        ],
      ),
    );
  }

  Widget _buildFeatureHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildFeatureRow(IconData icon, String text, Color color, {bool isDisabled = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 28),
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDisabled ? Colors.grey[400] : Colors.grey[700],
                decoration: isDisabled ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStatusCard(bool isTablet) {
    final sub = widget.currentSubscription!;
    final Color statusColor = sub.isActive ? Colors.green : Colors.red;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.currentPlan, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  sub.isActive ? AppLocalizations.of(context)!.active : AppLocalizations.of(context)!.expired,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(
                sub.isPro ? Icons.diamond : Icons.workspace_premium,
                color: sub.isPro ? Colors.deepPurple : BrandingService.primaryColor,
                size: 40,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          sub.isTrial ? AppLocalizations.of(context)!.freeTrialPlan : _localizedPlanType(context, sub.planType),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (sub.isPro) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(AppLocalizations.of(context)!.proBadge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      sub.isActive ? AppLocalizations.of(context)!.daysRemaining(sub.daysRemaining) : AppLocalizations.of(context)!.expired,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    if (sub.isPro)
                      Text(
                        AppLocalizations.of(context)!.upToDevices(sub.maxDevices),
                        style: TextStyle(color: Colors.deepPurple[400], fontSize: 12),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String id,
    required ProductDetails? product,
    required bool isTablet,
    String? savings,
    bool isPro = false,
  }) {
    final bool isSelected = _selectedPlan == id;
    final l10n = AppLocalizations.of(context)!;

    // Fallback prices if products not loaded yet
    final Map<String, String> fallbackPrices = {
      'monthly': '\$4.99',
      'quarterly': '\$13.49',
      'semiannual': '\$24.99',
      'yearly': '\$44.99',
      'pro_monthly': '\$9.99',
      'pro_yearly': '\$99.99',
    };
    final Map<String, String> titles = {
      'monthly': l10n.monthly,
      'quarterly': l10n.threeMonths,
      'semiannual': l10n.sixMonths,
      'yearly': l10n.yearly,
      'pro_monthly': l10n.proMonthly,
      'pro_yearly': l10n.proYearly,
    };
    final Map<String, String> durations = {
      'monthly': l10n.oneMonth,
      'quarterly': l10n.threeMonthsDuration,
      'semiannual': l10n.sixMonthsDuration,
      'yearly': l10n.oneYear,
      'pro_monthly': l10n.oneMonth,
      'pro_yearly': l10n.oneYear,
    };
    final String price = product?.price ?? fallbackPrices[id]!;
    final String title = titles[id]!;
    final String duration = durations[id]!;

    final Color borderColor = isSelected
        ? (isPro ? Colors.deepPurple : BrandingService.primaryColor)
        : Colors.grey.withOpacity(0.2);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: isPro ? Colors.deepPurple.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: borderColor,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedPlan = id),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(title, style: TextStyle(fontSize: isTablet ? 20 : 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        ),
                        if (isPro) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(l10n.proBadge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                        if (savings != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                            child: Text(l10n.savePct(savings), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Radio<String>(
                    value: id,
                    groupValue: _selectedPlan,
                    onChanged: (v) => setState(() => _selectedPlan = v),
                    activeColor: isPro ? Colors.deepPurple : BrandingService.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: isTablet ? 36 : 32,
                      fontWeight: FontWeight.bold,
                      color: isPro ? Colors.deepPurple : BrandingService.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('/ $duration', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (isPro) ...[
                Row(
                  children: [
                    Icon(Icons.devices, size: 16, color: Colors.deepPurple[400]),
                    const SizedBox(width: 6),
                    Text(
                      l10n.upToDevices(5),
                      style: TextStyle(color: Colors.deepPurple[400], fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              Text(
                id == 'yearly' ? l10n.bestValueBilled :
                id == 'semiannual' ? l10n.greatSavingsBilled :
                id == 'quarterly' ? l10n.saveMoreBilled :
                id == 'pro_monthly' ? l10n.proMonthlyBilled :
                id == 'pro_yearly' ? l10n.proYearlyBilled :
                l10n.billedMonthly,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              if (product == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.loadingFromStore,
                    style: TextStyle(color: Colors.orange[700], fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscribeButton(bool isTablet) {
    ProductDetails? product;
    switch (_selectedPlan) {
      case 'monthly':
        product = IAPService.monthlyProduct;
        break;
      case 'quarterly':
        product = IAPService.quarterlyProduct;
        break;
      case 'semiannual':
        product = IAPService.semiAnnualProduct;
        break;
      case 'pro_monthly':
        product = IAPService.proMonthlyProduct;
        break;
      case 'pro_yearly':
        product = IAPService.proYearlyProduct;
        break;
      default:
        product = IAPService.yearlyProduct;
    }
    final bool isProPlan = _selectedPlan?.startsWith('pro_') ?? false;
    final price = product?.price ?? '';
    
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.paymentSecured,
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (_isProcessing || product == null) ? null : _subscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isProPlan ? Colors.deepPurple : BrandingService.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  isProPlan
                    ? '${AppLocalizations.of(context)!.upgradeToPro} $price'
                    : AppLocalizations.of(context)!.subscribe(price),
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProSectionHeader(bool isTablet) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.withOpacity(0.1), Colors.purpleAccent.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.devices, color: Colors.deepPurple, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.proPlans,
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(l10n.proBadge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.proDescription(5),
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCodeSection(bool isTablet) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.vpn_key, color: Colors.orange[700], size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.haveTestCode,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _testCodeController,
                  decoration: InputDecoration(
                    hintText: l10n.enterTestCode,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    isDense: true,
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isActivatingCode ? null : _activateTestCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isActivatingCode
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(l10n.activateCode, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
