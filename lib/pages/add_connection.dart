import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../widgets/my_accounts/add_transaction.dart';
import '../widgets/my_accounts/add_wallet.dart';
import '../widgets/shared/appbar.dart';

class AddResource extends StatefulWidget {
  const AddResource({super.key});

  @override
  State<AddResource> createState() => _AddResourceState();
}

class _AddResourceState extends State<AddResource> {
  @override
  Widget build(BuildContext context) {
    final titleText = FlutterI18n.translate(context, 'add_resource.title');
    final walletTabText = FlutterI18n.translate(context, 'add_resource.tabs.wallet');
    final manualTabText = FlutterI18n.translate(context, 'add_resource.tabs.manual_input');

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppBar(
          preferredSize: const Size.fromHeight(110),
          withLogo: false,
          withAvatar: true,
          title: titleText,
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.secondary,
            tabs: [
              Tab(text: walletTabText),
              Tab(text: manualTabText),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: const TabBarView(
            children: [
              AddWallet(),
              AddTransaction(),
            ],
          ),
        ),
      ),
    );
  }
}