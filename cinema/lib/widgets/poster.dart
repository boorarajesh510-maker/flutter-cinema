import 'package:flutter/material.dart';
import '../models/movie.dart';

/// Reusable gradient "poster" (works offline, no image assets needed).
class Poster extends StatelessWidget {
  final Movie movie;
  final bool compact;
  const Poster(this.movie, {super.key, this.compact = false});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [movie.c1, movie.c2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Material(
            type: MaterialType.transparency,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.movie_creation_outlined,
                  color: Colors.white70, size: compact ? 22 : 44),
              if (!compact) ...[
                const SizedBox(height: 8),
                Text(movie.title,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ]
            ]),
          ),
        ),
      );
}
