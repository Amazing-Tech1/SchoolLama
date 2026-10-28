import "server-only";
import "dotenv/config";
import "temporal-polyfill/full/global";

import postgres from "@prisma/orm-postgres/runtime";
import contractJson from "@/prisma/contract.json" with { type: "json" };

import type { Contract } from "@/prisma/contract";

const databaseUrl = new URL(process.env.DATABASE_URL!);

// On Windows, localhost can resolve to a different PostgreSQL instance than Docker's IPv6 listener.
if (databaseUrl.hostname === "localhost") {
  databaseUrl.hostname = "::1";
}

export const db = postgres<Contract>({
  contractJson,
  url: databaseUrl.toString(),
});
