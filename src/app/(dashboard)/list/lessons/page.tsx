import Pagination from "@/components/Pagination";
import Table from "@/components/Table";
import TableSearch from "@/components/TableSearch";
import Image from "next/image";
import type { Models } from "@/prisma/contract";
import { ITEM_PER_PAGE } from "@/lib/settings";
import { db } from "@/lib/db";
import { or } from "@prisma/orm-postgres/orm-client";
import { getCurrentAuth } from "@/lib/utils";
import { serialize } from "@/lib/serialize";
import FormContainer from "@/components/FormContainer";

const getColumns = (role?: string) => [
  {
    header: "Subject",
    accessor: "subject",
  },
  {
    header: "Class",
    accessor: "class",
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

const renderRow = (item: Models.public_Lesson, role?: string) => (
  <tr
    key={item.id}
    className="border-b border-gray-200 even:bg-slate-50 text-sm hover:bg-lamaPurpleLight"
  >
    {/* SUBJECT */}
    <td className="p-4">{item.subject.name}</td>

    {/* CLASS */}
    <td>{item.class.name}</td>

    {/* TEACHER */}
    <td className="hidden md:table-cell">{item.teacher ? item.teacher.name : "No teacher"}</td>

    {/* ACTIONS */}
    <td>
      <div className="flex items-center gap-2">
        {role === "admin" && (
          <>
            <FormContainer table="lesson" type="update" data={serialize(item)} />

            <FormContainer table="lesson" type="delete" id={item.id} />
          </>
        )}
      </div>
    </td>
  </tr>
);

const LessonListPage = async ({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | undefined }>;
}) => {
  const { role, currentUserId } = await getCurrentAuth();
  const { page, ...queryParams } = await searchParams;
  // console.log("Query params:", queryParams);
  // console.log("classId:", queryParams.classId);

  const p = page ? parseInt(page) : 1;

  let lessonQuery = db.orm.public.Lesson;
  let lessonCountQuery = db.orm.public.Lesson;

  // =========================
  // FILTERS
  // =========================

  for (const [key, value] of Object.entries(queryParams)) {
    if (!value) continue;

    switch (key) {
      // Filter by class
      case "classId": {
        lessonQuery = lessonQuery.where((lessonItem) => lessonItem.classId.eq(parseInt(value)));

        lessonCountQuery = lessonCountQuery.where((lessonItem) =>
          lessonItem.classId.eq(parseInt(value)),
        );

        break;
      }
      case "search": {
        lessonQuery = lessonQuery.where((lessonItem) =>
          or(
            lessonItem.name.ilike(`%${value}%`),
            lessonItem.subject.some((subject) => subject.name.ilike(`%${value}%`)),
            lessonItem.teacher.some((teacher) => teacher.name.ilike(`%${value}%`)),
          ),
        );

        lessonCountQuery = lessonCountQuery.where((lessonItem) =>
          or(
            lessonItem.name.ilike(`%${value}%`),
            lessonItem.subject.some((subject) => subject.name.ilike(`%${value}%`)),
            lessonItem.teacher.some((teacher) => teacher.name.ilike(`%${value}%`)),
          ),
        );

        break;
      }
      default:
        break;
    }
  }

  // ROLE CONDITION

  switch (role) {
    case "admin":
      break;

    case "teacher":
      lessonQuery = lessonQuery.where((assignment) =>
        assignment.teacherId.eq(currentUserId as string),
      );

      lessonCountQuery = lessonCountQuery.where((assignment) =>
        assignment.teacherId.eq(currentUserId as string),
      );
      break;

    case "student":
      lessonQuery = lessonQuery.where((assignment) =>
        assignment.class.some((classItem) =>
          classItem.students.some((student) => student.id.eq(currentUserId as string)),
        ),
      );

      lessonCountQuery = lessonCountQuery.where((assignment) =>
        assignment.class.some((classItem) =>
          classItem.students.some((student) => student.id.eq(currentUserId as string)),
        ),
      );
      break;

    case "parent":
      lessonQuery = lessonQuery.where((assignment) =>
        assignment.class.some((classItem) =>
          classItem.students.some((student) => student.parentId.eq(currentUserId as string)),
        ),
      );

      lessonCountQuery = lessonCountQuery.where((assignment) =>
        assignment.class.some((classItem) =>
          classItem.students.some((student) => student.parentId.eq(currentUserId as string)),
        ),
      );
      break;

    default:
      break;
  }

  // =========================
  // GET LESSONS
  // =========================

  const data = await lessonQuery
    .include("subject")
    .include("class")
    .include("teacher")
    .orderBy((lessonItem) => lessonItem.id.asc())
    .offset(ITEM_PER_PAGE * (p - 1))
    .limit(ITEM_PER_PAGE)
    .all();

  console.log(data);
  // =========================
  // COUNT
  // =========================

  const countResult = await lessonCountQuery.aggregate((agg) => ({
    total: agg.count(),
  }));

  const count = countResult.total;

  return (
    <div className="bg-white p-4 rounded-md flex-1 m-4 mt-0">
      {/* TOP */}
      <div className="flex items-center justify-between">
        <h1 className="hidden md:block text-lg font-semibold">All Lessons</h1>

        <div className="flex flex-col md:flex-row items-center gap-4 w-full md:w-auto">
          <TableSearch />

          <div className="flex items-center gap-4 self-end">
            <button className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow">
              <Image src="/filter.png" alt="" width={14} height={14} />
            </button>

            <button className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow">
              <Image src="/sort.png" alt="" width={14} height={14} />
            </button>

            {role === "admin" && <FormContainer table="lesson" type="create" />}
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

export default LessonListPage;
