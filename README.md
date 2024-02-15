# Drift Model Generator

The Drift Model Generator package is an extension built on top of the Drift package, aimed at simplifying the generation of Drift classes with Plain Old Dart Objects (PODOs). It provides annotations and tools to configure the behavior of the Drift model generator, making it easier to define database models in Dart.

## Features

- **Annotation-Based Configuration**: Use annotations to configure naming conventions, exclude fields, handle enum references, define unique keys, and specify foreign keys for your Drift models.
- **Automatic Code Generation**: Automatically generate Drift classes from annotated Dart classes, reducing boilerplate code and saving development time.
- **Support for Composite Primary and Unique Keys**: Define composite primary and unique keys with ease using annotations.
- **Foreign Key Constraints**: Specify foreign key constraints between tables using simple annotations.
- **Custom Indexes**: Define custom indexes on your database tables to optimize query performance.
- **Automatic Enum Handling**: Automatically handle enum references in your database models, simplifying the integration of enums with your database schema.
- **Support for Computed Fields**: Define computed fields in your database models using annotations, allowing you to derive values based on other fields.
- **Default Values**: Specify default values for fields in your database models, ensuring consistency and reducing the need for manual data entry.
- **Validation and Error Handling**: Validate input data against defined constraints and handle errors gracefully, ensuring data integrity and reliability.
- **Integration with Existing Drift Features**: Seamlessly integrate the Drift Model Generator with existing features of the Drift package.

## Usage

1. **Define Your Dart Classes**: Define your database models as Dart classes, annotating them with the appropriate annotations from the Drift Model Generator package.

2. **Run Code Generation**: Run the Drift Model Generator to automatically generate Drift classes based on your annotated Dart classes. You can do this using the `dart run build_runner build` command.

3. **Use Generated Classes**: Use the generated Drift classes in your application code to interact with your database. You can perform CRUD operations and define queries using the generated classes.

## Example

Here's minimal example of how you can use the Drift Model Generator package to define and generate database models:

```dart
import 'package:drift_model_generator/drift_model_generator.dart';

@UseDrift(
  excludeFields: {'password'},
  foreignKeys: {
    'accounts': [
      ['accountId']
    ]
  },
)
class User {
  final int id;
  final String username;
  final String email;
  final int accountId;
  final String password;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.accountId,
    this.password,
  });
}
```
In this example, we have defined a User class with annotations to configure the Drift model generator. When you run the code generation process, it will generate the corresponding Drift class for the User class.

You can also see more detailed examples [on the repository](https://github.com/skyfet/drift_model_generator/tree/main/example).


## Contributing
Contributions to the Drift Model Generator package are welcome! If you encounter any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request on the GitHub repository.

## License
The Drift Model Generator package is distributed under the MIT License. See the LICENSE file for more information.