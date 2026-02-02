import 'package:equatable/equatable.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';

sealed class PropertyState extends Equatable {
  const PropertyState();

  @override
  List<Object?> get props => [];
}

class PropertyInitial extends PropertyState {
  const PropertyInitial();
}

class PropertyLoading extends PropertyState {
  const PropertyLoading();
}

class PropertyLoaded extends PropertyState {
  const PropertyLoaded(this.properties);

  final List<PropertyModel> properties;

  @override
  List<Object?> get props => [properties];
}

class PropertyError extends PropertyState {
  const PropertyError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class PropertyCreated extends PropertyState {
  const PropertyCreated(this.property);

  final PropertyModel property;

  @override
  List<Object?> get props => [property];
}

class PropertyDetailLoaded extends PropertyState {
  const PropertyDetailLoaded(this.property);

  final PropertyModel property;

  @override
  List<Object?> get props => [property];
}

class PropertyUpdated extends PropertyState {
  const PropertyUpdated(this.property);

  final PropertyModel property;

  @override
  List<Object?> get props => [property];
}

class PropertyDeleted extends PropertyState {
  const PropertyDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
