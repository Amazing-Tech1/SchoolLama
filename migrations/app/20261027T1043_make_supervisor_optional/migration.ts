#!/usr/bin/env -S node
import type { Contract as Start } from '../../snapshots/17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68/contract';
import startContract from '../../snapshots/17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68/contract.json' with { type: 'json' };
import type { Contract as End } from '../../snapshots/6c804f032a141586ed857434558a878ecde3d201bc829a8977e7548daab47bc0/contract';
import endContract from '../../snapshots/6c804f032a141586ed857434558a878ecde3d201bc829a8977e7548daab47bc0/contract.json' with { type: 'json' };
import { Migration, MigrationCLI } from '@prisma/orm-postgres/migration';

export default class M extends Migration<Start, End> {
  override readonly startContractJson = startContract;
  override readonly endContractJson = endContract;

  override get operations() {
    return [this.dropNotNull({ schema: 'public', table: 'class', column: 'supervisorId' })];
  }
}

MigrationCLI.run(import.meta.url, M);
