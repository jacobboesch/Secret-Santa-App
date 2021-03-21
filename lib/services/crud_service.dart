/*
 * Abstarct class for CRUD service 
 * is responsible for defining methods for CRUD operations
 * 
*/

import 'package:flutter/material.dart';
import 'package:secret_santa_app/db/database_service.dart';

abstract class CRUDService<T> {
  @protected
  final DatabaseService dbService = DatabaseService();

  @protected
  final String tableName;

  CRUDService(this.tableName);

  Future<List<T>> fetchAll();

  Future<void> create(T model);

  Future<void> delete(T model);

  Future<void> update(T model);
}
