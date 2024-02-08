import 'package:flutter/material.dart';

class PageStateChecker extends StatefulWidget {
  const PageStateChecker({super.key, required this.isLoading, required this.hasError, required this.content, this.onTryAgain});
final bool isLoading;

  final bool hasError;
  final Widget content;
  final Function()? onTryAgain;
  @override
  State<PageStateChecker> createState() => _PageStateCheckerState();
}

class _PageStateCheckerState extends State<PageStateChecker> {
  

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : widget.hasError
                    ? Center(
                        child: Column(
                          children: [
                            const Text(
                              "Something went wrong ",
                              style: TextStyle(color: Colors.amberAccent),
                            ),
                            ElevatedButton(
                                onPressed: widget.onTryAgain,
                                child: const Text("Try Again"))
                          ],
                        ),
                      )
                    : widget.content;
  }
}