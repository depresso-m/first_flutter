/// API endpoints and configuration constants
abstract class ApiConstants {
  // OpenFDA API
  static const openFdaBaseUrl = 'https://api.fda.gov';
  static const openFdaDrugsPath = '/drug/drugsfda.json';
  static const openFdaLabelPath = '/drug/label.json';
  static const openFdaEventPath = '/drug/event.json';
  // Free API key from https://open.fda.gov/apis/authentication/
  // Without key: 40 requests/minute, With key: 240 requests/minute
  static const openFdaApiKey = '';

  // DaData API
  static const dadataBaseUrl = 'https://suggestions.dadata.ru';
  static const dadataSuggestPath = '/suggestions/api/4_1/rs/suggest/address';
  // Replace with your actual DaData API key
  static const dadataApiKey = 'b361782ce4543924639f46e435628a60796b2f83';

  // Nominatim (OpenStreetMap geocoding)
  static const nominatimBaseUrl = 'https://nominatim.openstreetmap.org';

  // Overpass API (OpenStreetMap data)
  static const overpassBaseUrl = 'https://overpass-api.de/api/interpreter';

  // OpenStreetMap tiles
  static const osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  // Request timeouts
  static const requestTimeout = Duration(seconds: 30);

  // User-Agent for OSM APIs (required by their usage policy)
  static const userAgent = 'PharmacyApp/1.0 (Flutter)';
}
