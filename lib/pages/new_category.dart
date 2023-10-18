import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/persistance/material_icon_data.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hello_world/widgets/category_tree.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart";

class NewCategory extends HookConsumerWidget {
  NewCategory({
    super.key,
  });

  final _formKey = GlobalKey<FormState>();

  final _textCategory = TextEditingController(text: "");
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    if (!categories.hasValue) {
      return Loading();
    }

    final parentCategory = useState(categories.value![rootCategoryUid]!);
    useEffect(() {
      _textCategory.text = parentCategory.value.name;
      return null;
    }, [parentCategory.value]);

    final codepoint = useState(Icons.auto_awesome.codePoint);
    final color = useState<Color>(Colors.orangeAccent);

    showCategorySelection() {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
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
                  Expanded(child: CategoryTree(onCategoryTap: (tappedCategory) {
                    parentCategory.value = tappedCategory;
                    Navigator.pop(context);
                  })),
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
        Category newCategory = Category(name: newCategoryName, codepoint: codepoint.value, iconColor: color.value);
        ref.read(categoriesProvider.notifier).add(newCategory, parentCategory.value);
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('New Category'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _textCategory,
                onTap: showCategorySelection,
                readOnly: true,
                decoration: InputDecoration(
                  label: const Text('Parent category'),
                  icon: parentCategory.value.icon,
                ),
              ),
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
                  if (ref
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
              Row(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Icon(
                    IconData(codepoint.value, fontFamily: 'MaterialIcons'),
                    size: 80,
                    color: color.value,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        onPressed: showIcons,
                        child: const Text('Select icon'),
                      ),
                      MaterialButton(
                        onPressed: showColorPicker,
                        child: const Text('Select color'),
                      ),
                    ],
                  ),
                ),
              ]),
              SizedBox.fromSize(size: const Size.square(20)),
              FilledButton(
                onPressed: submit,
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
