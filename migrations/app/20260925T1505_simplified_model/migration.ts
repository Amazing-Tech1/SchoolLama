#!/usr/bin/env -S node
import type { Contract as Start } from '../../snapshots/17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68/contract';
import startContract from '../../snapshots/17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68/contract.json' with { type: 'json' };
import type { Contract as End } from '../../snapshots/22fb3ea199914ae70284f364114b1a8b310ecd8e00721fef48193acf282d3cbb/contract';
import endContract from '../../snapshots/22fb3ea199914ae70284f364114b1a8b310ecd8e00721fef48193acf282d3cbb/contract.json' with { type: 'json' };
import { Migration, MigrationCLI, col } from '@prisma/orm-postgres/migration';

export default class M extends Migration<Start, End> {
  override readonly startContractJson = startContract;
  override readonly endContractJson = endContract;

  override get operations() {
    return [
      this.dropTable({ schema: 'public', table: 'studentSubject' }),
      this.dropTable({ schema: 'public', table: 'teacherSubject' }),
      this.addColumn({
        schema: 'public',
        table: 'subject',
        column: col('studentId', 'text', { codecRef: { codecId: 'pg/text@1' } }),
      }),
      this.addColumn({
        schema: 'public',
        table: 'subject',
        column: col('teacherId', 'text', { codecRef: { codecId: 'pg/text@1' } }),
      }),
      this.createIndex({
        schema: 'public',
        table: 'subject',
        index: 'subject_studentId_idx_bf255322',
        columns: ['studentId'],
      }),
      this.createIndex({
        schema: 'public',
        table: 'subject',
        index: 'subject_teacherId_idx_bc266660',
        columns: ['teacherId'],
      }),
      this.addForeignKey({
        schema: 'public',
        table: 'subject',
        foreignKey: {
          name: 'subject_studentId_fkey',
          columns: ['studentId'],
          references: { schema: 'public', table: 'student', columns: ['id'] },
        },
      }),
      this.addForeignKey({
        schema: 'public',
        table: 'subject',
        foreignKey: {
          name: 'subject_teacherId_fkey',
          columns: ['teacherId'],
          references: { schema: 'public', table: 'teacher', columns: ['id'] },
        },
      }),
    ];
  }
}

MigrationCLI.run(import.meta.url, M);
