import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:llm_mobile_app/models/output.dart';
import 'package:llm_mobile_app/models/predict.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  String url = 'https://api.replicate.com/v1/predictions';
  Predict predict = Predict(
    id: '-1',
    model: "",
    version: "",
    max_new_tokens: 0,
    prompt: "",
    status: "",
    created_at: "",
    cancel_url: "",
    get_url: "",
    error: null,
  );

  Output output = Output(
    id: "-1",
    output: "",
    status: "",
    error: null,
  );

  Future<Predict> fetchPredictResponse(
      String prompt, int max_new_tokens) async {
    final response = await http.post(Uri.parse(url),
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Token r8_L8iGDNYyWGi6RFQ5d4HVdLCzP4deEPP2IBqvC'
        },
        body: jsonEncode(<String, dynamic>{
          "version":
              "322d1d41b8e44513994f9e5cd95cb5f228fd22262c5783efff612370a98608ff",
          "input": {"prompt": prompt + " # ", "max_new_tokens": max_new_tokens}
        }));
    if (response.statusCode == 201) {
      Predict p =
          Predict.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print(p.status);
      setState(() {
        predict = p;
      });
      return p;
      // return predict;
    } else {
      Predict p = Predict(
        id: "-1",
        model: "model",
        version: "version",
        max_new_tokens: max_new_tokens,
        prompt: prompt,
        status: "waiting for model",
        created_at: "",
        cancel_url: "",
        get_url: "",
        error: null,
      );
      print(p.status);
      setState(() {
        predict = p;
      });
      return p;
    }
    // return predict;
  }

  Future<Output> fetchOutput(String id) async {
    final response = await http.get(
      Uri.parse(url + "/" + id),
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Token r8_L8iGDNYyWGi6RFQ5d4HVdLCzP4deEPP2IBqvC'
      },
    );
    if (response.statusCode == 200) {
      Output o =
          Output.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print(o.status);
      setState(() {
        output = o;
      });
      return o;
      // return predict;
    } else {
      Output o = Output(
        id: "-1",
        output: "Model is running",
        status: "waiting for model prediction",
        error: null,
      );
      print(o.status);
      setState(() {
        output = o;
      });
      return o;
    }
    // return predict;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LLM - IIT Indore',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    hintText: 'Enter your query', border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(8),
                minimumSize: Size(100, 40),
              ),
              child: Text('Start'),
              onPressed: () async {
                // setState(() async {
                predict =
                    await fetchPredictResponse(controller.text.toString(), 100);
                // });
              },
            ),
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
              child: Text(
                predict.get_url,
                style: TextStyle(fontSize: 15),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(8),
                minimumSize: Size(100, 40),
              ),
              child: Text('Check'),
              onPressed: () async {
                // setState(() async {
                // predict =
                await fetchOutput(predict.id);

                // });
              },
            ),
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
              child: Text(
                output.output,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
