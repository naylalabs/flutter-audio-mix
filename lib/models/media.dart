class Media {
  Media({
    this.artUri,
    this.url,
  });

  String? artUri;
  String? url;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    artUri: json["artUri"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "artUri": artUri,
    "url": url,
  };
}