import 'package:home_widget/home_widget.dart';

class WidgetBridgeService {
  Future<void> syncCircleSummary({
    required int activeMembers,
    required int pendingMembers,
  }) async {
    await HomeWidget.saveWidgetData<int>('active_members', activeMembers);
    await HomeWidget.saveWidgetData<int>('pending_members', pendingMembers);
    await HomeWidget.updateWidget(
      androidName: 'LumiCircleWidgetProvider',
      iOSName: 'LumiCircleWidget',
    );
  }
}
