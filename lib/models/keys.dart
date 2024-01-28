class Keys {
  late final String title;
  late final String chave;

  Keys({required this.title, required this.chave}); // Construtor da classe

  // Método para converter o objeto em um Map
  Map<String, String> toJson() => {
        "title": title,
        "chave": chave,
      };

  // Método para criar um objeto a partir de um Map
  factory Keys.fromJson(Map<String, dynamic> json) {
    return Keys(
      title: json["title"],
      chave: json["chave"],
    );
  }
}
