import Pagination from "@/components/Pagination";
import Table from "@/components/Table";
import TableSearch from "@/components/TableSearch";
import { db } from "@/lib/db";
import Image from "next/image";
import type { Models } from "@/prisma/contract";
import { ITEM_PER_PAGE } from "@/lib/settings";
import { getCurrentAuth } from "@/lib/utils";
import FormContainer from "@/components/FormContainer";
import { serialize } from "@/lib/serialize";

const getColumns = (role?: string) => [
  {
    header: "Class Name",
    accessor: "name",
  },
  {
    header: "Capacity",
    accessor: "capacity",
    className: "hidden md:table-cell",
  },
  {
    header: "Grade",
    accessor: "grade",
    className: "hidden md:table-cell",
  },
  {
    header: "Supervisor",
    accessor: "supervisor",
    className: "hidden md:table-cell",
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

const renderRow = (item: Models.public_Class, role?: string) => (
  <tr
    key={item.id}
    className="border-b border-gray-200 even:bg-slate-50 text-sm hover:bg-lamaPurpleLight"
  >
    {/* CLASS NAME */}
    <td className="flex items-center gap-4 p-4">{item.name}</td>

    {/* CAPACITY */}
    <td className="hidden md:table-cell">{item.capacity}</td>

    {/* GRADE */}
    <td className="hidden md:table-cell">{item.grade?.level ?? "N/A"}</td>

    {/* SUPERVISOR */}
    <td className="hidden md:table-cell">
      {item.supervisor ? `${item.supervisor.name}` : "No supervisor"}
    </td>

    {/* ACTIONS */}
    <td>
      <div className="flex items-center gap-2">
        {role === "admin" && (
          <>
            <FormContainer table="class" type="update" data={item} />

            <FormContainer table="class" type="delete" id={item.id} />
          </>
        )}
      </div>
    </td>
  </tr>
);

const ClassListPage = async ({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | undefined }>;
}) => {
  const { role } = await getCurrentAuth();
  const { page, ...queryParams } = await searchParams;

  const p = page ? parseInt(page) : 1;

  let classQuery = db.orm.public.Class;
  let classCountQuery = db.orm.public.Class;

  // =========================
  // FILTERS
  // =========================

  for (const [key, value] of Object.entries(queryParams)) {
    if (!value) continue;

    switch (key) {
      // Filter by supervisor
      case "supervisorId": {
        classQuery = classQuery.where((classItem) => classItem.supervisorId.eq(value));

        classCountQuery = classCountQuery.where((classItem) => classItem.supervisorId.eq(value));

        break;
      }

      // Search class name
      case "search": {
        classQuery = classQuery.where((classItem) => classItem.name.ilike(`%${value}%`));

        classCountQuery = classCountQuery.where((classItem) => classItem.name.ilike(`%${value}%`));

        break;
      }
      default:
        break;
    }
  }

  // =========================
  // GET CLASSES
  // =========================

  const data = await classQuery
    .include("supervisor")
    .include("grade")
    .orderBy((classItem) => classItem.id.asc())
    .offset(ITEM_PER_PAGE * (p - 1))
    .limit(ITEM_PER_PAGE)
    .all();

  // =========================
  // COUNT
  // =========================

  const countResult = await classCountQuery.aggregate((agg) => ({
    total: agg.count(),
  }));

  const count = countResult.total;

  return (
    <div className="bg-white p-4 rounded-md flex-1 m-4 mt-0">
      {/* TOP */}
      <div className="flex items-center justify-between">
        <h1 className="hidden md:block text-lg font-semibold">All Classes</h1>

        <div className="flex flex-col md:flex-row items-center gap-4 w-full md:w-auto">
          <TableSearch />

          <div className="flex items-center gap-4 self-end">
            <button className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow">
              <Image src="/filter.png" alt="" width={14} height={14} />
            </button>

            <button className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow">
              <Image src="/sort.png" alt="" width={14} height={14} />
            </button>

            {role === "admin" && <FormContainer table="class" type="create" />}
          </div>
        </div>
      </div>

      {/* LIST */}
      <Table
        columns={getColumns(role)}
        renderRow={(item) => renderRow(item, role)}
        data={serialize(data)}
      />

      {/* PAGINATION */}
      <Pagination page={p} count={count} />
    </div>
  );
};

export default ClassListPage;
