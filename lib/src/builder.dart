library drift_model_generator.builder;

import 'package:build/build.dart';
import 'package:drift_model_generator/src/generator/drift_model_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder driftClassBuilder(BuilderOptions options) => LibraryBuilder(
      DriftModelGenerator(
        timestampDateTime: options.config['timestamp_date_time'],
      ),
      generatedExtension: '.driftm.dart',
      options: options,
    );
