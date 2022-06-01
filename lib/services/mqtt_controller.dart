import '../imports.dart';

class MqttController {
  final int _port = 1883;
  final String _server = "mqtt.mydevices.com";
  final String _clientID = "84b20500-7970-11ec-8da3-474359af83d7";
  final String _username = "50457b00-f653-11e9-a38a-d57172a4b4d4";
  final String _password = "d02f0fa606e75ca84124ef4564b50c5c292b6886";

  late MqttServerClient _client;
  MqttConnectionState state = MqttConnectionState.disconnected;

  MqttController() {
    _client = MqttServerClient.withPort(
      _server,
      _clientID,
      _port,
    );
    _client.logging(on: true);
    _client.autoReconnect = true;

    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    _client.onSubscribed = _onSubscribed;
    _client.onSubscribeFail = _onSubscribeFail;
    _client.onAutoReconnect = _onAutoReconnect;
    _client.onAutoReconnected = _onAutoReconnected;

    final MqttConnectMessage _message = MqttConnectMessage();
    _message.authenticateAs(_username, _password);
    _message.startClean();
    _message.withWillQos(MqttQos.atLeastOnce);
    _message.withClientIdentifier(_clientID);

    _client.connectionMessage = _message;
  }

  void connect() {
    print("----------------- ssss -----------------");
    try {
      _client.connect();
      state = MqttConnectionState.connected;
      print("----------------- connected -----------------");
    } catch (e) {
      print("----------------- Disconnected Error -----------------");

      _client.disconnect();
      state = MqttConnectionState.disconnected;
    }
  }

  void subscribe() {
    Subscription s = _client.subscribe("v1/$_username/thisngs/$_clientID", MqttQos.atLeastOnce)!;
    s.changes.listen((change) {
      print("----------------- changes -----------------");
    });
    data();
  }

  void data() {
    print("----------------- Data ------------------");
    _client.updates!.listen(
      (event) {
        print("----------------- Event -----------------");
        print(event);
      },
      onDone: () {
        print("----------------- Done -----------------");
      },
      onError: (obj, trace) {
        print("----------------- Error -----------------");
      },
    );
  }

  void unSubscribe() {
    _client.unsubscribe("v1/$_username/thisngs/$_clientID");
  }

  void dispose() {
    print("----------------- Disconnect -----------------");

    _client.disconnect();
  }

  void _onConnected() {
    state = MqttConnectionState.connected;
    _client.subscribe("v1/$_username/thisngs/$_clientID", MqttQos.atLeastOnce);
    data();
  }

  void _onDisconnected() {
    state = MqttConnectionState.disconnected;
    print("----------------- Disconnected -----------------");
  }

  void _onSubscribed(String topic) {
    print("----------------- Subscribe : $topic -----------------");
  }

  void _onSubscribeFail(String topic) {
    print("----------------- Subscribe Failed -----------------");
  }

  void _onAutoReconnect() {
    state = MqttConnectionState.connecting;
  }

  void _onAutoReconnected() {
    state = MqttConnectionState.connected;
  }
}
