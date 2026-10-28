import FormContainer from "@/components/FormContainer";
import Pagination from "@/components/Pagination";
import Table from "@/components/Table";
import TableSearch from "@/components/TableSearch";
import Image from "next/image";
import { ITEM_PER_PAGE } from "@/lib/settings";
import { db } from "@/lib/db";
import { or } from "@prisma/orm-postgres/orm-client";
import { getCurrentAuth } from "@/lib/utils";

type ResultListItem = {
  id: number;
  studentId: string;
  examId?: number;
  assignmentId?: number;
  title: string;
  assessment: string;
  studentName: string;
  studentSurname: string;
  teacherName: string | null;
  teacherSurname: string | null;
  score: number;
  className: string | null;
  startTime: string | null;
};

const getColumns = (role?: string) => [
  {
    header: "Title",
    accessor: "name",
  },
  {
    header: "Student",
    accessor: "student",
  },
  {
    header: "Score",
    accessor: "score",
    className: "hidden md:table-cell",
  },
  {
    header: "Teacher",
    accessor: "teacher",
    className: "hidden md:table-cell",
  },
  {
    header: "Class",
    accessor: "class",
    className: "hidden md:table-cell",
  },
  {
    header: "Date",
    accessor: "date",
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

const ResultListPage = async ({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | undefined }>;
}) => {
  const { currentUserId, role } = await getCurrentAuth();
  const { page, ...queryParams } = await searchParams;

  const p = page ? parseInt(page) : 1;

  let lessonQuery = db.orm.public.Result;
  let lessonCountQuery = db.orm.public.Result;

  // =========================
  // FILTERS
  // =========================

  for (const [key, value] of Object.entries(queryParams)) {
    if (!value) continue;

    switch (key) {
      case "classId": {
        const classId = Number.parseInt(value, 10);
        if (Number.isNaN(classId)) break;

        lessonQuery = lessonQuery.where((result) =>
          or(
            result.exam.some((exam) => exam.lesson.some((lesson) => lesson.classId.eq(classId))),
            result.assignment.some((assignment) =>
              assignment.lesson.some((lesson) => lesson.classId.eq(classId)),
            ),
          ),
        );
        lessonCountQuery = lessonCountQuery.where((result) =>
          or(
            result.exam.some((exam) => exam.lesson.some((lesson) => lesson.classId.eq(classId))),
            result.assignment.some((assignment) =>
              assignment.lesson.some((lesson) => lesson.classId.eq(classId)),
            ),
          ),
        );
        break;
      }

      case "teacherId": {
        lessonQuery = lessonQuery.where((result) =>
          or(
            result.exam.some((exam) => exam.lesson.some((lesson) => lesson.teacherId.eq(value))),
            result.assignment.some((assignment) =>
              assignment.lesson.some((lesson) => lesson.teacherId.eq(value)),
            ),
          ),
        );
        lessonCountQuery = lessonCountQuery.where((result) =>
          or(
            result.exam.some((exam) => exam.lesson.some((lesson) => lesson.teacherId.eq(value))),
            result.assignment.some((assignment) =>
              assignment.lesson.some((lesson) => lesson.teacherId.eq(value)),
            ),
          ),
        );
        break;
      }

      case "studentId": {
        lessonQuery = lessonQuery.where((result) => result.studentId.eq(value));

        lessonCountQuery = lessonCountQuery.where((result) => result.studentId.eq(value));

        break;
      }

      case "search": {
        const searchTerm = `%${value}%`;
        lessonQuery = lessonQuery.where((result) =>
          or(
            result.student.some((student) =>
              or(student.name.ilike(searchTerm), student.surname.ilike(searchTerm)),
            ),

            result.exam.some((exam) =>
              or(
                exam.title.ilike(searchTerm),
                exam.lesson.some((lesson) =>
                  or(
                    lesson.name.ilike(searchTerm),
                    lesson.subject.some((subject) => subject.name.ilike(searchTerm)),
                    lesson.teacher.some((teacher) =>
                      or(teacher.name.ilike(searchTerm), teacher.surname.ilike(searchTerm)),
                    ),
                    lesson.class.some((classItem) => classItem.name.ilike(searchTerm)),
                  ),
                ),
              ),
            ),

            result.assignment.some((assignment) =>
              or(
                assignment.title.ilike(searchTerm),
                assignment.lesson.some((lesson) =>
                  or(
                    lesson.name.ilike(searchTerm),
                    lesson.subject.some((subject) => subject.name.ilike(searchTerm)),
                    lesson.teacher.some((teacher) =>
                      or(teacher.name.ilike(searchTerm), teacher.surname.ilike(searchTerm)),
                    ),
                    lesson.class.some((classItem) => classItem.name.ilike(searchTerm)),
                  ),
                ),
              ),
            ),
          ),
        );

        lessonCountQuery = lessonCountQuery.where((result) =>
          or(
            result.student.some((student) =>
              or(student.name.ilike(searchTerm), student.surname.ilike(searchTerm)),
            ),

            result.exam.some((exam) =>
              or(
                exam.title.ilike(searchTerm),
                exam.lesson.some((lesson) =>
                  or(
                    lesson.name.ilike(searchTerm),
                    lesson.subject.some((subject) => subject.name.ilike(searchTerm)),
                    lesson.teacher.some((teacher) =>
                      or(teacher.name.ilike(searchTerm), teacher.surname.ilike(searchTerm)),
                    ),
                    lesson.class.some((classItem) => classItem.name.ilike(searchTerm)),
                  ),
                ),
              ),
            ),

            result.assignment.some((assignment) =>
              or(
                assignment.title.ilike(searchTerm),
                assignment.lesson.some((lesson) =>
                  or(
                    lesson.name.ilike(searchTerm),
                    lesson.subject.some((subject) => subject.name.ilike(searchTerm)),
                    lesson.teacher.some((teacher) =>
                      or(teacher.name.ilike(searchTerm), teacher.surname.ilike(searchTerm)),
                    ),
                    lesson.class.some((classItem) => classItem.name.ilike(searchTerm)),
                  ),
                ),
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

  switch (role) {
    case "admin":
      break;

    case "teacher":
      lessonQuery = lessonQuery.where((result) =>
        or(
          result.assignment.some((ass) =>
            ass.lesson.some((lesson) => lesson.teacherId.eq(currentUserId as string)),
          ),
          result.exam.some((ass) =>
            ass.lesson.some((lesson) => lesson.teacherId.eq(currentUserId as string)),
          ),
        ),
      );

      lessonCountQuery = lessonCountQuery.where((result) =>
        or(
          result.assignment.some((ass) =>
            ass.lesson.some((lesson) => lesson.teacherId.eq(currentUserId as string)),
          ),
          result.exam.some((ass) =>
            ass.lesson.some((lesson) => lesson.teacherId.eq(currentUserId as string)),
          ),
        ),
      );
      break;

    case "student":
      lessonQuery = lessonQuery.where((result) => result.studentId.eq(currentUserId as string));

      lessonCountQuery = lessonCountQuery.where((result) =>
        result.studentId.eq(currentUserId as string),
      );
      break;

    case "parent":
      lessonQuery = lessonQuery.where((result) =>
        result.student.some((st) => st.parentId.eq(currentUserId as string)),
      );

      lessonCountQuery = lessonCountQuery.where((result) =>
        result.student.some((st) => st.parentId.eq(currentUserId as string)),
      );
      break;

    default:
      break;
  }
  // =========================
  // GET LESSONS
  // =========================

  const dataRes = await lessonQuery
    .include("student")
    .include("exam", (exam) =>
      exam.include("lesson", (lesson) =>
        lesson.include("subject").include("teacher").include("class"),
      ),
    )
    .include("assignment", (assignment) =>
      assignment.include("lesson", (lesson) =>
        lesson.include("subject").include("teacher").include("class"),
      ),
    )
    .orderBy((lessonItem) => lessonItem.id.asc())
    .offset(ITEM_PER_PAGE * (p - 1))
    .limit(ITEM_PER_PAGE)
    .all();

  // =========================
  // COUNT
  // =========================

  const countResult = await lessonCountQuery.aggregate((agg) => ({
    total: agg.count(),
  }));

  const count = countResult.total;

  const renderRow = (item: ResultListItem) => (
    <tr
      key={item.id}
      className="border-b border-gray-200 even:bg-slate-50 text-sm hover:bg-lamaPurpleLight"
    >
      <td className="flex items-center gap-4 p-4">{item.title}</td>
      <td>
        {item.studentName} {item.studentSurname}
      </td>
      <td className="hidden md:table-cell">{item.score}</td>
      <td className="hidden md:table-cell">
        {[item.teacherName, item.teacherSurname].filter(Boolean).join(" ") || "—"}
      </td>
      <td className="hidden md:table-cell">{item.className ?? "—"}</td>
      <td className="hidden md:table-cell">
        {item.startTime ? new Intl.DateTimeFormat("en-US").format(new Date(item.startTime)) : "—"}
      </td>
      <td>
        <div className="flex items-center gap-2">
          {(role === "admin" || role === "teacher") && (
            <>
              <FormContainer table="result" type="update" data={item} />
              <FormContainer table="result" type="delete" id={item.id} />
            </>
          )}
        </div>
      </td>
    </tr>
  );

  const data = dataRes.map((item): ResultListItem => {
    const assessment = item.exam || item.assignment;

    return {
      id: item.id,
      studentId: item.studentId,

      // Keep the IDs needed by the edit form
      examId: item.exam?.id ?? undefined,
      assignmentId: item.assignment?.id ?? undefined,

      title: assessment?.title ?? "No assessment linked",
      assessment: item.exam
        ? `exam:${item.exam.id}`
        : item.assignment
          ? `assignment:${item.assignment.id}`
          : "",

      studentName: item.student.name,
      studentSurname: item.student.surname,
      teacherName: assessment?.lesson?.teacher.name ?? null,
      teacherSurname: assessment?.lesson?.teacher.surname ?? null,
      score: item.score,
      className: assessment?.lesson?.class.name ?? null,
      startTime: assessment?.startTime?.toString() ?? null,
    };
  });
  return (
    <div className="bg-white p-4 rounded-md flex-1 m-4 mt-0">
      {/* TOP */}
      <div className="flex items-center justify-between">
        <h1 className="hidden md:block text-lg font-semibold">All Results</h1>
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
              <FormContainer table="result" type="create" />
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

export default ResultListPage;
