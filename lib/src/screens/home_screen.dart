import 'package:flutter/material.dart';
import 'package:movie_api/src/providers/movies_provider.dart';
import 'package:movie_api/src/search/search_delegate.dart';
import 'package:movie_api/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MoviesProvider providerMovies = Provider.of<MoviesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Nesflis',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  //showSearch(context: context, delegate: MovieSearchDelegate());
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CardSwiper(movies: providerMovies.listMoviesPlaying),
              MoviesSlider(
                  movies: providerMovies.popularMovies,
                  title: 'Popular',
                  onNextPage: () => providerMovies.getPopularMovies()),
            ],
          ),
        ));
  }
}
