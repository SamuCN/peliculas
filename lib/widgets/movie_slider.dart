import 'package:flutter/material.dart';
import 'package:peliculas/models/movie.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? titulo;

  final Function onNextPage;

  const MovieSlider(
      {Key? key, required this.movies, required this.onNextPage, this.titulo})
      : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        //print('Obtener siguiente pagina');
        widget.onNextPage();
      }

      //print(scrollController.position.pixels);
      //print(scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.movies.length == 0) {
      return Container(
        width: double.infinity,
        height: 260,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (this.widget.titulo == null) {
      return Container(
        width: double.infinity,
        height: 260,
      );
    }
    return Container(
      width: double.infinity,
      height: 260,
      //color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.titulo!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: /*20*/ widget.movies.length,
              itemBuilder: (context, int index) {
                // => _MoviePoster(); eliminando las llaves
                return _MoviePoster(movie: widget.movies[index], heroId: '${ widget.titulo }-$index-${ widget.movies[index].id }' );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroId;

  const _MoviePoster({Key? key, required this.movie, required this.heroId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      //color: Colors.green,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'details', arguments: movie);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Hero(
                tag: movie.heroId!,
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(
                      /*'https://via.placeholder.com/300x400'*/ movie
                          .fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
