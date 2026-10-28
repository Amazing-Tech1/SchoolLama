#!/usr/bin/env -S node
import type { Contract as End } from '../../snapshots/17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68/contract';
import endContract from '../../snapshots/17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68/contract.json' with { type: 'json' };
import type { Contract as Start } from '../../snapshots/f572a307db7fb4e13a470399f41c4f5a4a7692a7f55387c61c22bfae6a1f7b2f/contract';
import startContract from '../../snapshots/f572a307db7fb4e13a470399f41c4f5a4a7692a7f55387c61c22bfae6a1f7b2f/contract.json' with { type: 'json' };
import { Migration, MigrationCLI, col } from '@prisma/orm-postgres/migration';

export default class M extends Migration<Start, End> {
  override readonly startContractJson = startContract;
  override readonly endContractJson = endContract;

  override get operations() {
    return [
      this.addColumn({
        schema: 'public',
        table: 'teacher',
        column: col('img', 'text', { codecRef: { codecId: 'pg/text@1' } }),
      }),
    ];
  }
}

MigrationCLI.run(import.meta.url, M);
