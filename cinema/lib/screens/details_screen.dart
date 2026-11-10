import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/app_state.dart';
import '../widgets/poster.dart';

class DetailsScreen extends StatelessWidget {
  final Movie movie;
  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final fav = s.isFav(movie.id);
    final reviews = s.reviewsFor(movie.id);
    final theme = Theme.of(context);

    final poster = Hero(
      tag: 'poster${movie.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(aspectRatio: 2 / 3, child: Poster(movie)),
      ),
    );

    final info = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(movie.title, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 4, children: [
        Chip(label: Text(movie.genre)),
        Chip(label: Text('${movie.year}')),
        Chip(label: Text('${movie.minutes} min')),
        Chip(avatar: const Icon(Icons.star, color: Colors.amber, size: 18),
            label: Text('${movie.rating}/10')),
      ]),
      const SizedBox(height: 12),
      Text(movie.overview, style: theme.textTheme.bodyLarge),
      const SizedBox(height: 12),
      Text('Director: ${movie.director}', style: theme.textTheme.titleSmall),
      const SizedBox(height: 8),
      Wrap(spacing: 6, children: [for (final c in movie.cast) Chip(label: Text(c))]),
      const SizedBox(height: 16),
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: fav ? [BoxShadow(color: Colors.red.withOpacity(.4), blurRadius: 16)] : []),
        child: FilledButton.icon(
          onPressed: () => s.toggleFav(movie.id),
          icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
          label: Text(fav ? 'In Favorites' : 'Add to Favorites'),
        ),
      ),
    ]);

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              LayoutBuilder(builder: (_, box) {
                if (box.maxWidth >= 650) {
                  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: 260, child: poster),
                    const SizedBox(width: 24),
                    Expanded(child: info),
                  ]);
                }
                return Column(children: [
                  SizedBox(width: 200, child: poster),
                  const SizedBox(height: 16),
                  info,
                ]);
              }),
              const Divider(height: 40),
              Text('Reviews (${reviews.length})', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              ReviewForm(movieId: movie.id),
              const SizedBox(height: 12),
              for (final r in reviews)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(r.name[0].toUpperCase())),
                    title: Row(children: [
                      Text(r.name),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${r.stars.toStringAsFixed(1)}'),
                    ]),
                    subtitle: Text(r.comment),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}

class ReviewForm extends StatefulWidget {
  final int movieId;
  const ReviewForm({super.key, required this.movieId});
  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: context.read<AppState>().userName ?? '');
  final _comment = TextEditingController();
  double _stars = 4;

  @override
  void dispose() { _name.dispose(); _comment.dispose(); super.dispose(); }

  void _submit() {
    if (!_key.currentState!.validate()) return;
    context.read<AppState>().addReview(
        widget.movieId, Review(_name.text.trim(), _comment.text.trim(), _stars));
    _comment.clear();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Review submitted ✅')));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Write a review', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Your name'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),
            Row(children: [
              Text('Rating: ${_stars.toStringAsFixed(1)}'),
              Expanded(
                child: Slider(
                    value: _stars, min: 1, max: 5, divisions: 8,
                    onChanged: (v) => setState(() => _stars = v)),
              ),
            ]),
            TextFormField(
              controller: _comment,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Comment'),
              validator: (v) => (v == null || v.trim().length < 10)
                  ? 'Comment must be at least 10 characters' : null,
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _submit, child: const Text('Submit Review')),
          ]),
        ),
      ),
    );
  }
}
