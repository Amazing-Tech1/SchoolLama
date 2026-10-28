import Pagination from "@/components/Pagination";
import Table from "@/components/Table";
import TableSearch from "@/components/TableSearch";
import { db } from "@/lib/db";
import Image from "next/image";
import { or } from "@prisma/orm-postgres/orm-client";
import { ITEM_PER_PAGE } from "@/lib/settings";
import type { Models } from "@/prisma/contract";
import { getCurrentAuth } from "@/lib/utils";
import FormContainer from "@/components/FormContainer";
import { serialize } from "@/lib/serialize";
const getColumns = (role?: string) => [
  {
    header: "Info",
    accessor: "info",
  },
  {
    header: "Student Names",
    accessor: "students",
    className: "hidden md:table-cell",
  },
  {
    header: "Phone",
    accessor: "phone",
    className: "hidden lg:table-cell",
  },
  {
    header: "Address",
    accessor: "address",
    className: "hidden lg:table-cell",
  },
  ...(role === "admin"
    ? [
        {
          header: "Actions",
          accessor: "action",
        },
      ]
    : []),
];

const renderRow = (
  item: Models.public_Parent & {
    students: {
      name: string;
      surname: string;
    }[];
  },
  role?: string,
) => {
  return (
    <tr
      key={item.id}
      className="border-b border-gray-200 even:bg-slate-50 text-sm hover:bg-lamaPurpleLight"
    >
      <td className="flex items-center gap-4 p-4">
        <div className="flex flex-col">
          <h3 className="font-semibold">{item.name}</h3>
          <p className="text-xs text-gray-500">{item?.email}</p>
        </div>
      </td>

      <td className="hidden md:table-cell">
        {item.students.map((student) => student.name).join(", ")}
      </td>

      <td className="hidden md:table-cell">{item.phone}</td>

      <td className="hidden md:table-cell">{item.address}</td>

      <td>
        <div className="flex items-center gap-2">
          {role === "admin" && (
            <>
              <FormContainer table="parent" type="update" data={serialize(item)} />
              <FormContainer table="parent" type="delete" id={item.id} />
            </>
          )}
        </div>
      </td>
    </tr>
  );
};
const ParentListPage = async ({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | undefined }>;
}) => {
  const { role } = await getCurrentAuth();
  const { page, ...queryParams } = await searchParams;

  const p = page ? parseInt(page) : 1;

  let parentQuery = db.orm.public.Parent;
  let parentCountQuery = db.orm.public.Parent;

  for (const [key, value] of Object.entries(queryParams)) {
    if (value === undefined) continue;

    switch (key) {
      case "studentId": {
        parentQuery = parentQuery.where((parent) =>
          parent.students.some((student) => student.id.eq(value)),
        );
        parentCountQuery = parentCountQuery.where((parent) =>
          parent.students.some((student) => student.id.eq(value)),
        );
        break;
      }

      case "search": {
        parentQuery = parentQuery.where((parent) =>
          or(
            parent.name.ilike(`%${value}%`),
            parent.surname.ilike(`%${value}%`),
            parent.username.ilike(`%${value}%`),
          ),
        );

        parentCountQuery = parentCountQuery.where((parent) =>
          or(
            parent.name.ilike(`%${value}%`),
            parent.surname.ilike(`%${value}%`),
            parent.username.ilike(`%${value}%`),
          ),
        );

        break;
      }
      default:
        break;
    }
  }

  const data = await parentQuery
    .include("students")
    .orderBy((student) => student.id.asc())
    .offset(ITEM_PER_PAGE * (p - 1))
    .limit(ITEM_PER_PAGE)
    .all();

  console.log("data:", data);
  const countResult = await parentCountQuery.aggregate((agg) => ({
    total: agg.count(),
  }));

  const count = countResult.total;

  return (
    <div className="bg-white p-4 rounded-md flex-1 m-4 mt-0">
      {/* TOP */}
      <div className="flex items-center justify-between">
        <h1 className="hidden md:block text-lg font-semibold">All Parents</h1>
        <div className="flex flex-col md:flex-row items-center gap-4 w-full md:w-auto">
          <TableSearch />
          <div className="flex items-center gap-4 self-end">
            <button className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow">
              <Image src="/filter.png" alt="" width={14} height={14} />
            </button>
            <button className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow">
              <Image src="/sort.png" alt="" width={14} height={14} />
            </button>
            {role === "admin" && <FormContainer table="parent" type="create" />}
          </div>
        </div>
      </div>
      {/* LIST */}
      <Table columns={getColumns(role)} renderRow={(item) => renderRow(item, role)} data={data} />
      {/* PAGINATION */}
      <Pagination page={p} count={count} />
    </div>
  );
};

export default ParentListPage;
