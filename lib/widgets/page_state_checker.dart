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
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Something went wrong ",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            ElevatedButton(
                                onPressed: widget.onTryAgain,
                                child:  Text("Try Again", style: TextStyle(color: Theme.of(context).colorScheme.secondary)))
                          ],
                        ),
                      )
                    : widget.content;
  }
}