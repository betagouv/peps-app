import 'package:localstorage/localstorage.dart';

class DataManager {
  static final DataManager _dataManager = DataManager._internal();
  final LocalStorage storage = new LocalStorage('peps');

  factory DataManager() {
    return _dataManager;
  }

  DataManager._internal();

  Future setAnswers(Map answers) async {
    storage.ready.then((isReady) {
      if (isReady) {
        storage.setItem('answers', answers);
      }
    });
  }

  Future<Map> getAnswers() async {
    return storage.ready.then((isReady) {
      return storage.getItem('answers');
    });
  }

  Future savePractice(Map practice) async {
    return storage.ready.then((isReady) {
      var savedPractices = storage.getItem('savedPractices') ?? [];
    });
  }
}