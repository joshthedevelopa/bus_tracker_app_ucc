import '../imports.dart';

class Display {
  static Future<bool?> show(
    BuildContext context, {
    Widget child = const SizedBox(),
    bool isDisimissable = true,
  }) async {
    FocusScope.of(context).unfocus();

    return showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 1200),
      barrierDismissible: isDisimissable,
      barrierLabel: "",
      transitionBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        secondaryAnimation = CurvedAnimation(
          curve: Curves.elasticOut,
          reverseCurve: Curves.elasticOut,
          parent: animation,
        );
        return ScaleTransition(
          scale: secondaryAnimation,
          child: child,
        );
      },
      pageBuilder: (
        BuildContext context,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
      ) {
        double _inset = MediaQuery.of(context).viewPadding.top;

        return Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0).copyWith(
              top: _inset + 16.0,
            ),
            child: child,
          ),
        );
      },
    );
  }

  static Future prompt(
    context, {
    String title = "",
    String message = "",
  }) async {
    return Display.show(
      context,
      child: Center(
        child: Stack(
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.blueGrey.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkResponse(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Card(
                  shape: const CircleBorder(),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.blueGrey.withOpacity(
                        0.6,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
