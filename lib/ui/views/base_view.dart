import 'package:flutter/material.dart';
import 'package:moneymanager/core/viewmodels/base_model.dart';
import 'package:provider/provider.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T)? onModelReady;
  T model;

  BaseView({required this.builder, this.onModelReady, required this.model});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  @override
  void initState() {
    widget.model = widget.model;
    if (widget.onModelReady != null) {
      widget.onModelReady!(widget.model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(create: (context) => widget.model, child: Consumer<T>(builder: widget.builder));
  }
}
