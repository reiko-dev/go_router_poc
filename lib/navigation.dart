// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as router;

import 'package:go_router_poc/launcher_service.dart';

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
          return PdfPage(pdf: PDF.fromJson(value));
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
                final pdf = PDF(id: '123123', list: ['Carro', 'Maçã']);

                final uri = Uri(
                  scheme: "http",
                  host: "localhost",
                  port: 58650,
                  path: 'pdf',
                  // queryParameters: map,
                  query: pdf.toJson(),
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
  final PDF? pdf;

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

class PDF {
  final String id;
  final List<String> list;

  PDF({
    required this.id,
    required this.list,
  });

  PDF copyWith({
    String? id,
    List<String>? list,
  }) {
    return PDF(
      id: id ?? this.id,
      list: list ?? this.list,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'list': list,
    };
  }

  factory PDF.fromMap(Map<String, dynamic> map) {
    return PDF(
      id: map['id'] as String,
      list: List<String>.from((map['list'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory PDF.fromJson(String source) =>
      PDF.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PDF(id: $id, list: $list)';

  @override
  bool operator ==(covariant PDF other) {
    if (identical(this, other)) return true;

    return other.id == id && listEquals(other.list, list);
  }

  @override
  int get hashCode => id.hashCode ^ list.hashCode;
}
