#!/usr/bin/env -S node
import type { Contract as Start } from '../../snapshots/c88e90b74669e5822294098b75fc4b529864a0451b48a8cc9ad27b36567ebb68/contract';
import startContract from '../../snapshots/c88e90b74669e5822294098b75fc4b529864a0451b48a8cc9ad27b36567ebb68/contract.json' with { type: 'json' };
import type { Contract as End } from '../../snapshots/cda5a3a2d6a59ba2fe4b1b492fcfee2d5a7405e1bdca106a23170f745f6531c9/contract';
import endContract from '../../snapshots/cda5a3a2d6a59ba2fe4b1b492fcfee2d5a7405e1bdca106a23170f745f6531c9/contract.json' with { type: 'json' };
import { Migration, MigrationCLI, col } from '@prisma/orm-postgres/migration';

export default class M extends Migration<Start, End> {
  override readonly startContractJson = startContract;
  override readonly endContractJson = endContract;

  override get operations() {
    return [
      this.addColumn({
        schema: 'public',
        table: 'parent',
        column: col('img', 'text', { codecRef: { codecId: 'pg/text@1' } }),
      }),
    ];
  }
}

MigrationCLI.run(import.meta.url, M);
