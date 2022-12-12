import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.url});
  final String url;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double loaded = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top,
          ),
          LinearProgressIndicator(
              value: loaded,
              minHeight: 7,
              color: Colors.green,
              backgroundColor: Colors.green[100]),
          Expanded(
            child: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                onProgress: (progress) => setState(() {
                      loaded = progress / 100;
                    })),
          ),
        ],
      ),
    );
  }
}
