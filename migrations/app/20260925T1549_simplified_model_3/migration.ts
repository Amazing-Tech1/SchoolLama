#!/usr/bin/env -S node
import type { Contract as End } from '../../snapshots/17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68/contract';
import endContract from '../../snapshots/17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68/contract.json' with { type: 'json' };
import type { Contract as Start } from '../../snapshots/a2f029c63902cfca70a36b60879580d2176d4652b8f02657d9dcab9bf9396b98/contract';
import startContract from '../../snapshots/a2f029c63902cfca70a36b60879580d2176d4652b8f02657d9dcab9bf9396b98/contract.json' with { type: 'json' };
import { Migration, MigrationCLI, col, primaryKey } from '@prisma/orm-postgres/migration';

export default class M extends Migration<Start, End> {
  override readonly startContractJson = startContract;
  override readonly endContractJson = endContract;

  override get operations() {
    return [
      this.createTable({
        schema: 'public',
        table: 'studentSubject',
        columns: [
          col('studentId', 'text', { notNull: true, codecRef: { codecId: 'pg/text@1' } }),
          col('subjectId', 'int4', { notNull: true, codecRef: { codecId: 'pg/int4@1' } }),
        ],
        constraints: [primaryKey(['studentId', 'subjectId'])],
      }),
      this.createTable({
        schema: 'public',
        table: 'teacherSubject',
        columns: [
          col('subjectId', 'int4', { notNull: true, codecRef: { codecId: 'pg/int4@1' } }),
          col('teacherId', 'text', { notNull: true, codecRef: { codecId: 'pg/text@1' } }),
        ],
        constraints: [primaryKey(['teacherId', 'subjectId'])],
      }),
      this.createIndex({
        schema: 'public',
        table: 'studentSubject',
        index: 'studentSubject_studentId_idx_bf255322',
        columns: ['studentId'],
      }),
      this.createIndex({
        schema: 'public',
        table: 'studentSubject',
        index: 'studentSubject_subjectId_idx_84df2a1d',
        columns: ['subjectId'],
      }),
      this.createIndex({
        schema: 'public',
        table: 'teacherSubject',
        index: 'teacherSubject_subjectId_idx_84df2a1d',
        columns: ['subjectId'],
      }),
      this.createIndex({
        schema: 'public',
        table: 'teacherSubject',
        index: 'teacherSubject_teacherId_idx_bc266660',
        columns: ['teacherId'],
      }),
      this.addForeignKey({
        schema: 'public',
        table: 'studentSubject',
        foreignKey: {
          name: 'studentSubject_studentId_fkey',
          columns: ['studentId'],
          references: { schema: 'public', table: 'student', columns: ['id'] },
        },
      }),
      this.addForeignKey({
        schema: 'public',
        table: 'studentSubject',
        foreignKey: {
          name: 'studentSubject_subjectId_fkey',
          columns: ['subjectId'],
          references: { schema: 'public', table: 'subject', columns: ['id'] },
        },
      }),
      this.addForeignKey({
        schema: 'public',
        table: 'teacherSubject',
        foreignKey: {
          name: 'teacherSubject_teacherId_fkey',
          columns: ['teacherId'],
          references: { schema: 'public', table: 'teacher', columns: ['id'] },
        },
      }),
      this.addForeignKey({
        schema: 'public',
        table: 'teacherSubject',
        foreignKey: {
          name: 'teacherSubject_subjectId_fkey',
          columns: ['subjectId'],
          references: { schema: 'public', table: 'subject', columns: ['id'] },
        },
      }),
    ];
  }
}

MigrationCLI.run(import.meta.url, M);
