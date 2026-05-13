// Deploy Appwrite Functions for the Lumi project.
//
// Run with:
//   APPWRITE_PROVISIONING_API_KEY=<server-api-key> dart run tool/deploy_appwrite_functions.dart
//
// Run tool/provision_appwrite.dart first so the function shell exists.

import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';

const String _projectId = '69ff68eb0033441e4041';
const String _endpoint = 'https://sfo.cloud.appwrite.io/v1';
const String _sendLumiFunctionId = 'send_lumi';

Future<void> main() async {
  final String? apiKey = Platform.environment['APPWRITE_PROVISIONING_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln(
      'APPWRITE_PROVISIONING_API_KEY env var is required.\n'
      'Create a server API key with functions.read & functions.write scopes.',
    );
    exit(1);
  }

  final Client client = Client()
      .setEndpoint(_endpoint)
      .setProject(_projectId)
      .setKey(apiKey);
  final Functions functions = Functions(client);

  await _deployFunction(
    functions: functions,
    functionId: _sendLumiFunctionId,
    sourceDir: Directory('functions/send_lumi'),
    entrypoint: 'lib/main.dart',
    commands: 'dart pub get',
  );

  stdout.writeln('\nFunction deployment complete.');
}

Future<void> _deployFunction({
  required Functions functions,
  required String functionId,
  required Directory sourceDir,
  required String entrypoint,
  required String commands,
}) async {
  if (!sourceDir.existsSync()) {
    stderr.writeln('Missing function source: ${sourceDir.path}');
    exit(1);
  }

  final Directory tempDir = await Directory.systemTemp.createTemp(
    'lumi_appwrite_function_',
  );
  final File archive = File('${tempDir.path}/$functionId.tar.gz');
  try {
    final ProcessResult tar = await Process.run('tar', <String>[
      '-czf',
      archive.path,
      '-C',
      sourceDir.path,
      '.',
    ]);
    if (tar.exitCode != 0) {
      stderr.writeln(tar.stderr);
      exit(tar.exitCode);
    }

    stdout.writeln('Uploading $functionId...');
    final deployment = await functions.createDeployment(
      functionId: functionId,
      code: InputFile.fromPath(path: archive.path),
      activate: true,
      entrypoint: entrypoint,
      commands: commands,
    );
    stdout.writeln('+ deployment ${deployment.$id} activated for $functionId');
  } finally {
    await tempDir.delete(recursive: true);
  }
}
