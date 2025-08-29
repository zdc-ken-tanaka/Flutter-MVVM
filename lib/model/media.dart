class Media {
  final int? trackId;
  final String? artistName;
  final String? collectionName;
  final String? trackName;
  final String? artworkUrl;
  final String? previewUrl;
  final bool isFavorite;

  Media(
      {this.trackId,
      this.artistName,
      this.collectionName,
      this.trackName,
      this.artworkUrl,
      this.previewUrl,
      this.isFavorite = false});


  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      trackId: json['trackId'] as int?,
      artistName: json['artistName'] as String?,
      collectionName: json['collectionName'] as String?,
      trackName: json['trackName'] as String?,
      artworkUrl: json['artworkUrl100'] as String?,
      previewUrl: json['previewUrl'] as String?,
      isFavorite: false,
    );
  }

  Media copyWith({
    int? trackId,
    String? artistName,
    String? collectionName,
    String? trackName,
    String? artworkUrl,
    String? previewUrl,
    bool? isFavorite,
  }) {
    return Media(
      trackId: trackId ?? this.trackId,
      artistName: artistName ?? this.artistName,
      collectionName: collectionName ?? this.collectionName,
      trackName: trackName ?? this.trackName,
      artworkUrl: artworkUrl ?? this.artworkUrl,
      previewUrl: previewUrl ?? this.previewUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
