import 'package:envied/envied.dart'; // Importing the 'envied' package for environment variables management.
part 'env_config.g.dart'; // Importing the generated file 'env_config.g.dart'.

// Declaring an abstract class named Env with the @Envied annotation.
@Envied(path: '.env')
abstract class Env {
  // Declaring a static constant variable 'projectUrl' with the @EnviedField annotation,
  // mapping to the environment variable 'SUPABASE_PROJECT_URL'.
  @EnviedField(varName: 'SUPABASE_PROJECT_URL')
  static String projectUrl = _Env.projectUrl;

  // Declaring a static constant variable 'projectAnonKey' with the @EnviedField annotation,
  // mapping to the environment variable 'SUPERBASE_PROJECT_ANON_KEY'.
  @EnviedField(varName: 'SUPERBASE_PROJECT_ANON_KEY')
  static String projectAnonKey = _Env.projectAnonKey;

  // Declaring a static constant variable 'projectDatabasePassword' with the @EnviedField annotation,
  // mapping to the environment variable 'SUPERBASE_PROJECT_ANON_KEY'.
  @EnviedField(varName: 'SUPABASE_DATABASE_PASSWORD', obfuscate: true)
  static String projectDatabasePassword = _Env.projectDatabasePassword;
}
