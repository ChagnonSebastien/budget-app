import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/persistence/material_icon_data.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hello_world/widgets/category_tree.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import "package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart";
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryForm extends HookConsumerWidget {
  CategoryForm({super.key, required this.commit, this.initialCategory, required this.submitText});

  final Function(Category) commit;
  final Category? initialCategory;
  final String submitText;

  final _formKey = GlobalKey<FormState>();

  late final _textCategory = TextEditingController();
  late final _nameController = TextEditingController(text: initialCategory?.name ?? "");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    if (!categories.hasValue) {
      return Loading();
    }

    final parentCategory = useState(categories.value![initialCategory?.parent ?? rootCategoryUid]!);
    useEffect(() {
      _textCategory.text = parentCategory.value.name;
      return null;
    }, [parentCategory.value]);

    final codepoint = useState(initialCategory?.codepoint ?? Icons.auto_awesome.codePoint);
    final color = useState<Color>(initialCategory?.iconColor ?? Colors.orangeAccent);

    showCategorySelection() {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Parent Category', textScaleFactor: 1.2, style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox.fromSize(size: const Size.square(15)),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                    height: 0,
                  ),
                  Expanded(
                    child: CategoryTree(
                      disabled: initialCategory?.uid,
                      onCategoryTap: (tappedCategory) {
                        parentCategory.value = tappedCategory;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    showIcons() async {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: HookConsumer(
              builder: (context, ref, child) {
                final iconFilter = useState("");
                final validIcons = ref.watch(materialIconDataProvider);

                return validIcons.when<Widget>(
                  error: (error, stackTrace) => const Text("Error"),
                  loading: () => const Loading(),
                  data: (value) {
                    var filteredIcons = value.where((element) {
                      return element.searchFields.any((searchText) {
                        return searchText.contains(iconFilter.value);
                      });
                    });

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextFormField(
                            decoration: const InputDecoration(label: Text('Filter')),
                            onChanged: (value) {
                              iconFilter.value = value;
                            },
                          ),
                        ),
                        Expanded(
                          child: GridView(
                            padding: const EdgeInsets.all(20),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
                            children: filteredIcons.map((e) {
                              return IconButton(
                                  onPressed: () {
                                    codepoint.value = e.codepoint;
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(IconData(e.codepoint, fontFamily: "MaterialIcons")));
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      );
    }

    showColorPicker() {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  ColorPicker(
                    color: color.value,
                    onChanged: (value) {
                      color.value = value;
                    },
                    initialPicker: Picker.wheel,
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm'),
                  ),
                ])),
          );
        },
      );
    }

    void submit() {
      if (_formKey.currentState!.validate()) {
        String newCategoryName = _nameController.text.toCapitalized();
        Category newCategory = Category(
            uid: initialCategory?.uid, name: newCategoryName, codepoint: codepoint.value, iconColor: color.value);
        newCategory.parent = parentCategory.value.uid;
        commit(newCategory);
      }
    }

    List<Widget> formFields = [];
    if (initialCategory?.uid != rootCategoryUid) {
      formFields.add(TextFormField(
        controller: _textCategory,
        onTap: showCategorySelection,
        readOnly: true,
        decoration: InputDecoration(
          label: const Text('Parent category'),
          icon: parentCategory.value.icon,
        ),
      ));
    }
    formFields.insertAll(formFields.length, [
      TextFormField(
        decoration: const InputDecoration(
          label: Text('Name'),
        ),
        autofocus: true,
        controller: _nameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Select new category name';
          }
          if (initialCategory?.name != _nameController.text &&
              ref
                  .read(categoriesProvider)
                  .value!
                  .values
                  .map<String>((value) => value.name)
                  .contains(_nameController.text)) {
            return 'This name already exists for another category';
          }
          return null;
        },
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GFButton(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  textColor: Theme.of(context).primaryColor,
                  onPressed: showIcons,
                  child: const Text('Icon'),
                ),
                GFButton(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  textColor: Theme.of(context).primaryColor,
                  onPressed: showColorPicker,
                  child: const Text('Color'),
                ),
              ],
            ),
          ),
          SizedBox.square(dimension: 20),
          GFCard(
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            content: Container(
              margin: const EdgeInsets.all(5),
              child: Icon(
                IconData(codepoint.value, fontFamily: 'MaterialIcons'),
                size: 80,
                color: color.value,
              ),
            ),
          ),
        ],
      ),
      FilledButton(
        onPressed: submit,
        child: Text(submitText),
      ),
    ]);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: formFields,
      ),
    );
  }
}
