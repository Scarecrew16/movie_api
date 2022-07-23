import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movie_api/src/helpers/debouncer.dart';
import 'package:movie_api/src/models/models.dart';
import 'package:movie_api/src/models/movies_recommend_response.dart';

class MoviesProvider extends ChangeNotifier {
  String baseUrl = 'api.themoviedb.org';
  String apiKey = 'c9592b235278cb33532263e0aa529001';
  String lenguage = 'es-ES';

  int _numberPage = 0;

  List<Movie> listMoviesPlaying = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};
  Map<int, List<Movie>> moviesRecommend = {};

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    print('MoviesProvider constructor..');
    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(baseUrl, endpoint,
        {'api_key': apiKey, 'language': lenguage, 'page': '$page'});

    var response = await http.get(url);

    return response.body;
  }

  getNowPlayingMovies() async {
    final responseData = await _getJsonData('3/movie/now_playing');
    final nowPlayingReponse = NowPlayingResponse.fromJson(responseData);

    listMoviesPlaying = nowPlayingReponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _numberPage++;

    final responseData = await _getJsonData('3/movie/popular', _numberPage);

    final popularMoviesResponse = PopularMoviesResponse.fromJson(responseData);
    popularMovies = [...popularMovies, ...popularMoviesResponse.results];
    notifyListeners();
  }

  Future<List<Movie>> getMoviesRecommend(int movieId) async {
    final responseData = await _getJsonData('3/movie/$movieId/recommendations');
    final moviesRecommendResponse =
        MoviesRecommendResponse.fromJson(responseData);

    moviesRecommend[movieId] = moviesRecommendResponse.results;

    return moviesRecommendResponse.results;
  }

  Future<List<Cast>> getCastByMovie(int movieId) async {
    print('request info from the actors server');

    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final responseData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(responseData);

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  //Future<List<Movie>> getMoviesByQuery(String query) async {
  //final URL = Uri.https(baseUrl, '3/search/movie',
  // {'api_key': apiKey, 'language': lenguage, 'query': query});

  //var response = await http.get(URL);

  //var responseSearch = SearchResponse.fromJson(response.body);

  //return responseSearch.results;
  //}

  void getSuggestionsByQuery(String sechtTerm) {
    debouncer.value = '';

    debouncer.onValue = (value) async {
      print('we have value to look for and we make the http request');
      //final result = await getMoviesByQuery(value);
      //_suggestionStreamController.add(result);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      debouncer.value = sechtTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((value) => timer.cancel());
  }
}
