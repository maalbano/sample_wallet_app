import 'package:sample_wallet_app/src/presentation/bloc/transactions/send_money_bloc.dart';
import 'package:sample_wallet_app/src/presentation/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_wallet_app/injection.dart' as di;

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendMoneyBloc, SendMoneyState>(
      listener: (context, state) {
        if (state is SendMoneySuccess) {
          showModalBottomSheet<void>(
            context: context,
            builder: (_) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Text('Money Sent Successfully!'),
                ),
              );
            },
          );
        } else if (state is SendMoneyFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is SendMoneyLoading;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Send Money'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CustomTextFormField(
                  hintText: 'Amount to send',
                  textFieldType: TextFieldType.number,
                  prefixIcon: const Icon(Icons.monetization_on),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  onChanged: (v) {
                    context.read<SendMoneyBloc>().add(AmountChanged(v));
                  },
                ),
                CustomTextFormField(
                  hintText: 'Recipient',
                  textFieldType: TextFieldType.text,
                  prefixIcon: const Icon(Icons.mail),
                  onChanged: (v) {
                    context.read<SendMoneyBloc>().add(RecipientChanged(v));
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context
                                  .read<SendMoneyBloc>()
                                  .add(SendMoneyPressed());
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Send'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
