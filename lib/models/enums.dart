import 'package:collection/collection.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:go_router_poc/models/mixins.dart';

enum CivilState implements Labeled {
  solteiro('Solteiro'),
  casado('Casado'),
  divorciado('Divorciado'),
  viuvo('Viúvo');

  const CivilState(this.label);

  @override
  final String label;

  String get txt => name;

  static CivilState fromText(String txt) {
    return values.firstWhere((element) => element.txt == txt);
  }
}

enum Sex implements Labeled {
  masculino('Masculino'),
  feminino('Feminino'),
  ratherNotSay('Prefiro não dizer');

  const Sex(this.label);

  @override
  final String label;

  String get txt {
    switch (this) {
      case Sex.masculino:
        return 'Masculino';
      case Sex.feminino:
        return 'Feminino';
      case Sex.ratherNotSay:
        return 'Prefiro não dizer';
    }
  }

  static Sex fromTxt(String txt) {
    return values.firstWhere((element) => element.name == txt);
  }
}

enum PossuiFilhos implements Labeled {
  sim,
  nao;

  @override
  String get label {
    switch (this) {
      case PossuiFilhos.sim:
        return 'Sim';
      case PossuiFilhos.nao:
        return 'Não';
    }
  }
}

enum Cnh implements Labeled {
  nao,
  a,
  b,
  c,
  d,
  e,
  ab,
  ac,
  ad,
  ae,
  ;

  @override
  String get label {
    return switch (this) {
      Cnh.nao => 'Não',
      _ => name.toUpperCase(),
    };
  }

  static Cnh fromTxt(String txt) {
    return values.firstWhere((element) => element.name == txt);
  }
}

enum BinaryChoice implements Labeled {
  yes,
  no;

  @override
  String get label {
    return switch (this) {
      BinaryChoice.yes => 'Sim',
      BinaryChoice.no => 'Não',
    };
  }
}

enum BrazilState implements Labeled {
  ac,
  al,
  am,
  ap,
  ba,
  ce,
  df,
  es,
  go,
  ma,
  mg,
  ms,
  mt,
  pa,
  pb,
  pe,
  pi,
  pr,
  rj,
  rn,
  ro,
  rs,
  rr,
  sc,
  se,
  sp,
  to;

  @override
  String get label => switch (this) {
        BrazilState.ac => 'Acre',
        BrazilState.al => 'Alagoas',
        BrazilState.am => 'Amazonas',
        BrazilState.ap => 'Amapá',
        BrazilState.ba => 'Bahia',
        BrazilState.ce => 'Ceará',
        BrazilState.df => 'Distrito Federal',
        BrazilState.es => 'Espírito Santo',
        BrazilState.go => 'Goiás',
        BrazilState.ma => 'Maranhão',
        BrazilState.mg => 'Minas Gerais',
        BrazilState.ms => 'Mato Grosso do Sul',
        BrazilState.mt => 'Mato Grosso',
        BrazilState.pa => 'Pará',
        BrazilState.pb => 'Paraíba',
        BrazilState.pe => 'Pernambuco',
        BrazilState.pi => 'Piauí',
        BrazilState.pr => 'Paraná',
        BrazilState.rj => 'Rio de Janeiro',
        BrazilState.rn => 'Rio Grande do Norte',
        BrazilState.ro => 'Rondônia',
        BrazilState.rs => 'Rio Grande do Sul',
        BrazilState.rr => 'Roraima',
        BrazilState.sc => 'Santa Catarina',
        BrazilState.se => 'Sergipe',
        BrazilState.sp => 'São Paulo',
        BrazilState.to => 'Tocantins',
      };

  static BrazilState fromName(String name) {
    name = name.toUpperCase();
    final state = fromSigla(name) ?? fromFullName(name);
    if (state != null) return state;

    try {
      return values.firstWhere((e) => e.name == name);
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  static BrazilState? tryFromText(String name) {
    try {
      return fromName(name);
    } catch (e) {
      debugPrint(
        'It was not possible to parse the text "$name" to a BrazilState.',
      );
      return null;
    }
  }

  static BrazilState? fromFullName(String name) {
    return values.firstWhereOrNull(
      (e) =>
          removeDiacritics(e.label).toUpperCase() ==
          removeDiacritics(name).toUpperCase(),
    );
  }

  static BrazilState? fromSigla(String name) => switch (name.toUpperCase()) {
        'AC' => BrazilState.ac,
        'AL' => BrazilState.al,
        'AM' => BrazilState.am,
        'AP' => BrazilState.ap,
        'BA' => BrazilState.ba,
        'CE' => BrazilState.ce,
        'DF' => BrazilState.df,
        'ES' => BrazilState.es,
        'GO' => BrazilState.go,
        'MA' => BrazilState.ma,
        'MG' => BrazilState.mg,
        'MS' => BrazilState.ms,
        'MT' => BrazilState.mt,
        'PA' => BrazilState.pa,
        'PB' => BrazilState.pb,
        'PE' => BrazilState.pe,
        'PI' => BrazilState.pi,
        'PR' => BrazilState.pr,
        'RJ' => BrazilState.rj,
        'RN' => BrazilState.rn,
        'RO' => BrazilState.ro,
        'RS' => BrazilState.rs,
        'RR' => BrazilState.rr,
        'SC' => BrazilState.sc,
        'SE' => BrazilState.se,
        'SP' => BrazilState.sp,
        'TO' => BrazilState.to,
        _ => null,
      };
}

enum LanguageLevel implements Labeled {
  beginner('Iniciante', 'beginner'),
  basic('Básico', 'basic'),
  intermediate('Intermediário', 'intermediate'),
  advanced('Avançado', 'advanced'),
  fluent('Fluente', 'fluent');

  const LanguageLevel(this.label, this.endpointText);

  @override
  final String label;
  final String endpointText;

  factory LanguageLevel.fromEndpointText(String text) {
    return values.firstWhere((element) => element.endpointText == text);
  }
}
