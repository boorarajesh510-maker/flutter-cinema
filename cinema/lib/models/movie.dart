import 'package:flutter/material.dart';

class Movie {
  final int id;
  final String title, genre, overview, director;
  final int year, minutes;
  final double rating;
  final List<String> cast;
  final Color c1, c2;
  const Movie(this.id, this.title, this.year, this.genre, this.rating,
      this.minutes, this.director, this.cast, this.overview, this.c1, this.c2);
}

class Review {
  final String name, comment;
  final double stars;
  final DateTime date;
  Review(this.name, this.comment, this.stars) : date = DateTime.now();
}

const movies = <Movie>[
  Movie(1, 'Inception', 2010, 'Sci-Fi', 8.8, 148, 'Christopher Nolan',
      ['Leonardo DiCaprio', 'Elliot Page', 'Tom Hardy'],
      'A thief who steals secrets through dreams is offered one last job: plant an idea instead of stealing one.',
      Color(0xFF1E3C72), Color(0xFF2A5298)),
  Movie(2, 'The Dark Knight', 2008, 'Action', 9.0, 152, 'Christopher Nolan',
      ['Christian Bale', 'Heath Ledger', 'Aaron Eckhart'],
      'Batman faces the Joker, a criminal mastermind who pushes Gotham into chaos.',
      Color(0xFF232526), Color(0xFF414345)),
  Movie(3, 'Interstellar', 2014, 'Sci-Fi', 8.7, 169, 'Christopher Nolan',
      ['Matthew McConaughey', 'Anne Hathaway', 'Jessica Chastain'],
      'Explorers travel through a wormhole to find a new home for humanity.',
      Color(0xFF0F2027), Color(0xFF2C5364)),
  Movie(4, 'Parasite', 2019, 'Thriller', 8.5, 132, 'Bong Joon-ho',
      ['Song Kang-ho', 'Choi Woo-shik', 'Park So-dam'],
      'A poor family schemes its way into the lives of a wealthy household.',
      Color(0xFF134E5E), Color(0xFF71B280)),
  Movie(5, 'The Godfather', 1972, 'Drama', 9.2, 175, 'Francis Ford Coppola',
      ['Marlon Brando', 'Al Pacino', 'James Caan'],
      'The aging patriarch of a crime dynasty hands control to his reluctant son.',
      Color(0xFF3E2723), Color(0xFF8D6E63)),
  Movie(6, 'Spirited Away', 2001, 'Animation', 8.6, 125, 'Hayao Miyazaki',
      ['Rumi Hiiragi', 'Miyu Irino', 'Mari Natsuki'],
      'A girl wanders into a world of spirits and must work to free her parents.',
      Color(0xFFFF9966), Color(0xFFFF5E62)),
  Movie(7, 'Mad Max: Fury Road', 2015, 'Action', 8.1, 120, 'George Miller',
      ['Tom Hardy', 'Charlize Theron', 'Nicholas Hoult'],
      'In a desert wasteland, a rebel and a drifter flee a tyrant across a relentless chase.',
      Color(0xFFD35400), Color(0xFFF39C12)),
  Movie(8, 'La La Land', 2016, 'Romance', 8.0, 128, 'Damien Chazelle',
      ['Ryan Gosling', 'Emma Stone', 'John Legend'],
      'A pianist and an aspiring actress chase their dreams in Los Angeles.',
      Color(0xFF614385), Color(0xFF516395)),
  Movie(9, 'Get Out', 2017, 'Horror', 7.7, 104, 'Jordan Peele',
      ['Daniel Kaluuya', 'Allison Williams', 'Bradley Whitford'],
      'A young man visiting his girlfriend\'s family uncovers a disturbing secret.',
      Color(0xFF1D2B64), Color(0xFFF8CDDA)),
  Movie(10, 'Toy Story', 1995, 'Animation', 8.3, 81, 'John Lasseter',
      ['Tom Hanks', 'Tim Allen', 'Don Rickles'],
      'A cowboy doll feels threatened when a flashy space ranger joins the toy box.',
      Color(0xFF2193B0), Color(0xFF6DD5ED)),
  Movie(11, 'The Shawshank Redemption', 1994, 'Drama', 9.3, 142, 'Frank Darabont',
      ['Tim Robbins', 'Morgan Freeman', 'Bob Gunton'],
      'Two imprisoned men bond over years, finding solace and hope through small acts of decency.',
      Color(0xFF373B44), Color(0xFF4286F4)),
  Movie(12, 'The Conjuring', 2013, 'Horror', 7.5, 112, 'James Wan',
      ['Vera Farmiga', 'Patrick Wilson', 'Lili Taylor'],
      'Paranormal investigators help a family terrorized by a dark presence in their farmhouse.',
      Color(0xFF200122), Color(0xFF6F0000)),
];

final genres = ['All', ...{for (final m in movies) m.genre}];
