# am085 sqflite todo list

**vr.251227**

Ed ora, a partire da, `am032_todo_list` introduciamo SQLite per salvare le note nella nostra app
un po' come in [1] senza lavorare col *singleton* (farlo per esercizio).

# model

La classe `Todo` presenta l'oggetto che verrà salvato in modo persistente nel database.
Interessanti i metodo che ci permettono il *serializing* e il *deserializing**.
```
Todo <--> Maps(String, dynamic)
```
Il *serializing* di un `Todo` in `Map<String, dynamic>` potrà essere agevolmente utilizzato nelle *query*. Notiamo l'uso della *keyword* `factory`!

## l'helper

Nulla di nuovo rispetto all'esempio precedente con l'eccezione che siamo passati all'uso delle query non *raw* )scritte in SQL). Rimandiamo a [3] e [5]. 

## materiali

[1] SQLite database [qui](https://sqlite.org/datatype3.html).  
[2] "SQLite in Flutter: The Complete Guide" di Arslan Yousaf [qui](https://dev.to/arslanyousaf12/sqlite-in-flutter-the-complete-guide-11nj).  
[3] `sqflite` API [qui]().  
[4] SQLite [qui](https://www.sqlite.org/index.html).  
[5] "Persist data with SQLite" da Flutter docs [https://docs.flutter.dev/cookbook/persistence/sqlite].  
