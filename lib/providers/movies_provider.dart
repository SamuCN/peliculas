
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/credits_response.dart';
import 'package:peliculas/models/movie.dart';
import 'package:peliculas/models/now_playing_response.dart';
import 'package:peliculas/models/popular_response.dart';
import 'package:peliculas/models/search_response.dart';

//import 'package:flutter/cupertino.dart';

class MoviesProvider extends ChangeNotifier{

  String _apiKey = '349be4e8c2fa7c18f49d10b1c14d745a';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-Es';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = []; 
  Map<int, List<Cast>> movieCast = {};

  int _popularPage = 0;
  int _nowPlayingPage = 0;

  MoviesProvider(){
    print('Movies Providers inicializada');
    
    this.getOnNowMovies();
    this.getPopularMovies();
      }

      Future<String>_getJsonData(String endpoint, [int page = 1])async{
        final url = Uri.https(_baseUrl, endpoint, {
           'api_key': _apiKey,
           'language': _language,
           'page': '$page'
         });
         final response = await http.get(url);
        return response.body;

      }
    
      getOnNowMovies() async{
         /*final url = Uri.https(_baseUrl, '3/movie/now_playing', {
           'api_key': _apiKey,
           'language': _language,
           'page': '1'
         });
         final response = await http.get(url);*/
         _nowPlayingPage++;
         final jsonData = await this._getJsonData('3/movie/now_playing', _nowPlayingPage);
         //final nowPlayingResponse = NowPlayingResponse.fromJson(response.body);
         final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
         
         //final Map<String, dynamic> decodedData = json.decode(response.body);
        
         //print(decodedData['results']);
    
         //print(nowPlayingResponse.results[0].title);
         onDisplayMovies = [ ...onDisplayMovies, ...nowPlayingResponse.results ];
    
         notifyListeners();
        
    
      }
    
      getPopularMovies() async {
        /*final url = Uri.https(_baseUrl, '3/movie/popular', {
           'api_key': _apiKey,
           'language': _language,
           'page': '1'
         });
         final response = await http.get(url);*/
         _popularPage++;
         final jsonData = await this._getJsonData('3/movie/popular', _popularPage);
         final popularResponse = PopularResponse.fromJson(jsonData);
         
         //final Map<String, dynamic> decodedData = json.decode(response.body);
        
         //print(decodedData['results']);
    
         //print(nowPlayingResponse.results[0].title);
         popularMovies = [ ...popularMovies, ...popularResponse.results ];
         //print(popularMovies[0]);
    
         notifyListeners();
      }

      Future <List<Cast>> getMovieCast (int movieId) async{
        
        if(movieCast.containsKey(movieId)) return movieCast[movieId]!;
        //print('pidiendo info al servidor - Cast');

        final jsonData = await this._getJsonData('3/movie/$movieId/credits');
        final creditsResponse = CreditsResponse.fromJson(jsonData);

        movieCast[movieId] = creditsResponse.cast;

        return creditsResponse.cast;


      }

      Future <List<Movie>> searchMovies (String query) async {

        final url = Uri.https(_baseUrl, '3/search/movie', {
           'api_key': _apiKey,
           'language': _language,
           'query': query
         });
         final response = await http.get(url);
         final searchResponse = SearchResponse.fromJson(response.body);
         
         return searchResponse.results;


      }
}