import 'package:formcapture/imports.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController? showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final state = Overlay.of(context);
      if (state != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && state != null) {
          final size = renderBox.size;

          final overlay = OverlayEntry(
            builder: (context) {
              return Material(
                color: Colors.black.withAlpha(150),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: size.width * 0.8,
                      maxHeight: size.height * 0.8,
                      minWidth: size.width * 0.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            const CircularProgressIndicator(),
                            const SizedBox(height: 20),
                            StreamBuilder(
                              stream: _text.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data as String,
                                    textAlign: TextAlign.center,
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
          state?.insert(overlay);

          controller = LoadingScreenController(
            close: () {
              _text.close();
              overlay.remove();
              return true;
            },
            update: (text) {
              _text.add(text);
              return true;
            },
          );
        }
      }
    });
    return controller;
  }
}
