import Pagination from "@/components/Pagination";
import Table from "@/components/Table";
import TableSearch from "@/components/TableSearch";
import { db } from "@/lib/db";
import { ITEM_PER_PAGE } from "@/lib/settings";
import Image from "next/image";
import type { Models } from "@/prisma/contract";
import { getCurrentAuth } from "@/lib/utils";
import { serialize } from "@/lib/serialize";
import FormContainer from "@/components/FormContainer";

const getColumns = (role?: string) => [
  {
    header: "Subject Name",
    accessor: "name",
  },
  {
    header: "Teacher",
    accessor: "teacher",
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

const renderRow = (item: Models.public_Subject, role?: string) => (
  <tr
    key={item.id}
    className="border-b border-gray-200 even:bg-slate-50 text-sm hover:bg-lamaPurpleLight"
  >
    {/* SUBJECT NAME */}
    <td className="flex items-center gap-4 p-4">{item.name}</td>

    {/* TEACHERS */}
    <td className="hidden md:table-cell">
      {item.teachers.length > 0
        ? item.teachers.map((teacherSubject) => `${teacherSubject.teacher.name}`).join(", ")
        : "No teacher assigned"}
    </td>

    {/* ACTIONS */}
    <td>
      <div className="flex items-center gap-2">
        {role === "admin" && (
          <>
            <FormContainer table="subject" type="update" data={serialize(item)} />

            <FormContainer table="subject" type="delete" id={item.id} />
          </>
        )}
      </div>
    </td>
  </tr>
);

const SubjectListPage = async ({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | undefined }>;
}) => {
  const { role } = await getCurrentAuth();
  const { page, ...queryParams } = await searchParams;

  const p = page ? parseInt(page) : 1;

  let subjectQuery = db.orm.public.Subject;
  let subjectCountQuery = db.orm.public.Subject;

  // =========================
  // FILTERS
  // =========================

  for (const [key, value] of Object.entries(queryParams)) {
    if (!value) continue;

    switch (key) {
      case "teacherId": {
        subjectQuery = subjectQuery.where((subject) =>
          subject.teachers.some((teacherSubject) => teacherSubject.teacherId.eq(value)),
        );

        subjectCountQuery = subjectCountQuery.where((subject) =>
          subject.teachers.some((teacherSubject) => teacherSubject.teacherId.eq(value)),
        );

        break;
      }
      case "search": {
        subjectQuery = subjectQuery.where((subject) => subject.name.ilike(`%${value}%`));

        subjectCountQuery = subjectCountQuery.where((subject) => subject.name.ilike(`%${value}%`));

        break;
      }
      default:
        break;
    }
  }

  // =========================
  // GET SUBJECTS
  // =========================

  const subjects = await subjectQuery
    .include("teachers")
    .orderBy((subject) => subject.id.asc())
    .offset(ITEM_PER_PAGE * (p - 1))
    .limit(ITEM_PER_PAGE)
    .all();

  // =========================
  // GET TEACHER RELATIONSHIPS
  // =========================

  const teacherSubjects = await db.orm.public.TeacherSubject.include("teacher").all();

  const data = subjects.map((subject) => ({
    ...subject,
    teachers: teacherSubjects.filter((teacherSubject) => teacherSubject.subjectId === subject.id),
  }));
  // =========================
  // COUNT
  // =========================

  const countResult = await subjectCountQuery.aggregate((agg) => ({
    total: agg.count(),
  }));

  const count = countResult.total;

  return (
    <div className="bg-white p-4 rounded-md flex-1 m-4 mt-0">
      {/* TOP */}
      <div className="flex items-center justify-between">
        <h1 className="hidden md:block text-lg font-semibold">All Subjects</h1>

        <div className="flex flex-col md:flex-row items-center gap-4 w-full md:w-auto">
          <TableSearch />

          <div className="flex items-center gap-4 self-end">
            <button className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow">
              <Image src="/filter.png" alt="Filter" width={14} height={14} />
            </button>

            <button className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow">
              <Image src="/sort.png" alt="Sort" width={14} height={14} />
            </button>

            {role === "admin" && <FormContainer table="subject" type="create" />}
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

export default SubjectListPage;
