import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/fruit_database.dart';
import '../models/combo.dart';

class ComboCubit extends Cubit<List<Combo>> {
  ComboCubit() : super([]);
  final FruitDatabase db = FruitDatabase.instance;

  Future<void> loadCombos() async {
    final combos = await db.getCombos();
    emit(combos);
  }

  Future<void> addCombo(Combo combo) async {
    await db.addCombo(combo);
    final updatedCombo = List<Combo>.from(state)..add(combo);
    emit(updatedCombo);
  }

  Future<void> removeCombo(Combo combo) async {
    if (combo.id != null) {
      await db.removeCombo(combo.id!);
      final updatedCombos = List<Combo>.from(state)..remove(combo);
      emit(updatedCombos);
    }
  }
}
