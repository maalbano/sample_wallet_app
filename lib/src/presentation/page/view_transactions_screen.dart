import 'package:bloc_clean_architecture/injection.dart' as di;
import 'package:bloc_clean_architecture/src/domain/usecase/fetch_transactions.dart';
import 'package:bloc_clean_architecture/src/presentation/bloc/transactions/view_transactions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// view transactions screen
//This screen should show all the transactions made by the user. Should show details like the amount sent.
class ViewTransactionScreen extends StatefulWidget {
  const ViewTransactionScreen({super.key});

  @override
  State<ViewTransactionScreen> createState() => _ViewTransactionScreenState();
}

class _ViewTransactionScreenState extends State<ViewTransactionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ViewTransactionsBloc>().add(LoadTransactions());
    });
  }

  // @override
  Widget build2(BuildContext context) {
    return BlocConsumer<ViewTransactionsBloc, ViewTransactionsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('View Transactions'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text('View Transactions Screen'),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10, // Example transaction count
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.monetization_on),
                        title: Text('Transaction ${index + 1}'),
                        subtitle: Text('Amount: Php ${(index + 1) * 100}.00'),
                        trailing: Text('Status: Completed'),
                      );
                    },
                  ),
                ),
                // OutlinedButton(
                //     onPressed: () {
                //       context.pop();
                //     },
                //     child: Text('Go Back')),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ViewTransactionsBloc>().add(LoadTransactions());
            },
          ),
        ],
      ),
      body: BlocConsumer<ViewTransactionsBloc, ViewTransactionsState>(
        listener: (context, state) {
          if (state is TransactionsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is TransactionsLoaded && state.transactions.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No transactions found.')),
            );
          }
        },
        builder: (context, state) {
          if (state is TransactionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionsLoaded) {
            final List<Transaction> transactions = state.transactions;
            if (transactions.isEmpty) {
              return const Center(child: Text('No transactions found.'));
            }
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return ListTile(
                  leading: const Icon(Icons.monetization_on),
                  title: Text('To: ${tx.to}'),
                  subtitle: Text('Amount: Php ${tx.amount}'),
                  trailing: Text('Date: ${tx.date}'),
                );
              },
            );
          } else if (state is TransactionsError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Loading...'));
        },
      ),
    );
  }
}
