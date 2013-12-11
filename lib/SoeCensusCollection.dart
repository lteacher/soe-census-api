part of SoeCensusApiLib;

class SoeCensusCollection {
  Map _data;
  String name;
  SoeCensusCollection(String this.name);
  
  // Set the collection data
  set data(Map json) => _data = json;
  
  // Override the [] operator
  dynamic operator[](Object key) {
    return _data[key];          
  }
  
}