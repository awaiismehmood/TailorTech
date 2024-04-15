import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/chat/common/enums/msg_enum.dart';

class Message {
  final String Senderid;
  final String recieverid;
  final String Text;
  final Messageenum type;
  final DateTime timesent;
  final String messageid;
  final bool isseen;

  Message({
    required this.Senderid,
    required this.recieverid,
    required this.Text,
    required this.type,
    required this.timesent,
    required this.messageid,
    required this.isseen,
  });

  Map<String, dynamic> toMap() {
    return {
      'Senderid': Senderid,
      'recieverid': recieverid,
      'Text': Text,
      'type': type.type,
      'timesent': timesent,
      'messageid': messageid,
      'isseen': isseen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      Senderid: map['Senderid'] ?? '',
      recieverid: map['recieverid'] ?? '',
      Text: map['Text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timesent: (map['timesent'] as Timestamp).toDate(),
      messageid: map['messageid'] ?? '',
      isseen: map['isseen'] ?? false,
    );
  }
}
