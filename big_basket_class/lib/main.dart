import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'services/settings_service.dart';
import 'utils/animations.dart';

import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/category/category_screen.dart';
import 'screens/product/product_list_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'services/cart_service.dart';
import 'services/user_service.dart';
import 'services/order_service.dart';
import 'services/otp_service.dart';
import 'services/admin_service.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/address_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/profile/wishlist_screen.dart';
import 'screens/offers/offers_screen.dart';
import 'screens/support/help_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/orders/order_tracking_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAZnqP7TgslQbNUpOQFsPrJYk6PHZSlZoU',
      appId: '1:988051681969:web:6fb8cfac833bf04ffe2890',
      messagingSenderId: '988051681969',
      projectId: 'bigbasketclass',
      authDomain: 'bigbasketclass.firebaseapp.com',
      storageBucket: 'bigbasketclass.appspot.com',
      measurementId: 'G-PY40PR664M',
    ),
  );
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  
  // Initialize admin account (non-blocking - don't wait for it)
  final adminService = AdminService();
  adminService.initializeAdminAccount().catchError((e) {
    print('Admin initialization error (non-critical): $e');
  });
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartService()),
        ChangeNotifierProvider(create: (context) => UserService()),
        ChangeNotifierProvider(create: (context) => OrderService()),
        ChangeNotifierProvider(create: (context) => OTPService()),
        ChangeNotifierProvider(create: (context) => SettingsService()),
        ChangeNotifierProvider(create: (context) => AdminService()),
      ],
      child: Consumer<SettingsService>(
        builder: (context, settings, _) => MaterialApp(
          title: 'Big Basket',
          themeMode: settings.themeMode,
          theme: ThemeData(
            primarySwatch: Colors.green,
            fontFamily: 'Roboto',
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme:
                ThemeData.dark().colorScheme.copyWith(primary: Colors.green),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => SplashScreen(),
            '/welcome': (context) => WelcomeScreen(),
            '/login': (context) => LoginScreen(),
            '/signup': (context) => SignupScreen(),
            '/home': (context) => MainNavigationScreen(),
            '/categories': (context) => CategoryScreen(),
            '/product-list': (context) => ProductListScreen(),
            '/search': (context) => SearchScreen(),
            '/notifications': (context) => NotificationsScreen(),
            '/cart': (context) => CartScreen(),
            '/profile': (context) => ProfileScreen(),
            '/addresses': (context) => AddressScreen(),
            '/orders': (context) => OrdersScreen(),
            '/wishlist': (context) => WishlistScreen(),
            '/offers': (context) => OffersScreen(),
            '/help': (context) => HelpScreen(),
            '/settings': (context) => SettingsScreen(),
            '/order-tracking': (context) => OrderTrackingScreen(),
            // '/order-details': (context) => OrderDetailsScreen(), // Requires order parameter
            '/checkout': (context) => CheckoutScreen(),
            '/admin-login': (context) => AdminLoginScreen(),
            '/admin-dashboard': (context) => AdminDashboard(),
          },
        ),
      ),
    );
  }
}
