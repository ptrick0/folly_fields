import 'package:flutter/material.dart';
import 'package:folly_fields/crud/abstract_consumer.dart';
import 'package:folly_fields/crud/abstract_model.dart';
import 'package:folly_fields/crud/abstract_ui_builder.dart';
import 'package:folly_fields/widgets/folly_divider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///
///
/// TODO - Test layout with DataTable.
/// TODO - Customize messages.
/// TODO - Create controller??
///
class TableField<T extends AbstractModel<Object>> extends FormField<List<T>> {
  ///
  ///
  ///
  TableField({
    Key? key,
    required List<T> initialValue,
    required AbstractUIBuilder<T> uiBuilder,
    required AbstractConsumer<T> consumer,
    required List<String> columns,
    List<int> columnsFlex = const <int>[],
    required List<Widget> Function(
            BuildContext context, T row, int index, List<T> data)
        buildRow,
    Future<bool> Function(BuildContext context, List<T> data)? beforeAdd,
    void Function(BuildContext context, T row, int index, List<T> data)?
        removeRow,
    FormFieldSetter<List<T>>? onSaved,
    FormFieldValidator<List<T>>? validator,
    bool enabled = true,
    AutovalidateMode autoValidateMode = AutovalidateMode.disabled,
    Widget Function(BuildContext context, List<T> data)? buildFooter,
    InputDecoration? decoration,
  })  : assert(columnsFlex.length == columns.length),
        super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          enabled: enabled,
          autovalidateMode: autoValidateMode,
          builder: (FormFieldState<List<T>> field) {
            final TextStyle? columnTheme =
                Theme.of(field.context).textTheme.subtitle2;

            InputDecoration effectiveDecoration = (decoration ??
                    InputDecoration(
                      labelText: uiBuilder.getSuperPlural(),
                      border: OutlineInputBorder(),
                      counterText: '',
                    ))
                .applyDefaults(Theme.of(field.context).inputDecorationTheme)
                .copyWith(errorText: field.errorText);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputDecorator(
                decoration: effectiveDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (field.value!.isEmpty)

                      /// Tabela vazia
                      Container(
                        height: 75.0,
                        child: Center(
                          child: Text(
                            'Sem ${uiBuilder.getSuperPlural()} até o momento.',
                          ),
                        ),
                      )
                    else

                      /// Tabela
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            /// Cabeçalho
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                /// Nome das colunas
                                ...columns
                                    .asMap()
                                    .entries
                                    .map<Widget>(
                                      (MapEntry<int, String> entry) =>
                                          HeaderCell(
                                        flex: columnsFlex[entry.key],
                                        child: Text(
                                          entry.value,
                                          style: columnTheme,
                                        ),
                                      ),
                                    )
                                    .toList(),

                                /// Coluna vazia para o botão excluir
                                EmptyButton(),
                              ],
                            ),

                            /// Dados da tabela
                            ...field.value!.asMap().entries.map<Widget>(
                                  (MapEntry<int, T> entry) => Column(
                                    children: <Widget>[
                                      /// Divisor
                                      FollyDivider(
                                        color: Colors.black12,
                                      ),

                                      /// Linha
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          /// Células
                                          ...buildRow(
                                            field.context,
                                            entry.value,
                                            entry.key,
                                            field.value!,
                                          )
                                              .asMap()
                                              .entries
                                              .map<Widget>(
                                                (MapEntry<int, Widget> entry) =>
                                                    Flexible(
                                                  flex: columnsFlex[entry.key],
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: entry.value,
                                                  ),
                                                ),
                                              )
                                              .toList(),

                                          /// Botão de excluir linha
                                          DeleteButton(
                                            onPressed: () {
                                              if (removeRow != null) {
                                                removeRow(
                                                  field.context,
                                                  entry.value,
                                                  entry.key,
                                                  field.value!,
                                                );
                                              }
                                              field.value!.removeAt(entry.key);
                                              field.didChange(field.value);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                            /// Rodapé
                            if (buildFooter != null)
                              buildFooter(field.context, field.value!),
                          ],
                        ),
                      ),

                    /// Botão Adicionar
                    AddButton(
                      label: 'Adicionar ${uiBuilder.getSuperSingle()}'
                          .toUpperCase(),
                      onPressed: () async {
                        if (beforeAdd != null) {
                          bool go =
                              await beforeAdd(field.context, field.value!);
                          if (!go) return;
                        }

                        field.value!.add(consumer.modelInstance);
                        field.didChange(field.value);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
}

///
///
///
class AddButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  ///
  ///
  ///
  const AddButton({
    Key? key,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12.0),
        ),
        icon: FaIcon(
          FontAwesomeIcons.plus,
        ),
        label: Text(
          label.toUpperCase(),
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

///
///
///
class EmptyButton extends DeleteButton {
  ///
  ///
  ///
  EmptyButton()
      : super(
          onPressed: null,
          color: Colors.transparent,
          top: 0.0,
        );
}

///
///
///
class DeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;
  final double top;

  ///
  ///
  ///
  const DeleteButton({
    Key? key,
    this.onPressed,
    this.color = Colors.black45,
    this.top = 12.0,
  }) : super(key: key);

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 0,
      child: Padding(
        padding: EdgeInsets.only(
          top: top,
        ),
        child: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.trashAlt,
            color: color,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

///
///
///
class HeaderCell extends StatelessWidget {
  final int flex;
  final Widget child;

  ///
  ///
  ///
  const HeaderCell({
    Key? key,
    this.flex = 1,
    required this.child,
  }) : super(key: key);

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
