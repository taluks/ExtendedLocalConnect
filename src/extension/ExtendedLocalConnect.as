package extension
{
	import flash.net.LocalConnection;
	import flash.utils.ByteArray;
	
	public class ExtendedLocalConnect extends LocalConnection
	{
		private static const METHOD_NAME:String = "reciverLocalConnection";
		/** Максимальный размер блока данных*/
		private var _blockWeight:int;
		private var _complete:Boolean = true;
		public function ExtendedLocalConnect()
		{
			super();
		}
		/**
		 * Метод отправки данных.
		 * @param localConnectionName - имя подключения. 
		 * @param args - аргументы, первым должено идти название вызываемого метода.
		 */		
		public final function write(localConnectionName:String, ... args):void
		{
			// 63 байта занимает дополнительная информация необходимая для передачи данных
			_blockWeight = 40897 - localConnectionName.length - METHOD_NAME.length;
			
			_complete = false;
			var bytes:ByteArray = new ByteArray();
			// Оставляем место для длины данных сообщения
			bytes.writeUnsignedInt(0);
			// Сериализуем все аргументы
			for(var i:int = 0, n:int = args.length; i < n; i++)
			{
				var startPosition:int = bytes.position;
		
				bytes.writeUnsignedInt(0);
				bytes.writeObject(args[i]);
				bytes.position = startPosition;
				// Записываем длину данных объекта	
				bytes.writeUnsignedInt(bytes.length - startPosition);
				bytes.position = bytes.length;
			}
			bytes.position = 0;
			//Записываем длину данных сообщения
			bytes.writeUnsignedInt(bytes.length - 4);
			bytes.position = 0;
			
			var bytesLength:int = bytes.length;
			
			var currentPosition:int = 0;
			var currentLength:int = bytesLength;
			while(currentLength > 0)
			{
				var packageLength:int = (currentLength > _blockWeight)? _blockWeight: currentLength;
				
				var packet:ByteArray = new ByteArray();
				// Формируем пакет данных
				bytes.readBytes(packet, 0, packageLength);
				currentPosition += packageLength;
				currentLength = bytesLength - currentPosition;
				
				if(!currentLength)
					_complete = true;
				// Отправляем пакет
				send(localConnectionName, METHOD_NAME, packet);
			}	
			bytes.clear();
		}
		public function set target(extendedClient:ExtendedClient):void
		{
			client = extendedClient;
		}

		public function get complete():Boolean
		{
			return _complete;
		}
	}
}