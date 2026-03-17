import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../api/payments_api.dart';

/// Результат покупки/восстановления для UI.
enum IapResult {
  success,
  cancelled,
  error,
  notAvailable,
}

/// Сервис покупок в приложении (Google Play / App Store).
/// Загружает продукты, запускает покупку, восстанавливает покупки и верифицирует их на бэкенде.
class IapService {
  IapService._();
  static final IapService _instance = IapService._();
  static IapService get instance => _instance;

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Completer<IapResult>? _purchaseCompleter;

  bool _initialized = false;
  List<ProductDetails> _products = [];
  List<String> get productIds => IapProductIds.allIds;

  Future<bool> isAvailable() async => _initialized && await _iap.isAvailable();
  List<ProductDetails> get products => List.unmodifiable(_products);

  /// Инициализация и подписка на поток покупок. Вызвать при старте приложения (например, перед открытием экрана подписки).
  Future<bool> initialize() async {
    if (_initialized) return await _iap.isAvailable();
    final available = await _iap.isAvailable();
    if (!available) {
      if (kDebugMode) debugPrint('[IAP] Store not available');
      _initialized = true;
      return false;
    }
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdates,
      onDone: () => _subscription?.cancel(),
      onError: (e) {
        if (kDebugMode) debugPrint('[IAP] Stream error: $e');
        _purchaseCompleter?.complete(IapResult.error);
      },
    );
    _initialized = true;
    return true;
  }

  void _onPurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.canceled:
          _purchaseCompleter?.complete(IapResult.cancelled);
          _iap.completePurchase(purchase);
          break;
        case PurchaseStatus.error:
          if (kDebugMode) {
            debugPrint('[IAP] Purchase error: ${purchase.error}');
          }
          _purchaseCompleter?.complete(IapResult.error);
          _iap.completePurchase(purchase);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _verifyAndComplete(purchase);
          break;
      }
    }
  }

  Future<void> _verifyAndComplete(PurchaseDetails purchase) async {
    final verificationData = purchase.verificationData.serverVerificationData;
    final productId = purchase.productID;
    if (verificationData.isEmpty) {
      if (kDebugMode) debugPrint('[IAP] No serverVerificationData');
      _purchaseCompleter?.complete(IapResult.error);
      _iap.completePurchase(purchase);
      return;
    }
    bool ok = false;
    if (Platform.isIOS) {
      ok = await PaymentsApi.verifyApple(verificationData);
    } else if (Platform.isAndroid) {
      ok = await PaymentsApi.verifyGoogle(
        purchaseToken: verificationData,
        productId: productId,
      );
    }
    if (kDebugMode) {
      debugPrint('[IAP] Verify ${Platform.isIOS ? "Apple" : "Google"} result: $ok');
    }
    final completer = _purchaseCompleter;
    _purchaseCompleter = null;
    completer?.complete(ok ? IapResult.success : IapResult.error);
    _iap.completePurchase(purchase);
  }

  /// Загрузить продукты по ID из [IapProductIds.allIds].
  Future<bool> loadProducts() async {
    if (!_initialized) await initialize();
    if (!await _iap.isAvailable()) {
      _products = [];
      return false;
    }
    final response = await _iap.queryProductDetails(productIds.toSet());
    if (response.notFoundIDs.isNotEmpty && kDebugMode) {
      debugPrint('[IAP] Not found: ${response.notFoundIDs}');
    }
    _products = response.productDetails;
    return _products.isNotEmpty;
  }

  /// Запустить покупку подписки по [productId]. Цена берётся из магазина.
  /// Возвращает [IapResult] по завершении (success / cancelled / error / notAvailable).
  Future<IapResult> buy(String productId) async {
    if (!_initialized) await initialize();
    if (!await _iap.isAvailable()) return IapResult.notAvailable;
    ProductDetails? product;
    try {
      product = _products.firstWhere((p) => p.id == productId);
    } catch (_) {
      product = null;
    }
    if (product == null) {
      if (kDebugMode) debugPrint('[IAP] Product not loaded: $productId');
      return IapResult.error;
    }
    _purchaseCompleter = Completer<IapResult>();
    final param = PurchaseParam(productDetails: product);
    final submitted = await _iap.buyNonConsumable(purchaseParam: param);
    if (!submitted) {
      _purchaseCompleter?.complete(IapResult.error);
      return _purchaseCompleter!.future;
    }
    return _purchaseCompleter!.future;
  }

  /// Восстановить покупки (все активные подписки отправляются на бэкенд для верификации).
  Future<IapResult> restore() async {
    if (!_initialized) await initialize();
    if (!await _iap.isAvailable()) return IapResult.notAvailable;
    _purchaseCompleter = Completer<IapResult>();
    await _iap.restorePurchases();
    // restorePurchases() выдаст события в purchaseStream для каждой восстановленной покупки;
    // мы верифицируем каждую в _onPurchaseUpdates. Если хотя бы одна успешна — считаем success.
    // Таймаут: если за 15 сек не пришло ни одного restored — завершаем как success (ничего не было).
    final result = await _purchaseCompleter!.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => IapResult.success,
    );
    return result;
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
