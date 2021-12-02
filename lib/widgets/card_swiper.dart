import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/models/movie.dart';

class CardSwiper extends StatefulWidget {
  final List<Movie> movies;
  
  final Function onNextPage;

  const CardSwiper({Key? key, required this.movies, required this.onNextPage}) : super(key: key);

  @override
  State<CardSwiper> createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper> {
  final SwiperController swiperController = SwiperController();

  @override
  void initState() {
    super.initState();
    swiperController.addListener(() { 
      print(swiperController.index);
      print(swiperController.pos);

      if(swiperController.index == widget.movies.length){
        widget.onNextPage();
      }

    });
  }

  @override
  void dispose() {
    
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (this.widget.movies.length == 0) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      width: double.infinity,
      height: size.height * 0.5,
      //color: Colors.red,
      child: Swiper(
        controller: swiperController,
        scrollDirection: Axis.horizontal,
        loop: false,
        //onIndexChanged: ,
        itemCount: /*10,*/ widget.movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (_, int index) {
          final movie = widget.movies[index];
          print(movie.fullPosterImg);
          movie.heroId = 'swiper-${movie.id}';
          //movies[index].fullPosterImg;

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'details', arguments: movie);
            },
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(
                      /*'https://via.placeholder.com/300x400'*/ movie
                          .fullPosterImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
