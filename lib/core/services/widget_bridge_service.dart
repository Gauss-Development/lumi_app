import 'package:home_widget/home_widget.dart';

class WidgetQuickSendMember {
  const WidgetQuickSendMember({
    required this.id,
    required this.displayName,
    required this.colorValue,
  });

  final String id;
  final String displayName;
  final int colorValue;
}

class WidgetBridgeService {
  static const int maxQuickSendMembers = 4;

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

  Future<void> syncQuickSendMembers(List<WidgetQuickSendMember> members) async {
    final List<WidgetQuickSendMember> visible = members
        .take(maxQuickSendMembers)
        .toList(growable: false);
    await HomeWidget.saveWidgetData<int>('quick_send_count', visible.length);
    for (var index = 0; index < maxQuickSendMembers; index += 1) {
      if (index < visible.length) {
        final WidgetQuickSendMember member = visible[index];
        await HomeWidget.saveWidgetData<String>(
          'quick_send_${index}_id',
          member.id,
        );
        await HomeWidget.saveWidgetData<String>(
          'quick_send_${index}_name',
          member.displayName,
        );
        await HomeWidget.saveWidgetData<int>(
          'quick_send_${index}_color',
          member.colorValue,
        );
      } else {
        await HomeWidget.saveWidgetData<String>('quick_send_${index}_id', '');
        await HomeWidget.saveWidgetData<String>('quick_send_${index}_name', '');
        await HomeWidget.saveWidgetData<int>('quick_send_${index}_color', 0);
      }
    }
    await HomeWidget.updateWidget(
      androidName: 'LumiCircleWidgetProvider',
      iOSName: 'LumiCircleWidget',
    );
  }
}
