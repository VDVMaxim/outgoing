import 'dart:math';

class NicknameGenerator {
  static const _adjectives = [
    'Swift',
    'Mystic',
    'Cosmic',
    'Shadow',
    'Electric',
    'Silent',
    'Golden',
    'Silver',
    'Neon',
    'Phantom',
    'Thunder',
    'Crystal',
    'Midnight',
    'Starlight',
    'Wild',
    'Gentle',
    'Brave',
    'Lucky',
    'Happy',
  ];

  static const _nouns = [
    'Ghoul',
    'Wolf',
    'Phantom',
    'Raven',
    'Storm',
    'Phoenix',
    'Dragon',
    'Hawk',
    'Tiger',
    'Panther',
    'Ninja',
    'Knight',
    'Wizard',
    'Sorcerer',
    'Mage',
    'Spirit',
    'Ghost',
    'Specter',
    'Wraith',
    'Demon',
  ];

  static String generate() {
    final random = Random();
    final adjective = _adjectives[random.nextInt(_adjectives.length)];
    final noun = _nouns[random.nextInt(_nouns.length)];
    return '$adjective $noun';
  }
}
