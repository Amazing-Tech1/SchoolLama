#!/usr/bin/env -S node
import type { Contract as Start } from "../../snapshots/6c804f032a141586ed857434558a878ecde3d201bc829a8977e7548daab47bc0/contract";
import startContract from "../../snapshots/6c804f032a141586ed857434558a878ecde3d201bc829a8977e7548daab47bc0/contract.json" with { type: "json" };
import type { Contract as End } from "../../snapshots/8e3c300837c274c2361cae7383e9687171d12f23cae53cf9f4de14ead55f4efc/contract";
import endContract from "../../snapshots/8e3c300837c274c2361cae7383e9687171d12f23cae53cf9f4de14ead55f4efc/contract.json" with { type: "json" };
const typedEndContract = endContract as unknown as End;
import { Migration, MigrationCLI, col, placeholder } from "@prisma/orm-postgres/migration";

export default class M extends Migration<Start, End> {
  override readonly startContractJson = startContract;
  override readonly endContractJson = endContract;

  override get operations() {
    return [
      this.addColumn({
        schema: "public",
        table: "student",
        column: col("birthday", "timestamptz", {
          codecRef: { codecId: "pg/timestamptz-temporal@1" },
        }),
      }),
      this.dataTransform(typedEndContract, "backfill-student-birthday", {
        check: () => placeholder("backfill-student-birthday:check"),
        run: () => placeholder("backfill-student-birthday:run"),
      }),
      this.setNotNull({ schema: "public", table: "student", column: "birthday" }),
      this.addColumn({
        schema: "public",
        table: "teacher",
        column: col("birthday", "timestamptz", {
          codecRef: { codecId: "pg/timestamptz-temporal@1" },
        }),
      }),
      this.dataTransform(typedEndContract, "backfill-teacher-birthday", {
        check: () => placeholder("backfill-teacher-birthday:check"),
        run: () => placeholder("backfill-teacher-birthday:run"),
      }),
      this.setNotNull({ schema: "public", table: "teacher", column: "birthday" }),
      this.addColumn({
        schema: "public",
        table: "teacher",
        column: col("bloodType", "text", { codecRef: { codecId: "pg/text@1" } }),
      }),
      this.dataTransform(typedEndContract, "backfill-teacher-bloodType", {
        check: () => placeholder("backfill-teacher-bloodType:check"),
        run: () => placeholder("backfill-teacher-bloodType:run"),
      }),
      this.setNotNull({ schema: "public", table: "teacher", column: "bloodType" }),
      this.addColumn({
        schema: "public",
        table: "teacher",
        column: col("sex", "text", { codecRef: { codecId: "pg/text@1" } }),
      }),
      this.dataTransform(typedEndContract, "backfill-teacher-sex", {
        check: () => placeholder("backfill-teacher-sex:check"),
        run: () => placeholder("backfill-teacher-sex:run"),
      }),
      this.setNotNull({ schema: "public", table: "teacher", column: "sex" }),
      this.addCheckConstraint({
        schema: "public",
        table: "teacher",
        constraint: "teacher_sex_check_0c53a478",
        expression: "\"sex\" IN ('MALE', 'FEMALE')",
      }),
    ];
  }
}

MigrationCLI.run(import.meta.url, M);
