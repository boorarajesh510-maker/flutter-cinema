import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/app_state.dart';
import '../theme.dart';
import '../widgets/movie_card.dart';
import '../widgets/poster.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  static const _pages = [ExplorePage(), FavoritesPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      final wide = box.maxWidth >= 800; // tablet/desktop → side rail
      final extended = box.maxWidth >= 1100;
      return Scaffold(
        body: Row(children: [
          if (wide)
            NavigationRail(
              selectedIndex: _index,
              extended: extended,
              labelType: extended ? null : NavigationRailLabelType.all,
              onDestinationSelected: (i) => setState(() => _index = i),
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Icon(Icons.local_movies, color: kBrand, size: 32),
              ),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.explore), label: Text('Explore')),
                NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
                NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profile')),
              ],
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: KeyedSubtree(key: ValueKey(_index), child: _pages[_index]),
            ),
          ),
        ]),
        bottomNavigationBar: wide
            ? null
            : NavigationBar(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.explore), label: 'Explore'),
                  NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
                  NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
                ],
              ),
      );
    });
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final list = s.filtered;
    final width = MediaQuery.of(context).size.width;
    final cols = columnsFor(width);
    final f = s.featured;

    return CustomScrollView(slivers: [
      const SliverAppBar(
        floating: true,
        title: Text('CINEMA', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 4)),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Hi ${s.userName ?? 'there'} 👋',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            // Featured banner (Stack + gradient)
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/details', arguments: f),
              child: Container(
                height: width > 700 ? 240 : 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [f.c1, f.c2]),
                ),
                child: Stack(children: [
                  const Positioned(
                      right: 16, top: 16,
                      child: Icon(Icons.movie_filter, size: 90, color: Colors.white24)),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Chip(label: Text('⭐ Top Rated')),
                          Text(f.title,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                          Text('${f.genre} • ${f.year} • ${f.rating}/10',
                              style: const TextStyle(color: Colors.white70)),
                        ]),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: s.setQuery,
              decoration: const InputDecoration(
                  hintText: 'Search movies...', prefixIcon: Icon(Icons.search)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: genres.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ChoiceChip(
                  label: Text(genres[i]),
                  selected: s.genre == genres[i],
                  onSelected: (_) => s.setGenre(genres[i]),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ]),
        ),
      ),
      if (list.isEmpty)
        const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('No movies found 🎬')))
      else
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                childAspectRatio: .66,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14),
            delegate: SliverChildBuilderDelegate(
              (_, i) => TweenAnimationBuilder<double>(
                key: ValueKey(list[i].id),
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 300 + i * 60),
                builder: (_, v, child) => Opacity(opacity: v, child: child),
                child: MovieCard(list[i]),
              ),
              childCount: list.length,
            ),
          ),
        ),
    ]);
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final favs = s.favorites;
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: favs.isEmpty
          ? const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.favorite_border, size: 64),
                SizedBox(height: 8),
                Text('No favorites yet. Tap ♥ on any movie!'),
              ]))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: favs.length,
                  itemBuilder: (_, i) {
                    final Movie m = favs[i];
                    return Dismissible(
                      key: ValueKey(m.id),
                      background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white)),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => s.toggleFav(m.id),
                      child: Card(
                        child: ListTile(
                          leading: SizedBox(width: 48, height: 48, child: Poster(m, compact: true)),
                          title: Text(m.title),
                          subtitle: Text('${m.genre} • ${m.year} • ⭐ ${m.rating}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () =>
                              Navigator.pushNamed(context, '/details', arguments: m),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView(padding: const EdgeInsets.all(20), children: [
            const CircleAvatar(
                radius: 44, backgroundColor: kBrand,
                child: Icon(Icons.person, size: 48, color: Colors.white)),
            const SizedBox(height: 12),
            Text(s.userName ?? 'Guest',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall),
            Text(s.userEmail ?? '', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Row(children: [
              _Stat('Favorites', '${s.favCount}', Icons.favorite),
              const SizedBox(width: 12),
              _Stat('Reviews', '${s.reviewCount}', Icons.rate_review),
            ]),
            const SizedBox(height: 12),
            Card(
              child: SwitchListTile(
                title: const Text('Dark mode'),
                secondary: const Icon(Icons.dark_mode),
                value: s.themeMode == ThemeMode.dark,
                onChanged: (_) => s.toggleTheme(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                s.logout();
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Log out'),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _Stat(this.label, this.value, this.icon);
  @override
  Widget build(BuildContext context) => Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Icon(icon, color: kBrand),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              Text(label),
            ]),
          ),
        ),
      );
}
