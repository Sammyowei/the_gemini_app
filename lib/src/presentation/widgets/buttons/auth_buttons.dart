import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Importing ScreenUtil for responsive design
import 'package:gap/gap.dart'; // Importing Gap for spacing

/// A custom button widget used for authentication purposes.
///
/// This button can display an icon, an image, or a combination of an image and a description.
/// The appearance and behavior of the button can be customized using parameters such as
/// [radius], [size], [onTap], [description], [imagePath], and [icon].
class AuthButton extends StatelessWidget {
  /// The radius of the button's rounded corners.
  ///
  /// This value is used to create a rounded shape for the button's border.
  final double radius;

  /// The size of the button.
  ///
  /// This [Size] object determines the width and height of the button.
  final Size size;

  /// A callback function that is triggered when the button is tapped.
  ///
  /// If [icon] is not null, this callback is not used, and a message is printed instead.
  final void Function()? onTap;

  /// The text description to be displayed on the button.
  ///
  /// If this value is provided, it will be shown alongside the image or icon.
  final String? description;

  /// The path to the image asset to be displayed on the button.
  ///
  /// If this value is provided, the image will be shown instead of an icon or logo.
  final String? imagePath;

  /// The icon to be displayed on the button.
  ///
  /// If this value is provided, it will be shown instead of an image or logo.
  final IconData? icon;

  /// Creates an [AuthButton] widget.
  ///
  /// The [radius] and [size] parameters are required, while [onTap], [description],
  /// [imagePath], and [icon] are optional.
  const AuthButton({
    super.key,
    this.onTap,
    required this.radius,
    required this.size,
    this.icon,
    this.imagePath,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Trigger the onTap callback if icon is null, otherwise print a message.
      onTap: onTap,
      child: Container(
        height: size.height.h, // Use ScreenUtil for responsive height
        width: size.width.w, // Use ScreenUtil for responsive width
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding:
            const EdgeInsets.only(left: 10, right: 10).w, // Responsive padding
        decoration: ShapeDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface, // Background color of the button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius)
                .r, // Rounded corners with given radius
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline, // Border color
              width: 1, // Border width
            ),
          ),
        ),
        child: (description != null)
            ? Row(
                children: [
                  // Display image or icon based on availability
                  (imagePath == null)
                      ? (icon != null)
                          ? Icon(
                              icon!,
                              color: Theme.of(context).colorScheme.onSurface,
                              size:
                                  (size.height * 0.4).h, // Responsive icon size
                            )
                          : FlutterLogo(
                              style: FlutterLogoStyle.markOnly,
                              size:
                                  (size.height * 0.4).h, // Responsive logo size
                            )
                      : Image.asset(
                          imagePath!,
                          height: (imagePath!.contains('google'))
                              ? (size.height * 0.3)
                                  .h // Smaller height for Google images
                              : (size.height * 0.4).h, // Default height
                        ),
                  Gap(10
                      .w), // Responsive gap between image/icon and description
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface, // Text color
                        ),
                  ),
                ],
              )
            : Center(
                child: (imagePath == null)
                    ? (icon != null)
                        ? Icon(
                            icon!,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: (size.height * 0.4).h, // Responsive icon size
                          )
                        : FlutterLogo(
                            style: FlutterLogoStyle.markOnly,
                            size: (size.height * 0.4).h, // Responsive logo size
                          )
                    : Image.asset(
                        imagePath!,
                        height: (imagePath!.contains('google'))
                            ? (size.height * 0.3)
                                .h // Smaller height for Google images
                            : (size.height * 0.4).h, // Default height
                        width: (size.width * 0.4).w, // Responsive width
                      ),
              ),
      ),
    );
  }
}
