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
  Completer _callback = new Completer();
  ScriptElement _script;
  
  JsonpApi(Uri uri) : super._internal(uri);
  
  Future get(String path, [Map<String, String> queryParameters]) {
    if(queryParameters==null) {
      queryParameters = new Map();
    }
    
    queryParameters.putIfAbsent('callback', () { return 'callbackMethod'; });
    
    uri = uri.replace(path: path,queryParameters: queryParameters);
    
    context['callbackMethod'] = (JsObject result) {
      _script.remove();
      _callback.complete(result);
    };
    
    _setContext();
    return _callback.future;
  }
  
  void _setContext() {
    _script = new Element.tag('script');
    _script.src = uri.toString();
    document.body.children.add(_script);
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
