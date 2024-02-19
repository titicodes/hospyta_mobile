import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'base_vm.dart';
import 'constants/colors.dart';
import 'constants/dimens.dart';
import 'locator.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  const BaseView({super.key, this.builder, this.onModelReady});
   final Widget Function(BuildContext context, T model, Widget? child)? builder;
  final Function(T)? onModelReady;

  @override
  State<BaseView> createState() => _BaseViewState();
}


class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  T model = getIt<T>();

  @override
  void initState() {
    super.initState();
    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (_) => model,
        child: Consumer<T>(
          builder: (_, model, __) => Stack(
            children: [
              widget.builder!.call(_, model, __),
              if (model.isLoading)
                Stack(children: [
                  ModalBarrier(color: Colors.black12.withOpacity(.5)),
                   Center(
                      child: SpinKitFadingCube(
                    color: ColorValues.primaryColor,
                    size: Dimens.sixty,
                  ))
                ])
              else
                const SizedBox(),
            ],
            //widget.builder!,
          ),
        ));
  }
}