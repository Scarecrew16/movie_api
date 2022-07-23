import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:movie_api/src/models/models.dart';

class CardSwiper extends StatelessWidget {
  List<Movie> movies;

  CardSwiper({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    if (movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: deviceSize.height * 0.6,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 159, 107, 175),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: deviceSize.height * 0.6,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: deviceSize.width * 0.6,
        itemHeight: deviceSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          final movie = movies[index];

          movie.heroId = 'swiper-${movie.id}';

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'details', arguments: movie);
            },
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/no-image.jpg',
                  image: movie.getFullPosterImage(),
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
