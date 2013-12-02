part of SoeCensusApiLib;

class SoeCensusCollection {
  Map _jsonMap;
  String collectionName;
  Map data;
  SoeCensusCollection(String this.collectionName, Map this._jsonMap) {
    data = _jsonMap[collectionName][0];
  }
}