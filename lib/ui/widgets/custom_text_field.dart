import 'package:pewobu/core_packages.dart';

class CustomTextField extends StatefulWidget {
  final int numLines;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmit;
  final String? hintText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool autoFocus;
  final VoidCallback? onPressed;

  const CustomTextField({
    super.key,
    this.numLines = 1,
    this.onChanged,
    this.onSubmit,
    this.hintText,
    this.focusNode,
    this.controller,
    this.autoFocus = false,
    this.onPressed,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onFieldSubmitted: widget.onSubmit,
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      autofocus: widget.autoFocus,
      minLines: widget.numLines,
      maxLines: widget.numLines,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: kGrey,
      style: kBodyText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.all(0),
      ),
    );
  }
}
