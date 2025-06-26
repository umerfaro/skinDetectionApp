
import 'consts.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final VoidCallback onResumed;
  final VoidCallback onDetached;

  LifecycleEventHandler({required this.onResumed, required this.onDetached});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    } else if (state == AppLifecycleState.detached) {
      onDetached();
    }
  }

  @override
  void didChangeMetrics() {
    onResumed();
  }
}
