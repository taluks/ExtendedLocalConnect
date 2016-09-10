# ExtendedLocalConnect
Пример использования:
var extendedLocalConnection:ExtendedLocalConnect = new ExtendedLocalConnect();
var client:ExtendedClient = new ExtendedClient(this);
extendedLocalConnection.target = client;
// Для приемника
extendedLocalConnection.connect("myConnection");
// Отправка данных
extendedLocalConnection.write("myConnection", "myFunction", data);
