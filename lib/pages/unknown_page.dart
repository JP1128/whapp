import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "404 Not Found",
              style: Get.textTheme.displayLarge,
            ),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () => Get.offAll('/'),
              child: Text(
                "Press to go back to home page",
                style: Get.textTheme.displayMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
