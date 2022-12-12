import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/google_sheet.dart';
import 'package:movie_app/services/payment.dart';
import 'package:movie_app/ui/screens/payment_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key, required this.movie});

  final Movie movie;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool loading = false;

  void setLoading(bool value) {
    if (mounted) {
      setState(() {
        loading = value;
      });
    }
  }

  String? paymentStatus;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Hero(
                tag: widget.movie.id,
                child: Container(
                  width: screenSize.width * 0.55,
                  height: screenSize.width * 0.8,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.movie.imageUrl)),
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Buy 1 Ticket for',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                widget.movie.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              paymentStatus == null
                  ? MaterialButton(
                      onPressed: loading
                          ? null
                          : () async {
                              try {
                                setLoading(true);
                                final data = await Payment.getCheckoutLink(
                                  name: nameController.text,
                                  email: emailController.text,
                                  movie: widget.movie,
                                );
                                // ignore: use_build_context_synchronously
                                await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (_) =>
                                            PaymentScreen(url: data['link'])));
                                await Future.delayed(
                                    const Duration(seconds: 5));
                                final payment = await Payment.verifyPayment(
                                    data['reference']);

                                final amount = payment['amount'];
                                final paymentReference = payment['reference'];
                                final merchantReference =
                                    payment['merchantReference'];
                                final status = payment['status'];
                                final paymentDate = payment['updatedAt'];
                                final movieName = widget.movie.name;
                                final fullName = nameController.text;
                                final email = emailController.text;

                                SheetsAPI.updateBoughtTicket(
                                  email: email,
                                  fullName: fullName,
                                  movieName: movieName,
                                  paymentDate: paymentDate,
                                  status: status,
                                  merchantReference: merchantReference,
                                  paymentReference: paymentReference,
                                  amount: amount.toString(),
                                );
                                setState(() {
                                  paymentStatus = status;
                                });
                              } catch (e) {
                                print(e);
                              }
                              setLoading(false);
                            },
                      minWidth: double.infinity,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Colors.red,
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Text(
                              "Pay Now",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                    )
                  : Text(
                      'Payment Status: $paymentStatus',
                      style: const TextStyle(fontSize: 16),
                    ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
