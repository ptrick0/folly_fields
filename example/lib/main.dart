import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:folly_fields/fields/cnpj_field.dart';
import 'package:folly_fields/fields/cpf_field.dart';
import 'package:folly_fields/fields/cpj_cnpj_field.dart';
import 'package:folly_fields/fields/date_field.dart';
import 'package:folly_fields/fields/email_field.dart';
import 'package:folly_fields/fields/local_phone_field.dart';
import 'package:folly_fields/fields/password_field.dart';
import 'package:folly_fields/fields/phone_field.dart';
import 'package:folly_fields/fields/string_field.dart';
import 'package:folly_fields/fields/time_field.dart';
import 'package:folly_fields/folly_fields.dart';
import 'package:folly_fields/widgets/my_dialogs.dart';
import 'package:folly_fields_example/config.dart';
import 'package:folly_fields_example/example_model.dart';

///
///
///
void main() {
  bool debug = false;

  assert(debug = true);

  FollyFields.start(Config(), debug: debug);

  runApp(MyApp());
}

///
///
///
class MyApp extends StatelessWidget {
  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Folly Fields Example',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(),
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: <Locale>[
        Locale('pt', 'BR'),
      ],
    );
  }
}

///
///
///
class MyHomePage extends StatefulWidget {
  ///
  ///
  ///
  MyHomePage({Key key}) : super(key: key);

  ///
  ///
  ///
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

///
///
///
class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Prefixo utilizado no label dos campos.
  /// O conteúdo está no arquivo de configurações.
  String prefix = Config().prefix;

  /// habilita ou desabilita os campos.
  bool edit = true;

  /// Modelo padrão para o exemplo.
  ExampleModel model = ExampleModel();

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folly Fields Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              /// Título
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Formulário Básico',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),

              /// Texto
              StringField(
                prefix: prefix,
                label: 'Texto*',
                enabled: edit,
                initialValue: model.text,
                validator: (String value) => value == null || value.isEmpty
                    ? 'O campo texto precisa ser informado.'
                    : null,
                onSaved: (String value) => model.text = value,
              ),

              /// E-mail
              EmailField(
                prefix: prefix,
                label: 'E-mail*',
                enabled: edit,
                initialValue: model.email,
                onSaved: (String value) => model.email = value,
              ),

              /// Senha
              PasswordField(
                prefix: prefix,
                label: 'Senha*',
                enabled: edit,
                initialValue: model.password,
                validator: (String value) => value == null || value.isEmpty
                    ? 'O campo senha precisa ser informado.'
                    : null,
                onSaved: (String value) => model.password = value,
              ),

              /// CPF
              CpfField(
                prefix: prefix,
                label: 'CPF*',
                enabled: edit,
                initialValue: model.cpf,
                onSaved: (String value) => model.cpf = value,
              ),

              /// CNPJ
              CnpjField(
                prefix: prefix,
                label: 'CNPJ*',
                enabled: edit,
                initialValue: model.cnpj,
                onSaved: (String value) => model.cnpj = value,
              ),

              /// CPF ou CNPJ
              CpfCnpjField(
                prefix: prefix,
                label: 'CPF ou CNPJ*',
                enabled: edit,
                initialValue: model.document,
                onSaved: (String value) => model.document = value,
              ),

              /// Telefone
              PhoneField(
                prefix: prefix,
                label: 'Telefone*',
                enabled: edit,
                initialValue: model.phone,
                onSaved: (String value) => model.phone = value,
              ),

              /// Telefone sem DDD
              LocalPhoneField(
                prefix: prefix,
                label: 'Telefone sem DDD*',
                enabled: edit,
                initialValue: model.localPhone,
                onSaved: (String value) => model.localPhone = value,
              ),

              /// Data
              DateField(
                prefix: prefix,
                label: 'Data*',
                enabled: edit,
                initialValue: model.date ?? DateTime.now(),
                onSaved: (DateTime value) => model.date = value,
              ),

              /// Hora
              TimeField(
                prefix: prefix,
                label: 'Hora*',
                enabled: edit,
                initialValue: model.time ?? TimeOfDay.now(),
                onSaved: (TimeOfDay value) => model.time = value,
              ),

              /// Botão Enviar
              RaisedButton.icon(
                icon: Icon(Icons.send),
                label: Text('ENVIAR'),
                onPressed: send,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  ///
  ///
  void send() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      print(model.toMap());

      MyDialogs.dialogMessage(
        context: context,
        message: model.toMap().toString(),
      );
    }
  }
}