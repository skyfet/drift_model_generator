import 'package:drift_model_generator/drift_model_generator.dart';

@UseDrift(
  useSnakeCase: false,
  exludeFields: {'fiName', 'entity'},
  driftConstructor: 'fromDb',
)
class AccountDetail {
  const AccountDetail({
    required this.accountDetailId,
    required this.accountNumber,
    required this.accountType,
    required this.isDefault,
    required this.entityId,
    required this.conglomerateId,
    required this.createdAt,
    this.fiName,
    this.entity,
  });
  @autoIncrement
  final int accountDetailId;
  final String accountNumber;
  final AccountType accountType;

  @WithDefault(false)
  final bool isDefault;

  final int entityId;
  final int conglomerateId;

  @nullable
  final String? fiName;

  @WithDefault('now()')
  final DateTime createdAt;

  @ReferencedBy(['entityId', 'conglomerateId'])
  final Entity? entity;

  AccountDetail.fromDb({
    required this.accountDetailId,
    required this.accountNumber,
    required String accountType,
    required this.isDefault,
    required this.entityId,
    required this.conglomerateId,
    required this.createdAt,
    this.fiName,
    this.entity,
  }) : accountType = AccountType.values.firstWhere(
          (at) => at.name == accountType,
        );
}

@UseDrift(driftClassName: 'Entities')
class Entity {
  final int entityId;
  final int conglomerateId;

  final String name;

  const Entity({
    required this.entityId,
    required this.conglomerateId,
    required this.name,
  });
}

@useDrift
enum AccountType { cash, card, electronic, blockchainAddress }
