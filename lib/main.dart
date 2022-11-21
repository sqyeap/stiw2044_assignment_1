import 'dart:convert';
import 'dart:async';
import 'package:ndialog/ndialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Material App',
            home: Scaffold(
                appBar: AppBar(
                    title: const Text('Movies Searcher'),
                    backgroundColor: Colors.deepPurple
                ),
                body: const HomePage(),
            ),
            theme: ThemeData(
                primarySwatch: Colors.blue,
                brightness: Brightness.dark
            ),
        );
    }
}

class HomePage extends StatefulWidget {
    const HomePage({super.key});
    
      @override
      State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    TextEditingController textEditingController = TextEditingController();

    var title = "",
        genre = "",
        year = "",
        actor = "",
        posterUrl = "http://via.placeholder.com/300x350?text=No+Movie+Found",
        desc = "";
    
    @override
    Widget build(BuildContext context) {
        return Center(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                        children: [
                            const Text("Search for Movie",
                                style: TextStyle(
                                    fontSize: 24, 
                                    fontWeight: FontWeight.bold
                                ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                                controller: textEditingController,
                                decoration: const InputDecoration(
                                    labelText: "Movie Title",
                                    border: OutlineInputBorder(),
                                ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                                onPressed: _loadMovie,
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    minimumSize: const Size(128, 48),
                                    textStyle: const TextStyle(fontSize: 20)
                                ),
                                child: const Text("Search"),
                            ),
                            const SizedBox(height: 24),
                            Text(
                                desc
                            ),
                            CachedNetworkImage(
                                imageUrl: posterUrl,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    Future<void> _searchMovie() async {
        String search = textEditingController.text;
        var apikey = "44a81623";
        var url = Uri.parse('https://www.omdbapi.com/?t=$search&apikey=$apikey');
        var response = await http.get(url);
        var rescode = response.statusCode;
        if (rescode == 200) {
            var jsonData = response.body;
            var parsedJson = json.decode(jsonData);
            setState(() {
                title = parsedJson['Title'];
                year = parsedJson['Year'];
                genre = parsedJson['Genre'];
                actor = parsedJson['Actors'];
                posterUrl = parsedJson['Poster'];
                desc =
                    " Movie Title:\t $title\n\n Year:\t $year\n\n Genre:\t $genre\n\n Actors:\t $actor\n\n Poster: \n";
            });
        }
    }

    _loadMovie() async {
        ProgressDialog progressDialog = ProgressDialog(
            context,
            message: const Text("Progress"), 
            title: const Text("Searching...")
        );
        progressDialog.show();
        _searchMovie();
        progressDialog.dismiss();
        Fluttertoast.showToast(
            msg: "Movie Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0
        );
    }
}