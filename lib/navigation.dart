import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as router;

import 'package:go_router_poc/launcher_service.dart';
import 'package:go_router_poc/models/curriculum.dart';
import 'package:go_router_poc/models/random.dart';

final isAuthenticated = ValueNotifier(true);
final isLoading = ValueNotifier(false);
final listenable = Listenable.merge([isAuthenticated, isLoading]);

router.GoRouter createRouter() {
  return router.GoRouter(
    initialLocation: '/home',
    refreshListenable: listenable,
    debugLogDiagnostics: true,
    routes: <router.RouteBase>[
      router.GoRoute(
        path: '/splash',
        redirect: (context, state) {
          if (isLoading.value) return '/splash';

          return '/home';
        },
        builder: (_, __) => const Splash(),
      ),
      router.GoRoute(
        path: '/home',
        name: 'home',
        redirect: (context, state) {
          return isAuthenticated.value ? null : '/login';
        },
        builder: (_, __) => const Home(),
        routes: [
          router.GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (_, __) => const Profile(),
          ),
        ],
      ),
      router.GoRoute(
        path: '/login',
        name: 'login',
        redirect: (context, state) {
          if (isAuthenticated.value) return '/home';

          return null;
        },
        builder: (_, __) => const Login(),
      ),
      router.GoRoute(
        path: '/pdf',
        name: 'pdf',
        builder: (_, state) {
          final value = state.uri.queryParameters.keys.first;
          return PdfPage(pdf: Curriculum.fromJson(value));
        },
      ),
    ],
  );
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Splash'),
            ElevatedButton(
              onPressed: () {
                isLoading.value = false;
              },
              child: Text('Loaded'),
            )
          ],
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login'),
            ElevatedButton(
              onPressed: () {
                isAuthenticated.value = true;
              },
              child: Text('Authenticate'),
            ),
          ],
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home'),
            ElevatedButton(
              onPressed: () {
                context.goNamed('pdf');
              },
              child: Text('Print PDF (Same Page)'),
            ),
            ElevatedButton(
              onPressed: () async {
                final cur = Fake.createFakeCurriculum();

                final uri = Uri(
                  scheme: "http",
                  host: "localhost",
                  port: 58650,
                  path: 'pdf',
                  query: cur.toJson(),
                );

                await URLLauncherService().launchURI(uri);
              },
              child: Text('Print PDF (New Page)'),
            ),
            ElevatedButton(
              onPressed: () {
                isAuthenticated.value = false;
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile'),
          ],
        ),
      ),
    );
  }
}

class PdfPage extends StatelessWidget {
  const PdfPage({super.key, required this.pdf});
  final Curriculum? pdf;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(pdf.toString()),
          ],
        ),
      ),
    );
  }
}
