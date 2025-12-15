import 'dart:io';
import 'dart:convert';
import 'dart:async';

void main() async {
  print('Avvio server sulla porta 3000...');

  try {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, 3000);
    var connection = HandleConnection(server);
    connection.startServer();
  } catch (e) {
    print('Server error: $e');
  }
}

class HandleConnection {
  
  late ServerSocket server;
  Map<String, String> logs = {};
  Map<String, Socket> clients = {};

  HandleConnection(this.server);

  void startServer() async {
    print('Server in ascolto su ${server.address.address}:${server.port}\n');
    
    await for (var client in server) {
      handleClient(client);
    }
  }

  void handleClient(Socket client) async {
    final address = '${client.remoteAddress.address}:${client.remotePort}';
    print('Nuova connessione da $address');

    clients[address] = client;
    
    try {
      client.write("Inserire Nome: \n");
      await client.flush();
      bool fMessage = true;

      await for (var data in client) {
        String message = utf8.decode(data).trim();

        if (message.isEmpty) continue;

        if(fMessage){
          logs[message] = address;
          print('[$address] si è registrato come: $message');
          client.write("Benvenuto $message! Puoi iniziare a chattare.\n");
          await client.flush();
          fMessage = false;
        }else{
          print('[$address]: $message');
          broadcast(client, message);
        }

        await client.flush();
      }
    } catch (e) {
      print('Errore con $address: $e');
    } finally {
      clients.remove(address);
      String? userName;
      logs.forEach((name, ip) {
        if (ip == address) userName = name;
      });
      if (userName != null) {
        logs.remove(userName);
        print('$userName disconnesso\n');
      } else {
        print('$address disconnesso\n');
      }
      
      await client.close();
    }
    }

  void broadcast(Socket sender, String m){
    String? senderName;
    String senderAddress = '${sender.remoteAddress.address}:${sender.remotePort}';
    
    logs.forEach((name, ip) {
      if (ip == senderAddress) {
        senderName = name;
      }
    });

    clients.forEach((address, clientSocket) { // Rinominato client in clientSocket per evitare ambiguità
      if (clientSocket != sender) {
        clientSocket.write("${senderName ?? 'Anonimo'}: $m\n");
      }
    });  

  }
}
