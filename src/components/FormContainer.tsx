import { getCurrentAuth } from "@/lib/utils";
import FormModal from "./FormModal";
import { db } from "@/lib/db";
import { serialize } from "@/lib/serialize";
import { all } from "@prisma/orm-postgres/orm-client";

export type formContainerProps = {
  table:
    | "teacher"
    | "student"
    | "parent"
    | "subject"
    | "class"
    | "lesson"
    | "exam"
    | "assignment"
    | "result"
    | "attendance"
    | "event"
    | "announcement";
  type: "create" | "update" | "delete";
  data?: any;
  id?: number | string;
};

const FormContainer = async ({ table, type, data, id }: formContainerProps) => {
  const { role, currentUserId } = await getCurrentAuth();

  let relatedData = {};

  if (type !== "delete") {
    switch (table) {
      case "subject": {
        const teachers = await db.orm.public.Teacher.select("id", "name", "surname").all();

        let selectedTeacherIds: string[] = [];

        if (type === "update" && data?.id !== undefined) {
          const assignments = await db.orm.public.TeacherSubject.where({
            subjectId: data.id,
          }).all();

          selectedTeacherIds = assignments.map((assignment) => assignment.teacherId);
        }

        relatedData = {
          teachers,
          selectedTeacherIds,
        };

        break;
      }
      case "class": {
        const ClassGrades = await db.orm.public.Grade.select("id", "level").all();
        const ClassTeacher = await db.orm.public.Teacher.select("id", "name", "surname").all();

        relatedData = {
          ClassGrades,
          ClassTeacher,
        };

        break;
      }
      case "teacher": {
        const TeacherSubject = await db.orm.public.Subject.select("id", "name").all();

        relatedData = {
          TeacherSubject,
        };

        break;
      }
      case "student": {
        const grades = await db.orm.public.Grade.select("id", "level").all();
        const classes = await db.orm.public.Class.select("id", "name", "capacity")
          .include("students")
          .all();

        relatedData = {
          grades,
          classes: serialize(classes),
        };

        break;
      }
      case "exam": {
        const examLessons = await db.orm.public.Lesson.where(
          role === "teacher"
            ? {
                teacherId: currentUserId,
              }
            : {},
        )
          .select("id", "name")
          .all();

        relatedData = { examLessons };

        break;
      }
      case "assignment": {
        const assignmentLessons = await db.orm.public.Lesson.where(
          role === "teacher"
            ? {
                teacherId: currentUserId,
              }
            : {},
        )
          .select("id", "name")
          .all();

        relatedData = { assignmentLessons };

        break;
      }
      case "result": {
        const students = await db.orm.public.Student.where((student) =>
          role === "teacher"
            ? student.class.some((classItem) => classItem.supervisorId.eq(currentUserId))
            : all(),
        )
          .select("id", "name", "surname")
          .all();

        const exams = await db.orm.public.Exams.where((exam) =>
          role === "teacher" && currentUserId
            ? exam.lesson.some((lesson) => lesson.teacherId.eq(currentUserId))
            : all(),
        )
          .select("id", "title")
          .all();

        const assignments = await db.orm.public.Assignment.where((assignment) =>
          role === "teacher" && currentUserId
            ? assignment.lesson.some((lesson) => lesson.teacherId.eq(currentUserId))
            : all(),
        )
          .select("id", "title")
          .all();
        relatedData = { students, exams, assignments };
        break;
      }
      case "event": {
        const classList = await db.orm.public.Class.select("id", "name").all();

        relatedData = { classList };

        break;
      }
      case "announcement": {
        const classList = await db.orm.public.Class.select("id", "name").all();

        relatedData = { classList };

        break;
      }

      default:
        break;
    }
  }

  return (
    <div>
      <FormModal table={table} type={type} data={data} id={id} relatedData={relatedData} />
    </div>
  );
};

export default FormContainer;
