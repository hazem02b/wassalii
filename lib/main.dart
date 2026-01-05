import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'providers/settings_provider.dart';
import 'utils/app_localizations.dart';
import 'widgets/restart_widget.dart';
import 'screens/landing_page_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/signup_client_screen.dart';
import 'screens/signup_transporter_screen_clean.dart';
import 'screens/home_client_screen.dart';
import 'screens/transporter_dashboard_screen.dart';
import 'screens/my_bookings_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/client_messages_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/search_results_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/booking_form_screen.dart';
import 'screens/trip_details_screen.dart';
import 'screens/create_trip_screen.dart';
import 'screens/my_trips_screen.dart';
import 'screens/transporter_profile_screen.dart';
import 'screens/transporter_reviews_screen.dart';
import 'services/storage_service.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  await StorageService().init();
  
  runApp(const RestartWidget(child: WassaliApp()));
}

class WassaliApp extends StatelessWidget {
  const WassaliApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget guard(BuildContext ctx, Widget screen, {UserType? requiredType}) {
      final auth = Provider.of<AuthProvider>(ctx, listen: false);
      if (!auth.isAuthenticated) {
        return LoginScreen(initialUserType: requiredType == UserType.transporter ? 'transporter' : 'client');
      }
      if (requiredType != null && auth.currentUser!.userType != requiredType) {
        return auth.currentUser!.userType == UserType.client
            ? const HomeClientScreen()
            : const TransporterDashboardScreen();
      }
      return screen;
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer2<LanguageProvider, SettingsProvider>(
        builder: (context, languageProvider, settingsProvider, child) => MaterialApp(
          key: ValueKey(languageProvider.locale.languageCode),
          locale: languageProvider.locale,
          supportedLocales: const [
            Locale('fr', ''),
            Locale('en', ''),
            Locale('ar', ''),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale != null) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
            }
            return supportedLocales.first;
          },
          title: 'Wassali',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settingsProvider.themeMode,
          initialRoute: '/',
          routes: {
          '/': (context) => const SplashScreen(),
          '/landing': (context) => const LandingPageScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/signup-client': (context) => const SignupClientScreen(),
          '/signup-transporter': (context) => const SignupTransporterScreenClean(),
          '/home-client': (context) => guard(context, const HomeClientScreen(), requiredType: UserType.client),
          '/transporter-dashboard': (context) => guard(context, const TransporterDashboardScreen(), requiredType: UserType.transporter),
          '/my-bookings': (context) => guard(context, const MyBookingsScreen(), requiredType: UserType.client),
          '/messages': (context) => guard(context, const ClientMessagesScreen(), requiredType: UserType.client),
          '/profile': (context) => guard(context, const ProfileScreen()),
          '/search': (context) => guard(context, const SearchScreen(), requiredType: UserType.client),
          '/search-results': (context) => guard(context, const SearchResultsScreen()),
          '/settings': (context) => guard(context, const SettingsScreen()),
          '/edit-profile': (context) => guard(context, const EditProfileScreen()),
          '/change-password': (context) => guard(context, const ChangePasswordScreen()),
          '/help': (context) => guard(context, const HelpSupportScreen()),
          '/booking-form': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is String) {
              return guard(context, BookingFormScreen(tripId: args), requiredType: UserType.client);
            } else if (args is Map && args.containsKey('tripId')) {
              return guard(context, BookingFormScreen(tripId: args['tripId'], trip: args['trip']), requiredType: UserType.client);
            }
            return guard(context, const SearchResultsScreen(), requiredType: UserType.client); // Fallback
          },
          '/trip-details': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args != null) {
              return guard(context, TripDetailsScreen(trip: args), requiredType: UserType.client);
            }
            return guard(context, const SearchScreen(), requiredType: UserType.client);
          },
          '/create-trip': (context) => guard(context, const CreateTripScreen(), requiredType: UserType.transporter),
          '/my-trips': (context) => guard(context, const MyTripsScreen(), requiredType: UserType.transporter),
          '/transporter-profile': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            final screen = TransporterProfileScreen(transporterId: args is String ? args : null);
            return guard(context, screen);
          },
          '/transporter-reviews': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is String) {
              final screen = TransporterReviewsScreen(transporterId: args);
              return guard(context, screen);
            }
            return const LandingPageScreen();
          },
          '/transporter-messages': (context) => guard(context, const MessagesScreen(), requiredType: UserType.transporter),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const LandingPageScreen(),
          );
        },
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // AuthProvider already loads saved session in constructor
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    String nextRoute;
    if (authProvider.isAuthenticated) {
      final user = authProvider.currentUser!;
      nextRoute = user.userType == UserType.client
          ? '/home-client'
          : '/transporter-dashboard';
    } else {
      nextRoute = '/landing';
    }
    
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.2 * 255).round()),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_shipping,
                  size: 80,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Wassali',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Livraison de colis rapide et fiable',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
