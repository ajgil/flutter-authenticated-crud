// clase abstracta, para si posteriormente queremos cambiar la implementacion
// debe cumplir las reglas que añadimos aqui
// con esta clase abstracta podemos cambiar shared preferences por cualquier otro paquete

// este es un patron adaptador

abstract class KeyValueStorageService {

// no puede ser dynamic el value, si podemos indicar que sea de tipo T
// El T significa que es un genérico, significa, si yo envio un int tratalo como int y asi con cualquiera
Future<void> setKeyValue<T>(String key, T value);
Future<T?> getValue<T>(String key); // regresamos un genérico opcional ya que puede que esa key exista o no
Future<bool> removeKey(String key);
}