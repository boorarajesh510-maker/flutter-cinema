import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/app_state.dart';
import 'poster.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final fav = s.isFav(movie.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/details', arguments: movie),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Stack(fit: StackFit.expand, children: [
              Hero(tag: 'poster${movie.id}', child: Poster(movie)),
              Positioned(
                top: 4, right: 4,
                child: IconButton.filledTonal(
                  onPressed: () => s.toggleFav(movie.id),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                    child: Icon(fav ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(fav), color: fav ? Colors.red : null),
                  ),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(' ${movie.rating}  •  ${movie.year}',
                    style: Theme.of(context).textTheme.bodySmall),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
