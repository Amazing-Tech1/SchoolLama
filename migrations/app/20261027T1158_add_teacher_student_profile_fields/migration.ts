#!/usr/bin/env -S node
import type { Contract as Start } from '../../snapshots/6c804f032a141586ed857434558a878ecde3d201bc829a8977e7548daab47bc0/contract';
import startContract from '../../snapshots/6c804f032a141586ed857434558a878ecde3d201bc829a8977e7548daab47bc0/contract.json' with { type: 'json' };
import type { Contract as End } from '../../snapshots/c88e90b74669e5822294098b75fc4b529864a0451b48a8cc9ad27b36567ebb68/contract';
import endContract from '../../snapshots/c88e90b74669e5822294098b75fc4b529864a0451b48a8cc9ad27b36567ebb68/contract.json' with { type: 'json' };
import { Migration, MigrationCLI, col } from '@prisma/orm-postgres/migration';

export default class M extends Migration<Start, End> {
  override readonly startContractJson = startContract;
  override readonly endContractJson = endContract;

  override get operations() {
    return [
      this.addColumn({
        schema: 'public',
        table: 'student',
        column: col('birthday', 'timestamptz', {
          codecRef: { codecId: 'pg/timestamptz-temporal@1' },
        }),
      }),
      this.addColumn({
        schema: 'public',
        table: 'teacher',
        column: col('birthday', 'timestamptz', {
          codecRef: { codecId: 'pg/timestamptz-temporal@1' },
        }),
      }),
      this.addColumn({
        schema: 'public',
        table: 'teacher',
        column: col('bloodType', 'text', { codecRef: { codecId: 'pg/text@1' } }),
      }),
      this.addColumn({
        schema: 'public',
        table: 'teacher',
        column: col('sex', 'text', { codecRef: { codecId: 'pg/text@1' } }),
      }),
      this.dropNotNull({ schema: 'public', table: 'student', column: 'bloodType' }),
      this.dropNotNull({ schema: 'public', table: 'student', column: 'sex' }),
      this.addCheckConstraint({
        schema: 'public',
        table: 'teacher',
        constraint: 'teacher_sex_check_0c53a478',
        expression: "\"sex\" IN ('MALE', 'FEMALE')",
      }),
    ];
  }
}

MigrationCLI.run(import.meta.url, M);
