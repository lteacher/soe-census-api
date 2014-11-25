part of SoeCensusApiLib;

class SoeCensusApi {
  Api _api = new Api(ApiType.JSONP,new Uri.http('census.soe.com', ''));
  String _game;
  String _serviceId;
  String _format;
  String _basePath;
  EventSubscriber _events;
  
  SoeCensusApi.ps2(String this._serviceId, {String version: 'v2',String format: 'json'}) {
    _game = 'ps2:$version';
    _format = format;
    _events = new EventSubscriber('wss://push.planetside2.com/streaming?service-id=s:$_serviceId');
  }
  SoeCensusApi.eq2(String this._serviceId, {String version: 'v2',String format: 'json'}) {
    _game = 'eq2:$version';
    _format = format;
  }
  SoeCensusApi.dcuo(String this._serviceId, {String version: 'v2',String format: 'json'}) {
    _game = 'dcuo:$version';
    _format = format;
  }
  
  String _getBasePath() {
    return '/${_serviceId != null ? 's:$_serviceId/' : ''}$_format';
  }
  
  Future get(String collection, [Map<String,String> queryParameters]) {
    var path = '/get/$_game/$collection';
    return _api.get(path, queryParameters);
  }
  
  int count(String collection, [Map<String,String> queryParameters]) {
    var path = '/count/$_game/$collection';
    var result =  _api.get(path, queryParameters);
    return 0;
  }
  
  EventSubscriber get events => _events == null ? throw new UnsupportedError('Events are not implemented for $_game') : _events;
  
}