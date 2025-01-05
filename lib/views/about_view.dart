import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for rootBundle
import 'package:flutter_html/flutter_html.dart';
import '../uikit/ui_colors.dart';
import '../uikit/text_style.dart';

class AboutView extends StatelessWidget {
  static const String htmlPage = "assets/html/about.html";

  const AboutView({super.key});

  // Function to load the HTML file from assets
  Future<String> _loadHtmlFromAssets() async {
    return await rootBundle.loadString(htmlPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColor.white, // Set your desired background color here
      body: FutureBuilder<String>(
        future: _loadHtmlFromAssets(), // Load the HTML content
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while the file is being loaded
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show an error message if something goes wrong
            return const Center(child: Text('Error loading HTML content'));
          } else if (snapshot.hasData) {
            // If the data is available, display the HTML content
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Html(
                      data: snapshot.data, // Use the loaded HTML content
                      style: {
                        "p": Style(fontFamily: CustomTextStyle.fontFamily),
                        "h1": Style(fontFamily: CustomTextStyle.fontFamily),
                        "h2": Style(fontFamily: CustomTextStyle.fontFamily),
                        "h3": Style(fontFamily: CustomTextStyle.fontFamily),
                        "h4": Style(fontFamily: CustomTextStyle.fontFamily),
                        "h5": Style(fontFamily: CustomTextStyle.fontFamily),
                        "h6": Style(fontFamily: CustomTextStyle.fontFamily),
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No content available'));
          }
        },
      ),
    );
  }
}
