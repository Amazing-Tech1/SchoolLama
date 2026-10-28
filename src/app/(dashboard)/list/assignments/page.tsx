import Pagination from "@/components/Pagination";
import Table from "@/components/Table";
import TableSearch from "@/components/TableSearch";

import Image from "next/image";
import { ITEM_PER_PAGE } from "@/lib/settings";
import { db } from "@/lib/db";
import { or } from "@prisma/orm-postgres/orm-client";
import { Models } from "@/prisma/contract";
import { getCurrentAuth } from "@/lib/utils";
import { serialize } from "@/lib/serialize";
import FormContainer from "@/components/FormContainer";

const getColumns = (role?: string) => [
  {
    header: "Subject Name",
    accessor: "name",
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
  {
    header: "Due Date",
    accessor: "dueDate",
    className: "hidden md:table-cell",
  },
  ...(role === "admin" || role === "teacher"
    ? [
        {
          header: "Actions",
          accessor: "action",
        },
      ]
    : []),
];

const AssignmentListPage = async ({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | undefined }>;
}) => {
  const { currentUserId, role } = await getCurrentAuth();
  const { page, ...queryParams } = await searchParams;

  const p = page ? parseInt(page) : 1;

  let lessonQuery = db.orm.public.Assignment;
  let lessonCountQuery = db.orm.public.Assignment;

  // =========================
  // FILTERS
  // =========================

  for (const [key, value] of Object.entries(queryParams)) {
    if (!value) continue;

    switch (key) {
      case "classId": {
        const classId = parseInt(value, 10);

        lessonQuery = lessonQuery.where((assignment) =>
          assignment.lesson.some((lesson) => lesson.classId.eq(classId)),
        );

        lessonCountQuery = lessonCountQuery.where((assignment) =>
          assignment.lesson.some((lesson) => lesson.classId.eq(classId)),
        );

        break;
      }

      case "search": {
        lessonQuery = lessonQuery.where((assignment) =>
          or(
            assignment.title.ilike(`%${value}%`),
            assignment.lesson.some((lesson) =>
              or(
                lesson.name.ilike(`%${value}%`),
                lesson.subject.some((subject) => subject.name.ilike(`%${value}%`)),
                lesson.teacher.some((teacher) => teacher.name.ilike(`%${value}%`)),
              ),
            ),
          ),
        );

        lessonCountQuery = lessonCountQuery.where((assignment) =>
          or(
            assignment.title.ilike(`%${value}%`),
            assignment.lesson.some((lesson) =>
              or(
                lesson.name.ilike(`%${value}%`),
                lesson.subject.some((subject) => subject.name.ilike(`%${value}%`)),
                lesson.teacher.some((teacher) => teacher.name.ilike(`%${value}%`)),
              ),
            ),
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
        assignment.lesson.some((lesson) => lesson.teacherId.eq(currentUserId as string)),
      );

      lessonCountQuery = lessonCountQuery.where((assignment) =>
        assignment.lesson.some((lesson) => lesson.teacherId.eq(currentUserId as string)),
      );
      break;

    case "student":
      lessonQuery = lessonQuery.where((assignment) =>
        assignment.lesson.some((lesson) =>
          lesson.class.some((classItem) =>
            classItem.students.some((student) => student.id.eq(currentUserId as string)),
          ),
        ),
      );

      lessonCountQuery = lessonCountQuery.where((assignment) =>
        assignment.lesson.some((lesson) =>
          lesson.class.some((classItem) =>
            classItem.students.some((student) => student.id.eq(currentUserId as string)),
          ),
        ),
      );
      break;

    case "parent":
      lessonQuery = lessonQuery.where((assignment) =>
        assignment.lesson.some((lesson) =>
          lesson.class.some((classItem) =>
            classItem.students.some((student) => student.parentId.eq(currentUserId as string)),
          ),
        ),
      );

      lessonCountQuery = lessonCountQuery.where((assignment) =>
        assignment.lesson.some((lesson) =>
          lesson.class.some((classItem) =>
            classItem.students.some((student) => student.parentId.eq(currentUserId as string)),
          ),
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
    .include("lesson", (lesson) => lesson.include("class").include("subject").include("teacher"))
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
  const renderRow = (item: Models.public_Assignment) => (
    <tr
      key={item.id}
      className="border-b border-gray-200 even:bg-slate-50 text-sm hover:bg-lamaPurpleLight"
    >
      <td className="flex items-center gap-4 p-4">{item.lesson?.subject.name}</td>
      <td>{item.lesson?.class.name}</td>
      <td className="hidden md:table-cell">{item.lesson?.teacher.name}</td>
      <td className="hidden md:table-cell">
        {new Intl.DateTimeFormat("en-US").format(item?.dueTime)}
      </td>
      <td>
        <div className="flex items-center gap-2">
          {(role === "admin" || role === "teacher") && (
            <>
              <FormContainer table="assignment" type="update" data={serialize(item)} />
              <FormContainer table="assignment" type="delete" id={item.id} />
            </>
          )}
        </div>
      </td>
    </tr>
  );

  return (
    <div className="bg-white p-4 rounded-md flex-1 m-4 mt-0">
      {/* TOP */}
      <div className="flex items-center justify-between">
        <h1 className="hidden md:block text-lg font-semibold">All Assignments</h1>
        <div className="flex flex-col md:flex-row items-center gap-4 w-full md:w-auto">
          <TableSearch />
          <div className="flex items-center gap-4 self-end">
            <button className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow">
              <Image src="/filter.png" alt="" width={14} height={14} />
            </button>
            <button className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow">
              <Image src="/sort.png" alt="" width={14} height={14} />
            </button>
            {(role === "admin" || role === "teacher") && (
              <FormContainer table="assignment" type="create" />
            )}
          </div>
        </div>
      </div>
      {/* LIST */}
      <Table columns={getColumns(role)} renderRow={renderRow} data={data} />
      {/* PAGINATION */}
      <Pagination page={p} count={count} />
    </div>
  );
};

export default AssignmentListPage;
