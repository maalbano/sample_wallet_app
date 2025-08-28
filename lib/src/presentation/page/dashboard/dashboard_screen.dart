import 'package:bloc_clean_architecture/src/comman/routes.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/authenticator_watcher/authenticator_watcher_event.dart';
import 'package:bloc_clean_architecture/src/presentation/widget/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool hideBalance = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Card(
              child: ListTile(
                title: Text(
                  hideBalance ? 'Php ********' : 'Php 500.00',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                subtitle: const Text('Current Balance'),
                trailing: Icon(
                  hideBalance ? Icons.remove_red_eye : Icons.visibility_off,
                ),
                onTap: () {
                  setState(() {
                    hideBalance = !hideBalance;
                  });
                },
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.pushNamed(AppRoutes.SEND_MONEY_ROUTE_NAME);
                  },
                  child: const Text('Send Money'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    context.pushNamed(AppRoutes.VIEW_TRANSACTIONS_ROUTE_NAME);
                  },
                  child: const Text('View Transactions'),
                ),
              ],
            ),
            const SizedBox(height: 25),
            CustomOutlinedButton(
              onTap: () {
                context.read<AuthenticatorWatcherBloc>().add(SignedOut());
                context.replaceNamed(AppRoutes.LOGIN_ROUTE_NAME);
              },
              label: 'Log Out',
            ),
          ],
        ),
      ),
    );
  }
}
