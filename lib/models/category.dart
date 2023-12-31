import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/savable.dart';
import 'package:flutter_hello_world/persistence/categories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

final String rootCategoryUid = "830472ff-c3fa-4a38-9e2d-d3f4b4e1268a";

class Category extends Savable {
  Category({
    String? uid,
    required this.name,
    required this.codepoint,
    required this.iconColor,
    this.parent,
  }) {
    this.uid = uid ?? Uuid().v4();
  }

  @override
  late final String uid;

  String name;
  int codepoint;
  Color iconColor;
  String? parent;

  get iconData {
    return IconData(codepoint, fontFamily: 'MaterialIcons');
  }

  get icon {
    return Icon(iconData, color: iconColor);
  }
}

@Riverpod(keepAlive: true)
class Categories extends _$Categories {
  @override
  Future<Map<String, Category>> build() async {
    return getAll();
  }

  add(Category newCategory) async {
    await ref.read(categoriesPersistenceProvider.notifier).create(newCategory);

    final previousState = await future;
    state = AsyncData(Map.from({...previousState, newCategory.uid: newCategory}));
  }

  void editCategory(Category category) async {
    await ref.read(categoriesPersistenceProvider.notifier).updateElement(category);

    final previousState = await future;
    final newState = previousState.map((key, value) => MapEntry(key, key == category.uid ? category : value));
    state = AsyncData(newState);
  }

  void delete(Category category) async {
    await ref.read(categoriesPersistenceProvider.notifier).delete(category.uid);

    final previousState = await future;
    Map<String, Category> newState = Map.from(previousState);
    newState.remove(category.uid);
    state = AsyncData(newState);
  }

  Future<Map<String, Category>> getAll() async {
    List<Category> items = await ref.read(categoriesPersistenceProvider.notifier).readAll();
    return Map.fromEntries(items.map((e) => MapEntry(e.uid, e)));
  }

  Future<void> factoryReset() async {
    await ref.read(categoriesPersistenceProvider.notifier).init();
    await ref.read(categoriesPersistenceProvider.notifier).populateData();
    state = AsyncData(await getAll());
  }
}
