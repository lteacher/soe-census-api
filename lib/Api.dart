part of SoeCensusApiLib;

class ApiType {
  final _value;
  const ApiType._internal(this._value);
  toString() => '$_value';

  static const JSONP = const ApiType._internal('JSONP');
  static const CORS = const ApiType._internal('CORS');
}

abstract class Api {
  Uri uri;
  
  Api._internal(Uri this.uri);
  
  factory Api(ApiType type, Uri uri) {
    switch(type) {
      case ApiType.CORS:
        return new CorsApi(uri);
      case ApiType.JSONP:
        return new JsonpApi(uri);
    }
  }
  
  Future get(String path, [Map<String, String> queryParameters]);
  Future post(String path, data);
  Future put(String path, data);
  Future delete(String path, data);
}

class CorsApi extends Api {
  
  CorsApi(Uri uri) : super._internal(uri);
  
  Future get(String path, [Map<String, String> queryParameters]) {
    uri = uri.replace(path: path,queryParameters: queryParameters);
    return HttpRequest.getString(uri.toString());
  }
  
  Future post(String path, data) {
    uri = uri.replace(path: path);
    return HttpRequest.postFormData(uri.toString(), data);
  }
  Future put(String path, data) {
    uri = uri.replace(path: path);
    return HttpRequest.request(uri.toString(),method: 'PUT', sendData: data);
  }
  Future delete(String path, data) {
    uri = uri.replace(path: path);
    return HttpRequest.request(uri.toString(),method: 'DELETE', sendData: data);
  }
}

class JsonpApi extends Api {
  Map _scripts = new Map(); 
  Uuid _uuid = new Uuid();
  
  JsonpApi(Uri uri) : super._internal(uri);

  /*
   * Get results from the specified url and queryParms
   */
  Future get(String path, [Map<String, String> queryParameters]) {
    if(queryParameters==null) {
      queryParameters = new Map();
    }
    
    // Completer to issue for results 
    var completer = new Completer();
    
    // Unique callback
    String id = ("cb" + _uuid.v1()).replaceAll('-', '');

    queryParameters.putIfAbsent('callback', () { return id; });
    
    uri = uri.replace(path: path,queryParameters: queryParameters);
    
    context[id] = (JsObject result) {
      _scripts[id].remove();
      completer.complete(result);
    };
    
    _setContext(id);
    return completer.future;
  }
  
  void _setContext(var id) {
    var script = new Element.tag('script');
    script.src = uri.toString();
    document.body.children.add(script);
    _scripts[id] = script;
  }
  
  Future post(String path, data) {
    throw 'Post is not supported by JSONP';
  }
  Future put(String path, data) {
    throw 'Put is not supported by JSONP';
  }
  Future delete(String path, data) {
    throw 'Delete is not supported by JSONP';
  }
}
