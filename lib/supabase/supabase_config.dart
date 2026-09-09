/// Supabase configuration.
/// Project URL and anon key from Supabase Dashboard → Project Settings → API.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = 'https://owbbtxdqazdjijxetwmn.supabase.co';

  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im93YmJ0eGRxYXpkamlqeGV0d21uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk4NTcwNzMsImV4cCI6MjA4NTQzMzA3M30.v3Qd9DXVrvCwL1u-4BZihGAblTefgzAYgIr1b_A5Uhg';

  /// Public Storage bucket for OTA manifests and installers.
  static const String appReleasesBucket = 'app-releases';

  /// Latest manifest uploaded by CI on each release tag.
  static String get updateManifestUrl =>
      '$url/storage/v1/object/public/$appReleasesBucket/latest/version.json';

  static String releaseAssetUrl(String assetFileName) =>
      '$url/storage/v1/object/public/$appReleasesBucket/latest/$assetFileName';
}
