import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';
import 'package:mdb_copilot/features/properties/data/property_repository.dart';
import 'package:mdb_copilot/features/properties/presentation/cubit/property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  PropertyCubit({required PropertyRepository repository})
      : _repository = repository,
        super(const PropertyInitial());

  final PropertyRepository _repository;
  StreamSubscription<List<PropertyModel>>? _subscription;

  Future<void> loadProperties() async {
    emit(const PropertyLoading());
    try {
      final properties = await _repository.getProperties();
      emit(PropertyLoaded(properties));
    } on Exception catch (e) {
      emit(PropertyError(e.toString()));
    }
  }

  Future<void> createProperty(PropertyModel property) async {
    emit(const PropertyLoading());
    try {
      final created = await _repository.createProperty(property);
      emit(PropertyCreated(created));
    } on Exception catch (e) {
      emit(PropertyError(e.toString()));
    }
  }

  Future<void> updateProperty(PropertyModel property) async {
    emit(const PropertyLoading());
    try {
      await _repository.updateProperty(property);
      emit(PropertyUpdated(property));
    } on Exception catch (e) {
      emit(PropertyError(e.toString()));
    }
  }

  Future<void> deleteProperty(String id) async {
    emit(const PropertyLoading());
    try {
      await _repository.deleteProperty(id);
      emit(PropertyDeleted(id));
    } on Exception catch (e) {
      emit(PropertyError(e.toString()));
    }
  }

  Future<void> loadPropertyById(String id) async {
    emit(const PropertyLoading());
    try {
      final property = await _repository.getPropertyById(id);
      if (property != null) {
        emit(PropertyDetailLoaded(property));
      } else {
        emit(const PropertyError('Fiche introuvable.'));
      }
    } on Exception catch (e) {
      emit(PropertyError(e.toString()));
    }
  }

  void watchProperties() {
    unawaited(_subscription?.cancel());
    _subscription = _repository.watchProperties().listen(
      (properties) => emit(PropertyLoaded(properties)),
      onError: (Object e) => emit(PropertyError(e.toString())),
    );
  }

  @override
  Future<void> close() {
    unawaited(_subscription?.cancel());
    return super.close();
  }
}
