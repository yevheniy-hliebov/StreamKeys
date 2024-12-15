import 'package:streamkeys/windows/models/touch/action_touch_button_info.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/models/touch/page_touch_data.dart';
import 'package:streamkeys/windows/models/keyboard/grid_template.dart';
import 'package:streamkeys/windows/services/touch_deck_service.dart';

class TouchDeckProvider extends ChangeNotifier {
  final String currentPage;
  late PageTouchData pageTouchData;

  TouchDeckProvider(this.currentPage) {
    init();
  }

  final TouchDeckService _service = TouchDeckService();

  GridTemplate currentGrid = GridTemplate(3, 2);
  List<GridTemplate> grids = GridTemplate.gridTemplates;

  ActionButtonInfo? selectedButtonInfo;
  int? selectedButtonInfoIndex;

  FutureVoid init() async {
    await _service.init();
    await getData();

    notifyListeners();
  }

  FutureVoid getData() async {
    final jsonData = _service.jsonData;
    final List<Map<String, dynamic>> pages =
        (jsonData['map_pages'][currentPage] as List)
            .cast<Map<String, dynamic>>();

    pageTouchData = PageTouchData.fromJson(currentPage, pages);

    currentGrid = GridTemplate.fromJson(jsonData['selected_grid']);
    notifyListeners();
  }

  List<ActionButtonInfo> get buttonInfos {
    return pageTouchData.actionButtonInfos;
  }

  ActionButtonInfo? getButonInfo(int index) {
    try {
      return buttonInfos[index];
    } catch (e) {
      return null;
    }
  }

  FutureVoid setAction(int index, BaseAction action) async {
    buttonInfos[index].actions.add(action.copy());

    await _savePageData();
    notifyListeners();
  }

  bool isSelectedTouchButton(int index) {
    return selectedButtonInfoIndex == index;
  }

  void selectButton(int index) {
    selectedButtonInfo = pageTouchData.actionButtonInfos[index];
    selectedButtonInfoIndex = index;
    notifyListeners();
  }

  void updateSelectedButtonInfo(ActionButtonInfo buttonInfo) async {
    if (selectedButtonInfo != buttonInfo && selectedButtonInfoIndex != null) {
      pageTouchData.actionButtonInfos[selectedButtonInfoIndex!] = buttonInfo;

      _service.jsonData['map_pages'][pageTouchData.pageName] =
          pageTouchData.toJson();
      await _savePageData();
      notifyListeners();
    }
  }

  FutureVoid reorderButton(int oldIndex, int newIndex) async {
    _reorderList(pageTouchData.actionButtonInfos, oldIndex, newIndex);
    await _savePageData();
  }

  FutureVoid updateGrid(GridTemplate newGrid) async {
    _unSelectButtonInfo();

    currentGrid = newGrid;

    await _service.updateGridSize(newGrid, currentPage);
    notifyListeners();
  }

  FutureVoid regeneratePageButtons() async {
    final pageJson = _service.jsonData['map_pages'][currentPage];

    if (pageJson != null) {
      final int currentButtons = pageJson['actionButtonInfo'].length;
      final int newTotalButtons =
          currentGrid.numberOfColumns * currentGrid.numberOfRows;

      if (currentButtons < newTotalButtons) {
        _service.jsonData['map_pages'][currentPage] =
            _service.generateButtonsForPage(
          pageJson,
          currentGrid,
        );
        await _service.saveData();
        notifyListeners();
      }
    }
  }

  FutureVoid _savePageData() async {
    _service.jsonData['map_pages'][currentPage] = pageTouchData.toJson();
    await _service.saveData();
  }

  void _reorderList(List<dynamic> list, int oldIndex, int newIndex) {
    final movedItem = list.removeAt(oldIndex);
    list.insert(newIndex, movedItem);
  }

  void _unSelectButtonInfo() {
    selectedButtonInfo = null;
    selectedButtonInfoIndex = null;
    notifyListeners();
  }
}
