
class NotificationPayloadModel{

  String to = '';
  NotificationContent notification = NotificationContent(title: '', body: '');

  NotificationPayloadModel({required this.to, required this.notification});

  NotificationPayloadModel.fronJson(Map<String,dynamic> data){
    to = data['to'];
    notification = data['notification'] != null
        ? NotificationContent.fronJson(data['notification'])
        : NotificationContent(title: '', body: '');
  }

  Map<String,dynamic> toJson(){
    final data = <String,dynamic>{};
    data['to'] = to;
    data['notification'] = notification;
    return data;
  }

}

class NotificationContent {
  String title = '', body = '';

  NotificationContent({required this.title, required this.body});

  NotificationContent.fronJson(Map<String,dynamic> data){
    title = data['title'];
    body = data['body'];
  }

  Map<String,dynamic> toJson(){
    final data = <String,dynamic>{};
    data['title'] = title;
    data['body'] = body;
    return data;
  }

}

