import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
// CORREÇÃO: importar a partir do pacote wisemade_app_core
import 'package:wisemade_app_core/themes/shimmer_wrapper.dart';

import 'package:wisemade_app_core/widgets/shared/percentage.dart';

import '../app_state.dart';
import '../main.dart';
import '../models/coin.dart';
import '../themes/wisemade.dart';
import '../utils/format.dart';
import '../widgets/shared/appbar.dart';
import 'authenticated_page.dart';
import 'coin.dart';

class PerformanceReportPage extends AuthenticatedPage {
  const PerformanceReportPage({
    super.key,
  });

  @override
  AuthenticatedPageState<PerformanceReportPage> createState() => _PerformanceReportPageState();
}

class _PerformanceReportPageState extends AuthenticatedPageState<PerformanceReportPage> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future getData({int page = 1}) async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    if (appState.performanceReport == null) await appState.getPerformanceReport();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget render(BuildContext context) {
    mixpanel.track('Viewed Screen - Performance Report');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(preferredSize: Size.fromHeight(30)),
      body: SafeArea(
        child: Consumer<AppState>(builder: (context, state, child) {
          if (!state.performanceReportLoading && state.performanceReport == null) {
            Navigator.of(context).pop();
            return const SizedBox();
          } else {
            return SingleChildScrollView(
              child: Column(children: [
                Content(
                  loading: state.performanceReportLoading,
                  performanceReport: state.performanceReport,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ShareButton(
                    screenshotController: screenshotController,
                    performanceReport: state.performanceReport,
                  ),
                ),
              ]),
            );
          }
        }),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    required this.screenshotController,
    required this.performanceReport,
  });

  final ScreenshotController screenshotController;
  final Map<String, dynamic>? performanceReport;

  @override
  Widget build(BuildContext context) {
    final buttonText = FlutterI18n.translate(context, 'performance_report.share_button');

    return ElevatedButton(
      onPressed: () async {
        try {
          // CAPTURAR o RenderBox ANTES do await para não usar context após pausa assíncrona
          final box = context.findRenderObject() as RenderBox?;

          // Captura a imagem (não-nula)
          Uint8List image = await screenshotController.captureFromWidget(
            MediaQuery(
              data: const MediaQueryData(),
              child: MaterialApp(
                theme: WisemadeTheme.darkTheme,
                home: Scaffold(
                  resizeToAvoidBottomInset: true,
                  body: SafeArea(
                    child: Content(
                      loading: false,
                      performanceReport: performanceReport,
                      printMode: true,
                    ),
                  ),
                ),
              ),
            ),
            targetSize: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.width * 2,
            ),
            pixelRatio: 1.5,
          );

          // Salva o arquivo no diretório de documentos
          final directory = await getApplicationDocumentsDirectory();
          final imagePath = await File('${directory.path}/image.png').create();
          await imagePath.writeAsBytes(image.toList());

          // Compartilha o arquivo, usando a posição capturada anteriormente
          if (box != null) {
            await Share.shareXFiles(
              [XFile(imagePath.path)],
              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
            );
          }
        } catch (e) {
          // Substituição de print por debugPrint
          debugPrint(e.toString());
        }
      },
      child: Text(
        buttonText,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.performanceReport,
    required this.loading,
    this.printMode = false,
  });

  final Map<String, dynamic>? performanceReport;
  final bool loading;
  final bool printMode;

  @override
  Widget build(BuildContext context) {
    final String formattedSince = loading
        ? ''
        : DateFormat('dd/MM/yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(performanceReport?['since'] * 1000));

    final titleText = FlutterI18n.translate(context, 'performance_report.title');
    final subtitleText = FlutterI18n.translate(context, 'performance_report.subtitle');
    final descriptionText = FlutterI18n.translate(
      context,
      'performance_report.description',
      translationParams: {'date': formattedSince},
    );

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: printMode ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (printMode != true) ...[
            Text(titleText, style: Theme.of(context).textTheme.headlineMedium),
            Text(
              subtitleText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.shadow,
              ),
            ),
          ],
          if (printMode == true)
            Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 20),
              child: Image.asset('images/logo-white.png', height: 60),
            ),
          if (printMode == true)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                descriptionText,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          SummaryBox(
            performanceReport: performanceReport,
            loading: loading,
            printMode: printMode,
          ),
          TopGainers(performanceReport: performanceReport, loading: loading),
          TopLosers(performanceReport: performanceReport, loading: loading),
        ],
      ),
    );
  }
}

class SummaryBox extends StatelessWidget {
  const SummaryBox({
    super.key,
    required this.performanceReport,
    required this.loading,
    this.printMode = false,
  });

  final Map<String, dynamic>? performanceReport;
  final bool loading;
  final bool printMode;

  @override
  Widget build(BuildContext context) {
    final String formattedSince = loading
        ? ''
        : DateFormat('dd/MM/yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(performanceReport?['since'] * 1000));

    final String profitLabel = loading
        ? ''
        : performanceReport?['profitValue'] >= 0
        ? 'Você ganhou'
        : 'Você perdeu';

    final String titleLabel = loading
        ? ''
        : performanceReport?['profitValue'] >= 0
        ? 'valorização'
        : 'desvalorização';

    final String title = printMode ? 'Tive uma $titleLabel de' : 'Desde $formattedSince';

    AppState state = Provider.of<AppState>(context);
    final pricePrefix = state.currentUser?.fiatPrefix ?? "\$";

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Primeira linha: título ou placeholder
          loading
          // Placeholder com Shimmer (altura 30)
              ? ShimmerThemeWrapper(
            child: Container(
              height: 30,
              width: double.infinity,
              color: Colors.white,
            ),
          )
              : Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.shadow),
          ),

          // Segunda linha: porcentagem (placeholder se loading)
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: loading
            // Placeholder para porcentagem (altura 60)
                ? ShimmerThemeWrapper(
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.white,
              ),
            )
                : Percentage(
              value: performanceReport?['profitPercentage'],
              alignment: MainAxisAlignment.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontSize: 48, fontWeight: FontWeight.bold),
              iconSize: 36,
            ),
          ),

          // Terceira linha (somente se não estiver em modo impressão)
          if (printMode != true)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: loading
              // Placeholder (altura 30)
                  ? ShimmerThemeWrapper(
                child: Container(
                  height: 30,
                  width: double.infinity,
                  color: Colors.white,
                ),
              )
                  : RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$profitLabel ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.shadow,
                      ),
                    ),
                    TextSpan(
                      text: Format.currency(
                        performanceReport?['profitValue'],
                        pattern: '$pricePrefix #,##0.00',
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TopGainers extends StatelessWidget {
  const TopGainers({
    super.key,
    required this.performanceReport,
    required this.loading,
  });

  final Map<String, dynamic>? performanceReport;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    // Se não houver dados, preenchemos com 3 itens nulos
    List topGainers = performanceReport?['topGainers'] ?? [null, null, null];
    final titleText = FlutterI18n.translate(context, 'performance_report.top_gainers');

    // Exibimos enquanto estiver carregando OU se a lista não estiver vazia
    return (loading || topGainers.isNotEmpty)
        ? Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            titleText,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).colorScheme.shadow),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: topGainers.map<Widget>((gainer) {
                final Coin? coin = gainer == null ? null : Coin.fromJson(gainer);
                return CoinCard(
                  coin: coin,
                  priceVariation: gainer?['priceVariationPercentage'],
                  loading: loading,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    )
        : const SizedBox();
  }
}

class TopLosers extends StatelessWidget {
  const TopLosers({
    super.key,
    required this.performanceReport,
    required this.loading,
  });

  final Map<String, dynamic>? performanceReport;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    List topLosers = performanceReport?['topLosers'] ?? [null, null, null];
    final titleText = FlutterI18n.translate(context, 'performance_report.top_losers');

    return (loading || topLosers.isNotEmpty)
        ? Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            titleText,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).colorScheme.shadow),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: topLosers.map<Widget>((loser) {
                final Coin? coin = loser == null ? null : Coin.fromJson(loser);
                return CoinCard(
                  coin: coin,
                  priceVariation: loser?['priceVariationPercentage'],
                  loading: loading,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    )
        : const SizedBox();
  }
}

class CoinCard extends StatelessWidget {
  const CoinCard({
    super.key,
    required this.coin,
    required this.loading,
    required this.priceVariation,
  });

  final Coin? coin;
  final bool loading;
  final num? priceVariation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (coin != null) {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: CoinPage(myCoin: coin!),
            withNavBar: false,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            // Avatar ou placeholder circular
            loading
                ? ShimmerThemeWrapper(
              child: Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                coin!.imageUrl,
                width: 56,
                height: 56,
              ),
            ),

            // Símbolo da moeda ou placeholder de texto
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: loading
                  ? ShimmerThemeWrapper(
                child: Container(
                  height: 15,
                  width: 60,
                  color: Colors.white,
                ),
              )
                  : Text(
                coin!.formattedSymbol(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            // Percentual de variação ou placeholder
            loading
                ? ShimmerThemeWrapper(
              child: Container(
                height: 10,
                width: 60,
                color: Colors.white,
              ),
            )
                : Percentage(value: double.parse(priceVariation!.toString())),
          ],
        ),
      ),
    );
  }
}