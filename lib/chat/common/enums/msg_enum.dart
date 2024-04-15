enum Messageenum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const Messageenum(this.type);
  final String type;
}

// Using an extension
// Enhanced enums

extension ConvertMessage on String {
  Messageenum toEnum() {
    switch (this) {
      case 'audio':
        return Messageenum.audio;
      case 'image':
        return Messageenum.image;
      case 'text':
        return Messageenum.text;
      case 'gif':
        return Messageenum.gif;
      case 'video':
        return Messageenum.video;
        
      default:
        return Messageenum.text;
    }
  }
}
