# ExtendedLocalConnect
 
Описание задачи https://habrahabr.ru/post/246119/

Пример инициализации:

    var extendedLocalConnection:ExtendedLocalConnect = new ExtendedLocalConnect();
    var client:ExtendedClient = new ExtendedClient(this);
     extendedLocalConnection.target = client;
Подключение:

     extendedLocalConnection.connect("myConnection");
Отправка данных:

     extendedLocalConnection.write("myConnection", "myFunction", data);
