part of SoeCensusApiLib;

class SoeCensusQuery {
  String _domain = 'census.soe.com';
  String _method = 'get';
  String _serviceId = 'soe';
  String _version = 'ps2:v2';
  String _colName;
  Map _queryCommands = new Map();
  Map _queryFields = new Map();
  
  SoeCensusQuery({String domain,String method, String serviceId, String version}) {
    this.._domain = domain == null ? _domain : domain
        .._method = method == null ? _method : method
        .._serviceId = serviceId == null ? _serviceId : serviceId
        .._version = version == null ? _version : version;
  }
  
  Future<SoeCensusCollection> retrieveCollection(String colName,{Map queryFields,Map queryCommands}) {
    _colName = colName;
    if(queryFields != null) {
      setQueryFields(queryFields);
    }
    if(queryCommands != null) {
      setQueryCommands(queryCommands);
    }
    Future<js.Proxy> jsonQry = jsonp.fetch( uri: getUrl() );
    return jsonQry.then( (js.Proxy data) => onJSONResult(data) );
  }
  
  SoeCensusCollection onJSONResult(var data) {
    String jsonStr = js.context.JSON.stringify(data);
    return new SoeCensusCollection('$_colName\_list')..data = JSON.decode(jsonStr);
  }
  
  String getUrl() {
    String fields = _getFieldString();
    if(fields != '') {
      fields = fields.substring(1);
    }
    String cmds = _getCommandString();
    if(cmds != '' && fields == '') {
      cmds = cmds.substring(1);
    }
    return 'http://$_domain/s:$_serviceId/$_method/$_version/$_colName?${fields == '' ? '' : fields}${cmds == '' ? '' : cmds}&callback=?';
  }
  
  void setQueryCommands(Map queryCommands) {
    _queryCommands = queryCommands;
  }
  
  void setQueryFields(Map queryFields) {
    _queryFields = queryFields;
  }
  
  void addQueryCommand(String command, var value) {
    _queryCommands[command] = value;
  }
  
  void addQueryField(String field, var value) {
    _queryFields[field] = value;
  }
  
  String _getCommandString(){
    String result = '';
    for(var key in _queryCommands.keys) {
      result += '&$key=${_queryCommands[key]}';
    }
    return result;
  }
  
  String _getFieldString(){
    String result = '';
    for(var key in _queryFields.keys) {
      result += '&$key=${_queryFields[key]}';
    }
    return result;
  }
}


