import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/fruit_database.dart';
import '../models/combo.dart';

class BasketCubit extends Cubit<List<Combo>> {
  BasketCubit() : super([]);
  final FruitDatabase db = FruitDatabase.instance;

  Future<void> loadBasket() async {
    final basket = await db.getBasket();
    emit(basket);
  }

  Future<void> addToBasket(Combo combo) async {
    final existingCombo = await db.getComboFromBasket(combo.id!);

    if (existingCombo != null) {
      await db.updateComboCount(combo.id!, existingCombo.count + combo.count);
    } else {
      await db.addToBasket(combo);
    }

    final updatedBasket = await db.getBasket();
    emit(updatedBasket);
  }

  Future<void> removeFromBasket(Combo combo) async {
    if (combo.id != null) {
      await db.updateOrRemoveComboFromBasket(combo.id!);
      final updatedBasket = await db.getBasket();
      emit(updatedBasket);
    }
  }

  Future<void> clearBasket() async {
    await db.delete('basket');
    emit([]);
  }
}
