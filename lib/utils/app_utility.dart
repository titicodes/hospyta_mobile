import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospyta_mobile/extensions/string_extensions.dart';
import 'package:rive/rive.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../app_widgets/app_text_btn.dart';
import '../app_widgets/circular_progress_indicator.dart';
import '../constants/assets.dart';
import '../constants/colors.dart';
import '../constants/dimens.dart';
import '../constants/strings.dart';
import '../constants/styles.dart';

abstract class AppUtility{
   /// Logger

  static final logger = TalkerFlutter.init();

  static void log(dynamic message, {String? tag}) {
    switch (tag) {
      case 'error':
        logger.error(message);
        break;
      case 'warning':
        logger.warning(message);
        break;
      case 'info':
        logger.info(message);
        break;
      case 'debug':
        logger.debug(message);
        break;
      case 'critical':
        logger.critical(message);
        break;
      default:
        logger.verbose(message);
        break;
    }
  }

  // Close all fialog


  static void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void closeBottomSheet(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void closeFocus() {
    if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
  static bool isSnackbarVisible = false;

  static void showSnac(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );

    // Set the flag to true when showing SnackBar
    isSnackbarVisible = true;

    // Dismiss SnackBar after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      closeSnackBar(context);
    });
  }

  static void closeSnackBar(BuildContext context) {
    // Set the flag to false when closing SnackBar
    isSnackbarVisible = false;

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  /// Show Loading Dialog

  
static void showLoadingDialog(BuildContext context,
    {double? value, bool? barrierDismissible, String? message}) {
  closeSnackBar(context);
  closeDialog(context);
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.eight),
        ),
        child: Container(
          padding: EdgeInsets.all(Dimens.sixty),
          decoration: BoxDecoration(
            color: Theme.of(context).dialogTheme.backgroundColor,
            borderRadius: BorderRadius.circular(Dimens.eight),
          ),
          constraints: BoxConstraints(
            maxWidth: Dimens.screenWidth,
            maxHeight: Dimens.screenHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              NxCircularProgressIndicator(
                size: Dimens.thirtyTwo,
                strokeWidth: Dimens.four,
                value: value,
              ),
              Dimens.boxHeight12,
              Text(
                message ?? StringValues.pleaseWait,
                style: AppStyles.style16Normal.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  /// Text Logo

  static buildAppLogo(BuildContext context,
          {double? fontSize, bool? isCentered = false}) =>
      Text(
        StringValues.appName.toUpperCase(),
        style: AppStyles.style24Bold.copyWith(
          fontFamily: "Muge",
          fontSize: fontSize,
          letterSpacing: Dimens.four,
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
        textAlign: isCentered == true ? TextAlign.center : TextAlign.start,
      );

  /// Show Simple Dialog

  static void showSimpleDialog(BuildContext context, Widget child,
      {bool barrierDismissible = false}) {
    closeSnackBar(context);
    closeDialog(context);
    showDialog(
      context: context,
      builder: (BuildContext context) => MediaQuery.removeViewInsets(
        context: context,
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: Dimens.screenHeight,
            maxWidth: Dimens.hundred * 6,
          ),
          child: Padding(
            padding: Dimens.edgeInsets12,
            child: Align(
              alignment: Alignment.center,
              child: Material(
                type: MaterialType.card,
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.four),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: ColorValues.blackColor.withOpacity(0.75),
    );
  }

 /// Show Delete Dialog
  static void showDeleteDialog(BuildContext context, Function onDelete) {
    closeDialog(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: Dimens.screenHeight,
              maxWidth: Dimens.hundred * 6,
            ),
            padding: Dimens.edgeInsets12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Dimens.boxHeight8,
                Padding(
                  padding: Dimens.edgeInsetsHorizDefault,
                  child: Text(
                    StringValues.delete,
                    textAlign: TextAlign.center,
                    style: AppStyles.style20Bold,
                  ),
                ),
                Dimens.boxHeight10,
                Padding(
                  padding: Dimens.edgeInsetsHorizDefault,
                  child: Text(
                    StringValues.deleteConfirmationText,
                    textAlign: TextAlign.center,
                    style: AppStyles.style14Normal,
                  ),
                ),
                Dimens.boxHeight8,
                Padding(
                  padding: Dimens.edgeInsetsHorizDefault,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NxTextButton(
                        label: StringValues.no,
                        labelStyle: AppStyles.style16Bold.copyWith(
                          color: ColorValues.errorColor,
                        ),
                        onTap: () => closeDialog(context),
                        padding: Dimens.edgeInsets8,
                      ),
                      Dimens.boxWidth16,
                      NxTextButton(
                        label: StringValues.yes,
                        labelStyle: AppStyles.style16Bold.copyWith(
                          color: ColorValues.successColor,
                        ),
                        onTap: () => onDelete(),
                        padding: Dimens.edgeInsets8,
                      ),
                    ],
                  ),
                ),
                Dimens.boxHeight8,
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show Share Dialog
  static void showShareDialog(BuildContext context, String text,
      {String? subject}) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      text,
      subject: subject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  static void showError(BuildContext context, String message) {
    closeSnackBar(context);
    closeBottomSheet(context);
    if (message.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: StringValues.okay,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        backgroundColor: const Color(0xFF503E9D),
        margin: Dimens.edgeInsets16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.fifteen),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Show No Internet Dialog
  static void showNoInternetDialog(BuildContext context) {
    closeDialog(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: Padding(
              padding: Dimens.edgeInsets16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Dimens.screenWidth * 0.75,
                    height: Dimens.screenWidth * 0.75,
                    child: const RiveAnimation.asset(
                      RiveAssets.error,
                      alignment: Alignment.center,
                    ),
                  ),
                  Dimens.boxHeight16,
                  Text(
                    'No Internet!',
                    textAlign: TextAlign.center,
                    style: AppStyles.style24Bold.copyWith(
                      color: ColorValues.errorColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Show BottomSheet
  static void showBottomSheet(
      BuildContext context,
      {required List<Widget> children,
      double? borderRadius,
      MainAxisAlignment? mainAxisAlignment,
      CrossAxisAlignment? crossAxisAlignment,
      bool? isScrollControlled}) {
    closeBottomSheet(context);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius ?? Dimens.zero),
          topRight: Radius.circular(borderRadius ?? Dimens.zero),
        ),
      ),
      isScrollControlled: isScrollControlled ?? false,
      backgroundColor:
          Theme.of(context).bottomSheetTheme.modalBackgroundColor,
      builder: (BuildContext context) {
        return Padding(
          padding: Dimens.edgeInsets8_0,
          child: Column(
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        );
      },
    );
  }

  /// Show Overlay
  static void showOverlay(BuildContext context, Function func) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Container();
      },
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor:
          Theme.of(context).bottomSheetTheme.backgroundColor!.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return Opacity(
          opacity: animation.value,
          child: child,
        );
      },
    );
    func();
  }

  /// Show SnackBar
  /// Show SnackBar
/// Show SnackBar
static void showSnackBar(
  BuildContext context, String message, String type, int? duration) {
  closeSnackBar(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.zero,
      padding: Dimens.edgeInsets16_12,
      behavior: SnackBarBehavior.floating,
      content: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: Padding(
                padding: EdgeInsets.only(right: Dimens.eight),
                child: Icon(
                  renderIcon(type),
                  color: renderIconColor(context, type),
                  size: Dimens.twenty,
                  
                ),
              ),
            ),
            TextSpan(
              text: message.toCapitalized(),
              style: AppStyles.style14Normal.copyWith(
                color: renderTextColor(type),
              ),
            ),
          ],
        ),
      ),
      action: SnackBarAction(
        label: StringValues.ok.toUpperCase(),
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      backgroundColor: Theme.of(context).snackBarTheme.backgroundColor!,
      duration: Duration(seconds: duration ?? 3),
    ),
  );
}



  /// Render Text Color
  // static Color renderTextColor(BuildContext context,String type,) {
  //   return Theme.of(context).snackBarTheme.contentTextStyle!.color!;
  // }

  // /// Render Icon Color
  // static Color renderIconColor(BuildContext context, String type) {
  //   if (type == StringValues.success) {
  //     return ColorValues.successColor;
  //   }
  //   return Theme.of(context!).snackBarTheme.contentTextStyle!.color!;
  // }

  // /// Render Icon
  // static IconData renderIcon(String type) {
  //   if (type == StringValues.success) {
  //     return CupertinoIcons.check_mark_circled_solid;
  //   }

  //   return CupertinoIcons.info_circle_fill;
  // }

 static IconData renderIcon(String type) {
  if (type == StringValues.success) {
     return CupertinoIcons.check_mark_circled_solid;
  }
  return CupertinoIcons.info_circle_fill;
}

static Color renderIconColor(BuildContext context, String type) {
  if (type == StringValues.success) {
    return ColorValues.successColor;
  }
  return Theme.of(context).snackBarTheme.contentTextStyle!.color!;
}

static Color renderTextColor(String type) {
  // Define your logic for text color based on the 'type'
  return Colors.white;
}


  /// --------------------------------------------------------------------------

  static void printLog(message) {
    debugPrint(
        "=======================================================================");
    debugPrint(message.toString(), wrapWidth: 1024);
    debugPrint(
        "=======================================================================");
  }

  /// --------------------------------------------------------------------------

  /// Open Url
static Future<void> openUrl(GlobalKey<ScaffoldState> scaffoldKey, Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    showSnackBar(scaffoldKey.currentContext!, "Couldn't launch url", StringValues.error, null);
  }
}



  /// Random String
  static String generateUid(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890@!%&_';
    var rnd = Random();

    return String.fromCharCodes(
      Iterable.generate(
        16,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
  }

}