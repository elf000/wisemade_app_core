import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/widgets/shared/exchanges_autocomplete/state.dart';

import '../../../app_state.dart';
import '../../../models/exchange.dart';
import '../list_shimmer.dart';
import 'item.dart';

class Sheet extends StatefulWidget {
  final Function onSelect;

  const Sheet({
    Key? key,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<Sheet> createState() => _SheetState();
}

class _SheetState extends State<Sheet> {
  late AppState appState;
  List<Exchange> _filteredExchanges = [];

  @override
  void initState() {
    super.initState();
    // Inicializa o AppState e já carrega as exchanges
    appState = AppState(context: context);
    appState.getExchanges();
  }

  @override
  void dispose() {
    // Como não há PagingController, só chama super.dispose()
    super.dispose();
  }

  /// Atualiza _filteredExchanges a cada mudança no campo de busca
  void _fetchExchanges(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredExchanges = appState.exchanges
          .where((ex) => ex.name.toLowerCase().startsWith(lowerQuery))
          .take(10)
          .toList();
    });
  }

  /// Retorna até 10 exchanges: ou as filtradas, ou as primeiras da lista completa
  List<Exchange> _getExchanges() {
    if (_filteredExchanges.isNotEmpty) {
      return _filteredExchanges;
    } else {
      return appState.exchanges.take(10).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelText =
    FlutterI18n.translate(context, 'add_transaction.search.exchange.label');
    final hintText =
    FlutterI18n.translate(context, 'add_transaction.search.exchange.hint');

    return ChangeNotifierProvider<AppState>(
      create: (_) => appState,
      child: Consumer<AppState>(
        builder: (context, state, child) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.8,
          child: CustomScrollView(
            slivers: [
              // Campo de busca fixo no topo
              SliverAppBar(
                scrolledUnderElevation: 0,
                pinned: true,
                toolbarHeight: 80,
                backgroundColor: Theme.of(context).colorScheme.surface,
                automaticallyImplyLeading: false,
                title: TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    border: const OutlineInputBorder(),
                    labelText: labelText,
                    hintText: hintText,
                  ),
                  onChanged: (String query) {
                    _fetchExchanges(query);
                  },
                ),
              ),

              // Lista de resultados (até 10 itens) ou skeleton se estiver vazia
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final exchanges = _getExchanges();

                    if (exchanges.isEmpty) {
                      return const ListSkeleton(size: 8);
                    }

                    final exchange = exchanges[index];
                    return Item(exchange: exchange, onTap: widget.onSelect);
                  },
                  // Se não houver nenhum resultado, exibe apenas 1 widget de skeleton
                  childCount: _getExchanges().isEmpty
                      ? 1
                      : _getExchanges().length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}