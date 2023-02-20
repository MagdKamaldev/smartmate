import 'package:flutter/material.dart';
import 'package:smartmate/modules/register/register_screen.dart';
import 'package:smartmate/shared/components/components.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              navigateAndFinish(context, RegisterScreen());
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Privacy Policy for smartmate",
                style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 16.0),
            Text(
                "M Community is a social platform where users can share content with their friends and other users. We are committed to protecting the privacy of our users and this Privacy Policy outlines how we collect, use and disclose information we receive through our app.",
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 16.0),
            Text("Information Collection and Use:",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8.0),
            Text(
                "We collect information from you when you create an account, including your name, email address, and any other information you choose to provide. Additionally, we may collect information about your use of the app, such as the content you post and the actions you take on the app.",
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8.0),
            Text(
                "We use the information we collect to provide you with a personalized experience, to improve the quality of our services, and to communicate with you. We may also use your information to personalize the advertisements you see on the app.",
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 16.0),
            Text("Sharing of Information:",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8.0),
            Text(
                "We do not sell, rent or otherwise share your personal information with third parties for their marketing purposes without your consent. However, we may share your information in response to a legal request, such as a court order or subpoena, or in order to enforce our policies or protect the rights, property or safety of M Community, its users or others.",
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 16.0),
            Text("Security:", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8.0),
            Text(
                "We take the security of your information very seriously and use appropriate technical and organizational measures to protect it. However, no system can be 100% secure and we cannot guarantee the security of your information.",
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 16.0),
            Text(
                "We may update this Privacy Policy from magddevf@gmail.com time to time, so please review it periodically. If we make changes that materially affect the way we use your information, we will provide you with notice of such changes.",
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 16.0),
            Text("sexual content and hate speech ",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8.0),
            Text(
              "Sexual content and hate speech are totally unacceptable for this app and is not permitted in the app and if you found any unappropriate content report to magddevf@gmail.com and we will delete the post and the account of the publisher ",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16.0),
            Text("Children's Privacy",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8.0),
            Text(
              "Our app is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13. If you are under 13, please do not provide any personal information on our app or to us. ",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16.0),
            Text("Contact Us:", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8.0),
            Text(
                "If you have any questions or concerns about this Privacy Policy or our use of your information, please contact us at magddevf@gmail.com.",
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 16.0),
            Center(
              child: Text("Effective as of 9/2/2023.",
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
          ]),
        )));
  }
}
