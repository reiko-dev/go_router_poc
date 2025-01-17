import 'dart:math';

import 'package:faker/faker.dart' as f;
import 'package:flutter/material.dart';
import 'package:go_router_poc/models/academic_formation.dart';
import 'package:go_router_poc/models/address.dart';
import 'package:go_router_poc/models/company.dart';
import 'package:go_router_poc/models/course.dart';
import 'package:go_router_poc/models/curriculum.dart';
import 'package:go_router_poc/models/enums.dart';
import 'package:go_router_poc/models/job.dart';
import 'package:go_router_poc/models/job_name.dart';
import 'package:go_router_poc/models/manager.dart';
import 'package:go_router_poc/models/professional_experience.dart';
import 'package:go_router_poc/models/validator.dart';

class Fake {
  static final _rand = Random();
  static final cnpjValidator = CNPJValidator();

  static final faker = f.Faker();

  static bool get boolean => _rand.nextBool();

  static int integer({int initial = 0, int itens = 20}) =>
      initial + _rand.nextInt(itens);

  static double decimal([int maxValue = 1]) => _rand.nextDouble() * maxValue;

  static String get uid => faker.guid.guid();
  static String get email => faker.internet.email();
  static String get fone => faker.phoneNumber.us();
  static String get name => faker.person.name();
  static String lorem(int maxWords) =>
      faker.lorem.words(1 + _rand.nextInt(maxWords - 1)).join(' ');

  static String loremSentences(int maxSentences) => faker.lorem
      .sentences(1 + _rand.nextInt(max(1, maxSentences - 1)))
      .join(' ');

  static String get cnpj => CNPJValidator.generate(true);

  static String get cpf => CNPJValidator.generate(false);

  static String get site => faker.internet.domainName();

  static Company createFakeCompany([String? uid]) {
    final now = DateTime.now();
    return Company(
      uid: uid ?? Fake.uid,
      socialReason: Fake.lorem(3),
      emails: ['fake@mail.com'],
      isEmailVerified: Fake.boolean,
      name: Fake.lorem(3),
      isActive: true,
      managers: [],
      activityContext: Fake.lorem(5),
      cnpj: Fake.cnpj,
      cellphone: Fake.integer(initial: 10000000000, itens: 10000000).toString(),
      createdAt: now,
      updatedAt: now,
      phone2: Fake.integer(initial: 10000000000, itens: 10000000).toString(),
      applyProfiler: Fake.boolean,
      address: createFakeAddress(),
      applyPsichologicalEvaluation: Fake.boolean,
      observations: Fake.loremSentences(5),
      site: Fake.site,
      cancellationPenalty: Fake.decimal(),
      contractDate: now,
      contractPercentage: Fake.decimal(50),
      profilerValue: Fake.decimal(300),
      psychologicalEvaluationValue: Fake.decimal(200),
    );
  }

  static Address createFakeAddress({String? uid}) {
    return Address(
      cep: Fake.faker.address.zipCode(),
      address: Fake.loremSentences(1),
      addressNumber: Fake.integer(itens: 20000),
      neighborhood: Fake.lorem(3),
      complement: Fake.loremSentences(3),
      city: Fake.lorem(2),
      state: BrazilState
          .values[Fake.integer(itens: BrazilState.values.length)].name,
    );
  }

  static Manager createFakeManager({String? uid}) {
    return Manager(
      uid: uid ?? Fake.uid,
      name: Fake.name,
      email: Fake.email,
      phone2: Fake.fone,
      phone: Fake.fone,
    );
  }

  static Job createFakeJob({
    required Company company,
    required JobName job,
    String? uid,
  }) {
    return Job(
      uid: uid ?? Fake.uid,
      jobName: Fake.lorem(2),
      company: company,
      job: job,
      qtd: Fake.faker.randomGenerator.integer(4, min: 1),
      salary: Fake.faker.randomGenerator.integer(10000, min: 2000).toDouble(),
      showSalary: Fake.boolean,
      isActive: true,
      description: Fake.loremSentences(8),
      createdAt: DateTime.now(),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      jobApplies: [],
      city: Fake.fakeCity,
      startTime: const TimeOfDay(hour: 8, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 0),
    );
  }

  static JobName createFakeJobName({String? uid}) {
    return JobName(
      uid: uid ?? Fake.uid,
      title: Fake.lorem(4),
      isActive: Fake.boolean,
    );
  }

  static String fakeCity = Fake.faker.address.city();

  static Curriculum createFakeCurriculum() {
    final now = DateTime.now();

    return Curriculum(
      uid: uid,
      email: Fake.email,
      country: Fake.fakeCity,
      cpf: Fake.cpf,
      nascimento: '01/01/2000',
      phone: Fake.fone,
      name: Fake.name,
      civilState:
          CivilState.values[Fake.integer(itens: CivilState.values.length)],
      sex: Sex.values[Fake.integer(itens: Sex.values.length)],
      academicFormation: [
        AcademicFormation(
            courseName: 'courseName',
            organization: 'organization',
            situation: AcademicSituation.finishing,
            formation: Formation.master),
        AcademicFormation(
            courseName: 'Course Name 2',
            organization: 'Organization 2',
            situation: AcademicSituation.finished,
            formation: Formation.graduation),
      ],
      address: Fake.createFakeAddress(),
      cnh: Cnh.values[Fake.integer(itens: Cnh.values.length)],
      professionalExperience: [
        ProfessionalExperience(
          company: 'Company',
          context: 'context',
          position: 'position',
          responsability: 'responsability',
          startDate: now,
          isAtual: true,
        ),
      ],
      professionalObjectives: 'Objetivos profissionais',
      courses: [
        Course(name: name, organization: 'Organization', endDate: now),
      ],
      disponibilidadeParaMudanca: true,
      disponibilidadeParaViagem: true,
      positions: [
        JobName(uid: uid, title: 'Job1', isActive: true),
        JobName(uid: uid, title: 'Job2', isActive: true),
      ],
      qtdFilhos: Fake.integer(itens: 10),
      userUID: uid,
      disability: null,
      veiculoProprio: true,
      englishLevel: LanguageLevel.advanced,
    );
  }
}
