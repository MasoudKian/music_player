abstract class PlayListRepository {
  Future<List<Map<String, String>>> fetchMyPlayList();
}

class MyPlayList extends PlayListRepository {
  @override
  Future<List<Map<String, String>>> fetchMyPlayList() async {
    const song1 =
        'https://dl.mokhtalefmusic.com/music/1398/02/26/Deep%20House/Jay%20Aliev%20Deep.mp3';
    const song2 =
        'https://avapedia.com/station/24054/masih-to-ke-nisti-pisham-ft-arash-ap/d?nonce=05c8a58693';
    const song3 =
        'https://avapedia.com/station/2497/shah-beyt/d?nonce=05c8a58693';
    const song4 =
        'https://avapedia.com/station/24044/khabe-khoob/d?nonce=05c8a58693';
    const song5 =
        'https://avapedia.com/station/24052/aroome-del/d?nonce=05c8a58693';

    return [
      {
        'id': '0',
        'title': 'Deep House 1',
        'artist': 'Ethnic',
        'artUri': 'https://mahni-music.com/wp-content/uploads/65545.jpg',
        'url': song1,
      },
      {
        'id': '1',
        'title': 'Deep House 1',
        'artist': 'Ethnic',
        'artUri': 'https://mahni-music.com/wp-content/uploads/69929.jpg',
        'url': song2,
      },
      {
        'id':'2',
        'title':'Deep House 2',
        'artist':'Ethnic',
        'artUri':'https://mahni-music.com/wp-content/uploads/001-8.jpg',
        'url' : song3,
      },
      {
        'id':'3',
        'title':'Deep House 3',
        'artist':'Ethnic',
        'artUri':'https://mahni-music.com/wp-content/uploads/2021/11/001-154.jpg',
        'url' : song4,
      },
      {
        'id':'4',
        'title':'Deep House 4',
        'artist':'Ethnic',
        'artUri':'https://mahni-music.com/wp-content/uploads/2021/11/001-147.jpg',
        'url' : song5,
      },

    ];
  }
}
