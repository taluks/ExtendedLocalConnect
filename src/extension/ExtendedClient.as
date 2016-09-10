package extension
{
	import flash.utils.ByteArray;

	public class ExtendedClient
	{		
		private var receivedData:ByteArray = new ByteArray();
		private var length:int = -1;
		/** Пользовательский класс - обработчик*/
		private var client:Object;
		public function ExtendedClient(client:Object)
		{
			this.client = client;
		}
		/**
		 * Метод удаленного вызова.
		 * @param packet - входящие данные.
		 */		
		public final function reciverLocalConnection(packet:ByteArray):void
		{
			// Читаем длину всего сообщения
			if(length == -1) length = packet.readUnsignedInt();
			
			packet.readBytes(receivedData, receivedData.length, packet.length - packet.position);
			// Если необходимое количество данных принять
			if(receivedData.length == length)
			{
				// Обрабатываем полученные данные
				deserialization(receivedData);
				receivedData = new ByteArray();
				length = -1;
			}
		}
		/**
		 * Десериализаия данных.
		 * @param receivedData - принятые данные.
		 */		
		private final function deserialization(receivedData:ByteArray):void
		{
			var parameters:Array = new Array();
			var temp:ByteArray = new ByteArray();
			while(receivedData.position != receivedData.length)
			{
				receivedData.readBytes(temp, 0, receivedData.readUnsignedInt() - 4);
				parameters.push(temp.readObject());
				temp.clear();
			}
			try
			{	// Отправляем данные в запрашиваемый мтод
				(client[parameters[0]] as Function).apply(this, parameters.slice(1));
			}catch(error:ReferenceError)
			{
				trace("Error:", error.message);
			}
		}
	}
}