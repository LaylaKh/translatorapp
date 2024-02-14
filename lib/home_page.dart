import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/cats_facts_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List list = [for(int i=0; i < 10; i++) i]; //массив с помощью цикла от 0 до 10
  // List<CatsFactsModel> list = [];

  List<String>? list;
  final translator = GoogleTranslator();
  SharedPreferences? prefs;

  void initPage() async {
    prefs = await SharedPreferences.getInstance();
    list = prefs?.getStringList('catsFacts');
    setState(() {});
    }

  @override
  void initState() {
    initPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cats',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: list?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(25)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                list?[index].toString() ?? '',
                                style: const TextStyle(fontSize: 25),
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),

                                    onPressed: () async {
                                     await translator.translate(list?[index] ?? '',
                                       to: 'ru').then((value) {
                                        list?[index] = value.toString();
                                       },
                                      );
                                      prefs?.setStringList('catsFacts', list ?? []);
                                      setState(() {});
                                    },
                                    child: const Text('Ru'),
                                  ),
                                  const Spacer(),
                                   ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await translator
                                      .translate(list?[index] ?? '',
                                       to: 'en')
                                       .then((value) {
                                        list?[index] = value.toString();
                                      });
                                      prefs?.setStringList('catsFacts', list ?? []);
                                      setState(() {});
                                    },
                                    child: const Text('En'),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed:  getCatsFacts,
                  child: const Icon(
                    Icons.add,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    list?.removeLast();
                    prefs?.setStringList('catsFacts', list ?? []);
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.remove,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

 Future<void> getCatsFacts() async {
    final dio = Dio();
    // ignore: unused_local_variable
    final response = await dio.get('https://catfact.ninja/fact');
    final result = CatsFactsModel.fromJson(response.data);
    list?.add(result.fact ?? '');
    prefs?.setStringList('catsFacts', list?? []);
    //print(prefs?.getStringList('catsFacts'));
    setState(() {});
  }
}
