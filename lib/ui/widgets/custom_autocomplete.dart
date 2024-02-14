import 'package:flutter/scheduler.dart';
import 'package:pewobu/core_packages.dart';

class CustomAutocomplete extends StatelessWidget {
  final List<String> categories;
  final TextEditingController controller;
  final bool isEnabled;
  final void Function(String value)? onChanged;

  const CustomAutocomplete(
      {super.key, required this.categories, required this.controller, this.isEnabled = true, this.onChanged});

  @override
  Widget build(BuildContext context) {
    double width = context.widthPx;

    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text == '') {
          return Iterable<String>.empty();
        }
        final inputTextLower = textEditingValue.text.toLowerCase();
        return categories.where((option) => option.toLowerCase().contains(inputTextLower));
      },
      onSelected: (selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (
        context,
        fieldTextEditingController,
        fieldFocusNode,
        onFieldSubmitted,
      ) {
        return TextField(
          cursorColor: kGrey,
          style: kBodyText,
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          enabled: isEnabled,
          onSubmitted: (String value) {
            controller.text = value;
            onFieldSubmitted();
          },
          onChanged: (e) => onChanged?.call(controller.text = e),
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: kExtraExtraSmall,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200, maxWidth: width > 500 ? width / 2.5 : width),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Builder(
                      builder: (BuildContext context) {
                        final bool highlight = AutocompleteHighlightedOption.of(context) == index;
                        if (highlight) {
                          SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
                            Scrollable.ensureVisible(context, alignment: 0.5);
                          });
                        }
                        return Container(
                          padding: EdgeInsets.all(kSmall),
                          child: Text(RawAutocomplete.defaultStringForOption(option), style: kBodyText),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
