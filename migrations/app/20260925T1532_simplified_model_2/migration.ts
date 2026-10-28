#!/usr/bin/env -S node
import type { Contract as Start } from '../../snapshots/22fb3ea199914ae70284f364114b1a8b310ecd8e00721fef48193acf282d3cbb/contract';
import startContract from '../../snapshots/22fb3ea199914ae70284f364114b1a8b310ecd8e00721fef48193acf282d3cbb/contract.json' with { type: 'json' };
import type { Contract as End } from '../../snapshots/a2f029c63902cfca70a36b60879580d2176d4652b8f02657d9dcab9bf9396b98/contract';
import endContract from '../../snapshots/a2f029c63902cfca70a36b60879580d2176d4652b8f02657d9dcab9bf9396b98/contract.json' with { type: 'json' };
import { Migration, MigrationCLI } from '@prisma/orm-postgres/migration';

export default class M extends Migration<Start, End> {
  override readonly startContractJson = startContract;
  override readonly endContractJson = endContract;

  override get operations() {
    return [
      this.dropConstraint({
        schema: 'public',
        table: 'subject',
        constraint: 'subject_studentId_fkey',
        kind: 'foreignKey',
      }),
      this.dropConstraint({
        schema: 'public',
        table: 'subject',
        constraint: 'subject_teacherId_fkey',
        kind: 'foreignKey',
      }),
      this.dropIndex({
        schema: 'public',
        table: 'subject',
        index: 'subject_studentId_idx_bf255322',
      }),
      this.dropColumn({ schema: 'public', table: 'subject', column: 'studentId' }),
      this.dropIndex({
        schema: 'public',
        table: 'subject',
        index: 'subject_teacherId_idx_bc266660',
      }),
      this.dropColumn({ schema: 'public', table: 'subject', column: 'teacherId' }),
    ];
  }
}

MigrationCLI.run(import.meta.url, M);
