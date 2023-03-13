import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:graphql_generator/src/element_type.dart';
import 'package:graphql_generator/src/field_data.dart';
import 'package:graphql_generator/src/function_structure.dart';
import 'package:source_gen/source_gen.dart';

class QlEntityVisitor extends SimpleElementVisitor<void> {
  QlEntityVisitor(this.output);
  List<Variable> fields = [];
  List<FunctionStruture> functions = [];
  VariableType? className;
  final StringBuffer output;

  @override
  visitAugmentationImportElement(AugmentationImportElement element) => null;

  @override
  visitCompilationUnitElement(CompilationUnitElement element) => null;

  @override
  visitConstructorElement(ConstructorElement element) {
    className = VariableType(element.returnType);
  }

  @override
  visitEnumElement(EnumElement element) => null;

  @override
  visitExtensionElement(ExtensionElement element) => null;

  @override
  visitFieldElement(FieldElement field) {
    field.metadata
        .where((element) => element.element?.displayName == 'QlField')
        .forEach((meta) {
      final reader = ConstantReader(meta.computeConstantValue());
      final name = reader.read('name');

      fields.add(
        Variable(
          alias: name.isNull ? field.displayName : name.stringValue,
          technicalName: field.displayName,
          type: VariableType(field.type),
        ),
      );
    });
  }

  @override
  visitFieldFormalParameterElement(FieldFormalParameterElement element) => null;

  @override
  visitFunctionElement(FunctionElement element) => null;

  @override
  visitGenericFunctionTypeElement(GenericFunctionTypeElement element) => null;

  @override
  visitLabelElement(LabelElement element) => null;

  @override
  visitLibraryAugmentationElement(LibraryAugmentationElement element) => null;

  @override
  visitLibraryElement(LibraryElement element) => null;

  @override
  visitLibraryExportElement(LibraryExportElement element) => null;

  @override
  visitLibraryImportElement(LibraryImportElement element) => null;

  @override
  visitLocalVariableElement(LocalVariableElement element) => null;

  @override
  visitMethodElement(MethodElement element) {
    element.metadata
        .where((element) => element.element?.displayName == 'QlQuery')
        .forEach((meta) {
      final reader = ConstantReader(meta.computeConstantValue());
      final name = reader.read('name');
      final returnType = VariableType(element.returnType);

      final parameters = element.parameters
          .map((e) => Variable(
                alias: e.name,
                technicalName: e.name,
                type: VariableType(e.type),
              ))
          .toList();
      functions.add(FunctionStruture(
        name: name.isNull ? element.displayName : name.stringValue,
        actualName: element.displayName,
        returnType: returnType,
        parameters: parameters,
        type: RequestType.query,
      ));
    });

    element.metadata
        .where((element) => element.element?.displayName == 'QlMutation')
        .forEach((meta) {
      final reader = ConstantReader(meta.computeConstantValue());
      final name = reader.read('name');
      final returnType = VariableType(element.returnType);
      final parameters = element.parameters
          .map(
            (e) => Variable(
              alias: e.name,
              technicalName: e.name,
              type: VariableType(e.type),
            ),
          )
          .toList();
      functions.add(FunctionStruture(
        name: name.isNull ? element.displayName : name.stringValue,
        actualName: element.displayName,
        returnType: returnType,
        parameters: parameters,
        type: RequestType.mutation,
      ));
    });
  }

  @override
  visitMixinElement(MixinElement element) => null;

  @override
  visitMultiplyDefinedElement(MultiplyDefinedElement element) => null;

  @override
  visitParameterElement(ParameterElement element) => null;

  @override
  visitPartElement(PartElement element) => null;

  @override
  visitPrefixElement(PrefixElement element) => null;

  @override
  visitPropertyAccessorElement(PropertyAccessorElement element) => null;

  @override
  visitSuperFormalParameterElement(SuperFormalParameterElement element) => null;

  @override
  visitTopLevelVariableElement(TopLevelVariableElement element) => null;

  @override
  visitTypeAliasElement(TypeAliasElement element) => null;

  @override
  visitTypeParameterElement(TypeParameterElement element) => null;
}
