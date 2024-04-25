import 'package:codepush_test/controller/shorebirdController.dart';
import 'package:codepush_test/model/shorebird_Data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

final _shorebirdCodePush = ShorebirdCodePush();

class shorebirdPage extends ConsumerStatefulWidget {
  const shorebirdPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _shorebirdPageState();
}

class _shorebirdPageState extends ConsumerState<shorebirdPage> {
  final _isShorebirdAvailable = _shorebirdCodePush.isShorebirdAvailable();
  ShorebirdController? shorebirdController;
  int? _currentPatchVersion;
  bool _isCheckingForUpdate = false;

  @override
  void initState() {
    // TODO: implement
    //final containerProvider = ProviderContainer();
    shorebirdController = ShorebirdController();
    super.initState();
    _shorebirdCodePush.currentPatchNumber().then(
      (currentPatchValue) {
        if (!mounted) return;
        setState(() {
          _currentPatchVersion = currentPatchValue;
        });
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkPatch();
    });
  }

  Future<void> _checkPatch() async {
    final shorebirdProvider = ref.read(shorebirdData.notifier);
    setState(() {
      _isCheckingForUpdate = true;
    });

    await shorebirdController!.autoCheckNewPatchAvailableForDownload(ref);

    print("shorebirdProvider.bannerState: ${shorebirdProvider.bannerState}");

    if (shorebirdProvider.bannerState) {
      setState(() {
        shorebirdController!.showScaffoldMessageBanner(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('沒有新的版本'),
        ),
      );
      Future.delayed(const Duration(seconds: 5), () {
        if (!mounted) return;
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      });
    }

    setState(() {
      _isCheckingForUpdate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    final heading = _currentPatchVersion != null
        ? '$_currentPatchVersion'
        : 'No patch installed';
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors
            .white, //theme.splashColor, //theme.colorScheme.inversePrimary,
        title: const Text('Shorebird Code Push Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Current patch version:'),
            Text(
              heading,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            if (!_isShorebirdAvailable)
              Text(
                'Shorebird Engine not available.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            if (_isShorebirdAvailable)
              ElevatedButton(
                onPressed: _isCheckingForUpdate ? null : _checkPatch,
                child: _isCheckingForUpdate
                    ? const _LoadingIndicator()
                    : const Text('Check for update'),
              ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    backgroundColor = Colors.orange;
                  });
                },
                child: const Text('改變背景顏色')),
          ],
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 14,
      width: 14,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
