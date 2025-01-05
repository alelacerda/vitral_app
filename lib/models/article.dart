class Article {
  final String image;
  final String title;
  final String content;
  String shortContent = '';

  Article({
    required this.image, 
    required this.title, 
    required this.content,
    required this.shortContent,
  });

  factory Article.fromMap(Map<String, dynamic> map) {

    String content = map['content'];
    // get content inside <p> tag to show in the card and limit the lenght to 100 characters
    String shortContent = content.substring(content.indexOf('<p>') + 3, content.indexOf('</p>'));
    if (shortContent.length > 100) {
      shortContent = '${shortContent.substring(0, 100)}...';
    }

    return Article(
      image: map['image'],
      title: map['title'],
      content: map['content'],
      shortContent: shortContent
    );
  }

  static Article empty() {
    return Article(
      image: '',
      title: '',
      content: '',
      shortContent: ''
    );
  }
}