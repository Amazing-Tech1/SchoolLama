import "dotenv/config";
import "temporal-polyfill/full/global";
import { Temporal } from "temporal-polyfill";
import postgres from "@prisma/orm-postgres/runtime";

import type { Contract } from "./contract";
import contractJson from "./contract.json" with { type: "json" };

const db = postgres<Contract>({
  contractJson,
  url: process.env["DATABASE_URL"]!,
});

// =========================
// TIME HELPERS
// =========================

function now(): Temporal.Instant {
  return Temporal.Now.instant();
}

function todayAt(hour: number, minute = 0): Temporal.Instant {
  const date = new Date();

  date.setHours(hour, minute, 0, 0);

  return Temporal.Instant.from(date.toISOString());
}

function tomorrow(): Temporal.Instant {
  const date = new Date();

  date.setDate(date.getDate() + 1);

  return Temporal.Instant.from(date.toISOString());
}

async function main() {
  // =========================
  // CLEAR EXISTING DATA
  // =========================

  await db.orm.public.Attendance.where({}).deleteAll();
  await db.orm.public.Result.where({}).deleteAll();

  await db.orm.public.Exams.where({}).deleteAll();
  await db.orm.public.Assignment.where({}).deleteAll();
  await db.orm.public.Lesson.where({}).deleteAll();

  await db.orm.public.StudentSubject.where({}).deleteAll();
  await db.orm.public.TeacherSubject.where({}).deleteAll();

  await db.orm.public.Events.where({}).deleteAll();
  await db.orm.public.Announcements.where({}).deleteAll();

  await db.orm.public.Student.where({}).deleteAll();
  await db.orm.public.Class.where({}).deleteAll();

  await db.orm.public.Subject.where({}).deleteAll();

  await db.orm.public.Teacher.where({}).deleteAll();
  await db.orm.public.Parent.where({}).deleteAll();
  await db.orm.public.Grade.where({}).deleteAll();
  await db.orm.public.Admin.where({}).deleteAll();

  // =========================
  // ADMIN
  // =========================

  await db.orm.public.Admin.create({
    id: "admin1",
    username: "admin1",
  });

  await db.orm.public.Admin.create({
    id: "admin2",
    username: "admin2",
  });

  // =========================
  // GRADE
  // =========================

  const grades = [];

  for (let i = 1; i <= 6; i++) {
    const grade = await db.orm.public.Grade.create({
      level: i,
    });

    grades.push(grade);
  }

  // =========================
  // TEACHER
  // =========================

  const teachers = [];

  for (let i = 1; i <= 15; i++) {
    const teacher = await db.orm.public.Teacher.create({
      id: `teacher${i}`,
      username: `teacher${i}`,
      name: `TName${i}`,
      surname: `TSurname${i}`,
      email: `teacher${i}@example.com`,
      phone: `080000000${i}`,
      address: `Address${i}`,
      img: null,
    });

    teachers.push(teacher);
  }

  // =========================
  // CLASS
  // =========================

  const classes = [];

  for (let i = 1; i <= 6; i++) {
    const classItem = await db.orm.public.Class.create({
      name: `${i}A`,
      capacity: Math.floor(Math.random() * 6) + 15,
      supervisorId: `teacher${i}`,
      gradeId: grades[i - 1].id,
    });

    classes.push(classItem);
  }

  // =========================
  // SUBJECT
  // =========================

  const subjectData = [
    "Mathematics",
    "Science",
    "English",
    "History",
    "Geography",
    "Physics",
    "Chemistry",
    "Biology",
    "Computer Science",
    "Art",
  ];

  const subjects = [];

  for (const name of subjectData) {
    const subject = await db.orm.public.Subject.create({
      name,
    });

    subjects.push(subject);
  }

  // =========================
  // TEACHER ↔ SUBJECT
  // =========================
  // Each subject gets 2 teachers.
  // This gives us a real teachers[] relationship.

  for (let i = 0; i < subjects.length; i++) {
    const subject = subjects[i];

    const teacher1 = teachers[i % teachers.length];
    const teacher2 = teachers[(i + 1) % teachers.length];

    await db.orm.public.TeacherSubject.create({
      teacherId: teacher1.id,
      subjectId: subject.id,
    });

    if (teacher1.id !== teacher2.id) {
      await db.orm.public.TeacherSubject.create({
        teacherId: teacher2.id,
        subjectId: subject.id,
      });
    }
  }

  // =========================
  // PARENT
  // =========================

  for (let i = 1; i <= 25; i++) {
    await db.orm.public.Parent.create({
      id: `parentId${i}`,
      username: `parentId${i}`,
      name: `PName ${i}`,
      surname: `PSurname ${i}`,
      email: `parent${i}@example.com`,
      phone: `081000000${i}`,
      address: `Address${i}`,
    });
  }

  // =========================
  // STUDENT
  // =========================

  const students = [];

  for (let i = 1; i <= 50; i++) {
    const gradeId = grades[(i - 1) % grades.length].id;
    const classId = classes[(i - 1) % classes.length].id;
    const parentNumber = Math.ceil(i / 2);

    const student = await db.orm.public.Student.create({
      id: `student${i}`,
      username: `student${i}`,
      name: `SName${i}`,
      surname: `SSurname${i}`,
      email: `student${i}@example.com`,
      phone: `082000000${i}`,
      address: `Address${i}`,
      bloodType: "O-",
      sex: i % 2 === 0 ? "MALE" : "FEMALE",
      parentId: `parentId${parentNumber}`,
      gradeId,
      classId,
    });

    students.push(student);
  }

  // =========================
  // STUDENT ↔ SUBJECT
  // =========================
  // Each student gets 5 subjects.

  for (let i = 0; i < students.length; i++) {
    const student = students[i];

    for (let j = 0; j < 5; j++) {
      const subject = subjects[(i + j) % subjects.length];

      await db.orm.public.StudentSubject.create({
        studentId: student.id,
        subjectId: subject.id,
      });
    }
  }

  // =========================
  // LESSON
  // =========================

  const lessons = [];

  const days = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY"] as const;

  for (let i = 1; i <= 30; i++) {
    const subject = subjects[(i - 1) % subjects.length];

    /*
     * Use one of the teachers assigned to this subject.
     *
     * Since each subject has two teachers:
     * teacher1 = i % 15
     * teacher2 = (i + 1) % 15
     */
    const teacherIndex = (i - 1) % teachers.length;
    const teacher = teachers[teacherIndex];

    const day = days[(i - 1) % days.length];

    const lesson = await db.orm.public.Lesson.create({
      name: `Lesson${i}`,
      day,
      startTime: todayAt(8 + (i % 5)),
      endTime: todayAt(9 + (i % 5)),
      subjectId: subject.id,
      classId: classes[(i - 1) % classes.length].id,
      teacherId: teacher.id,
    });

    lessons.push(lesson);
  }

  // =========================
  // EXAMS
  // =========================

  const exams = [];

  for (let i = 1; i <= 10; i++) {
    const exam = await db.orm.public.Exams.create({
      title: `Exam ${i}`,
      startTime: todayAt(10 + (i % 3)),
      endTime: todayAt(11 + (i % 3)),
      lessonId: lessons[(i - 1) % lessons.length].id,
    });

    exams.push(exam);
  }

  // =========================
  // ASSIGNMENTS
  // =========================

  const assignments = [];

  for (let i = 1; i <= 10; i++) {
    const assignment = await db.orm.public.Assignment.create({
      title: `Assignment ${i}`,
      startTime: todayAt(12),
      dueTime: tomorrow(),
      lessonId: lessons[(i - 1) % lessons.length].id,
    });

    assignments.push(assignment);
  }

  // =========================
  // RESULTS
  // =========================

  for (let i = 1; i <= 10; i++) {
    await db.orm.public.Result.create({
      score: Math.floor(Math.random() * 31) + 70,
      studentId: `student${i}`,
      ...(i <= 5 ? { examId: exams[i - 1].id } : { assignmentId: assignments[i - 6].id }),
    });
  }

  // =========================
  // ATTENDANCE
  // =========================

  for (let i = 1; i <= 20; i++) {
    await db.orm.public.Attendance.create({
      date: now(),
      present: i % 5 !== 0,
      studentId: `student${((i - 1) % 10) + 1}`,
      lessonId: lessons[(i - 1) % lessons.length].id,
    });
  }

  // =========================
  // EVENTS
  // =========================

  for (let i = 1; i <= 5; i++) {
    await db.orm.public.Events.create({
      title: `Event ${i}`,
      description: `Description for Event ${i}`,
      startDate: todayAt(14 + i),
      endDate: todayAt(15 + i),
      classId: classes[(i - 1) % classes.length].id,
    });
  }

  // =========================
  // ANNOUNCEMENTS
  // =========================

  for (let i = 1; i <= 5; i++) {
    await db.orm.public.Announcements.create({
      title: `Announcement ${i}`,
      description: `Description for Announcement ${i}`,
      date: now(),
      classId: classes[(i - 1) % classes.length].id,
    });
  }

  console.log("Seeding completed successfully.");
}

main()
  .catch((error) => {
    console.error("Seeding failed:", error);
    process.exit(1);
  })
  .finally(async () => {
    await db.close();
  });
