part of SoeCensusApiLib;

class EventSubscriber implements WebSocket {
  WebSocket _delegate;
  EventSubscription _sub;
  
  EventSubscriber(String url,[protocol_OR_protocols]) {
    _delegate = new WebSocket(url,protocol_OR_protocols); 
  }
  
  Stream<MessageEvent> subscribe(EventSubscription sub) {
    _sub = sub;
    if(_delegate.readyState != WebSocket.OPEN) {
      onOpen.listen((e) {
        send(_sub.toJson());
      });
    } else {
      send(_sub.toJson());
    }
      
    return onMessage;
  }
  
  void unsubscribe() {
    _sub.action = 'clearSubscribe';
    send(_sub.toJson());
    
  }
 
  void addEventListener(String type, listener(Event event), [bool useCapture]) {
    _delegate.addEventListener(type, listener,useCapture);
  }

  void set binaryType(String value) {
    _delegate.binaryType = value;
  }
  
  EventSubscription get subscription => _sub;
  String get binaryType => _delegate.binaryType;

  int get bufferedAmount => _delegate.bufferedAmount;

  void close([int code, String reason]) {
    _delegate.close(code,reason);
  }

  bool dispatchEvent(Event event) {
    return _delegate.dispatchEvent(event);
  }

  String get extensions => _delegate.extensions;
  Events get on => _delegate.on;
  Stream<CloseEvent> get onClose => _delegate.onClose;
  Stream<Event> get onError => _delegate.onError;
  Stream<MessageEvent> get onMessage => _delegate.onMessage;
  Stream<Event> get onOpen => _delegate.onOpen;
  String get protocol => _delegate.protocol;
  int get readyState => _delegate.readyState;

  void removeEventListener(String type, listener(Event event), [bool useCapture]) {
    _delegate.removeEventListener(type, listener, useCapture);
  }

  void send(data) {
    _delegate.send(data);
  }

  void sendBlob(Blob data) {
    _delegate.sendBlob(data);
  }

  void sendByteBuffer(ByteBuffer data) {
    _delegate.sendByteBuffer(data);
  }

  void sendString(String data) {
    _delegate.sendString(data);
  }

  void sendTypedData(TypedData data) {
    _delegate.sendTypedData(data);
  }

  String get url => _delegate.url;
}

class EventSubscription {
  List events = new List();
  List characters = new List();
  List worlds = new List();
  String action = 'subscribe';
  
  EventSubscription(name_OR_names) {
    if(name_OR_names is Iterable) {
      events.addAll(name_OR_names);
    } else {
      events.add(name_OR_names);
    }
  }
  
  String toJson() {
    var out =  { 'service' : 'event',
                 'action' : '$action',
                 'eventNames' : events };
    if(characters.length > 0) out['characters'] = characters; 
    if(worlds.length > 0) out['worlds'] = worlds;
    return JSON.encode(out);
  }
}




