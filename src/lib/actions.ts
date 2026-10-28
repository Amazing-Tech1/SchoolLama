"use server";

import { clerkClient } from "@clerk/nextjs/server";
// import { revalidatePath } from "next/cache";
import { db } from "./db";
import {
  AnnouncementSchema,
  AssignmentSchema,
  ClassSchema,
  EventSchema,
  ExamSchema,
  ParentSchema,
  ResultSchema,
  StudentSchema,
  SubjectSchema,
  TeacherSchema,
} from "./FormValidatorSchema";
import { Temporal } from "temporal-polyfill";
import { getCurrentAuth } from "./utils";

type currentState = {
  success: boolean;
  error: boolean;
  errorMessage?: string;
};

export async function createSubject(
  currentState: currentState,
  data: SubjectSchema,
): Promise<currentState> {
  try {
    const { name, teacher } = data;

    // Create the subject
    const subject = await db.orm.public.Subject.create({
      name,
    });

    for (const teacherId of teacher) {
      await db.orm.public.TeacherSubject.create({
        teacherId,
        subjectId: subject.id,
      });
    }

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating subject:", error);

    let errorMessage = "Failed to create subject. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function updateSubject(
  currentState: currentState,
  data: SubjectSchema,
): Promise<currentState> {
  try {
    const { id, name, teacher } = data;

    if (id === undefined) {
      return {
        success: false,
        error: true,
        errorMessage: "Subject not found!",
      };
    }

    await db.transaction(async (tx) => {
      await tx.orm.public.Subject.where({ id }).update({ name });

      // 2. Get the current teacher assignments
      const existingTeachers = await tx.orm.public.TeacherSubject.where({ subjectId: id }).all();

      const existingTeacherIds = new Set(existingTeachers.map((item) => item.teacherId));

      const selectedTeacherIds = new Set(teacher);

      // 3. Remove teachers that are no longer selected
      for (const item of existingTeachers) {
        if (!selectedTeacherIds.has(item.teacherId)) {
          await tx.orm.public.TeacherSubject.where({
            teacherId: item.teacherId,
            subjectId: id,
          }).delete();
        }
      }

      // 4. Add only newly selected teachers
      for (const teacherId of selectedTeacherIds) {
        if (!existingTeacherIds.has(teacherId)) {
          await tx.orm.public.TeacherSubject.create({
            teacherId,
            subjectId: id,
          });
        }
      }
    });

    // revalidatePath("/list/subject");

    return { success: true, error: false };
  } catch (error) {
    console.error("Error updating subject:", error);

    let errorMessage = "Failed to update subject. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function deleteSubject(
  currentState: currentState,
  formData: FormData,
): Promise<currentState> {
  try {
    const id = Number(formData.get("id"));

    if (!id || Number.isNaN(id)) {
      return { success: false, error: true, errorMessage: "Subject not found!" };
    }

    await db.orm.public.Subject.where({ id }).delete();

    return { success: true, error: false };
  } catch (error) {
    console.error("Error deleting subject:", error);

    let errorMessage = "Failed to delete subject. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}

//EXAM ACTIONS
export async function createExam(
  currentState: currentState,
  data: ExamSchema,
): Promise<currentState> {
  try {
    const { currentUserId, role } = await getCurrentAuth();

    if (role === "teacher") {
      const teacherLesson = await db.orm.public.Lesson.where({
        teacherId: currentUserId,
        id: data.lessonId,
      }).first();

      if (!teacherLesson) {
        return {
          success: false,
          error: true,
          errorMessage: "Unauthorized action!",
        };
      }
    } else if (role !== "admin") {
      return {
        success: false,
        error: true,
        errorMessage: "Unauthorized action!",
      };
    }

    await db.orm.public.Exams.create({
      title: data.title,

      startTime: Temporal.Instant.from(new Date(data.startTime).toISOString()),
      endTime: Temporal.Instant.from(new Date(data.endTime).toISOString()),
      lessonId: data.lessonId,
    });

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating exam:", error);

    return {
      success: false,
      error: true,
      errorMessage: "Failed to create exam.",
    };
  }
}
export async function updateExam(
  currentState: currentState,
  data: ExamSchema,
): Promise<currentState> {
  try {
    const { id } = data;

    if (!id) {
      return { success: false, error: true, errorMessage: "Exam not found!" };
    }
    const { currentUserId, role } = await getCurrentAuth();

    if (role === "teacher") {
      const teacherLesson = await db.orm.public.Lesson.where({
        teacherId: currentUserId,
        id: data.lessonId,
      }).first();

      if (!teacherLesson) {
        return {
          success: false,
          error: true,
          errorMessage: "Unauthorized action!",
        };
      }
    } else if (role !== "admin") {
      return {
        success: false,
        error: true,
        errorMessage: "Unauthorized action!",
      };
    }

    await db.orm.public.Exams.where({ id: data.id }).update({
      title: data.title,
      startTime: Temporal.Instant.from(new Date(data.startTime).toISOString()),
      endTime: Temporal.Instant.from(new Date(data.endTime).toISOString()),
      lessonId: data.lessonId,
    });

    return { success: true, error: false };
  } catch (error) {
    console.error("Error updating exam:", error);

    let errorMessage = "Failed to update exam. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function deleteExam(
  currentState: currentState,
  formData: FormData,
): Promise<currentState> {
  try {
    const id = Number(formData.get("id"));
    const { role, currentUserId } = await getCurrentAuth();

    if (!id || Number.isNaN(id)) {
      return {
        success: false,
        error: true,
        errorMessage: "Exam not found!",
      };
    }

    if (role !== "admin" && role !== "teacher") {
      return {
        success: false,
        error: true,
        errorMessage: "Unauthorized action!",
      };
    }

    let examQuery = db.orm.public.Exams.where((exam) => exam.id.eq(id));

    if (role === "teacher") {
      examQuery = examQuery.where((exam) =>
        exam.lesson.some((lesson) => lesson.teacherId.eq(currentUserId as string)),
      );
    }

    const deleted = await examQuery.delete();

    return { success: true, error: false };
  } catch (error) {
    console.error("Error deleting exam:", error);

    return {
      success: false,
      error: true,
      errorMessage:
        error instanceof Error ? error.message : "Failed to delete exam. Please try again.",
    };
  }
}

//ASSIGNMENT ACTIONS
export async function createAssignment(
  currentState: currentState,
  data: AssignmentSchema,
): Promise<currentState> {
  try {
    const { currentUserId, role } = await getCurrentAuth();

    if (role === "teacher") {
      const teacherLesson = await db.orm.public.Lesson.where({
        teacherId: currentUserId,
        id: data.lessonId,
      }).first();

      if (!teacherLesson) {
        return {
          success: false,
          error: true,
          errorMessage: "Unauthorized action!",
        };
      }
    } else if (role !== "admin") {
      return {
        success: false,
        error: true,
        errorMessage: "Unauthorized action!",
      };
    }

    await db.orm.public.Assignment.create({
      title: data.title,

      startTime: Temporal.Instant.from(new Date(data.startTime).toISOString()),
      dueTime: Temporal.Instant.from(new Date(data.dueTime).toISOString()),
      lessonId: data.lessonId,
    });

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating assignment:", error);

    return {
      success: false,
      error: true,
      errorMessage: "Failed to create assignment.",
    };
  }
}
export async function updateAssignment(
  currentState: currentState,
  data: AssignmentSchema,
): Promise<currentState> {
  try {
    const { id } = data;

    if (!id) {
      return { success: false, error: true, errorMessage: "Exam not found!" };
    }
    const { currentUserId, role } = await getCurrentAuth();

    if (role === "teacher") {
      const teacherLesson = await db.orm.public.Lesson.where({
        teacherId: currentUserId,
        id: data.lessonId,
      }).first();

      if (!teacherLesson) {
        return {
          success: false,
          error: true,
          errorMessage: "Unauthorized action!",
        };
      }
    } else if (role !== "admin") {
      return {
        success: false,
        error: true,
        errorMessage: "Unauthorized action!",
      };
    }

    await db.orm.public.Assignment.where({ id: data.id }).update({
      title: data.title,
      startTime: Temporal.Instant.from(new Date(data.startTime).toISOString()),
      dueTime: Temporal.Instant.from(new Date(data.dueTime).toISOString()),
      lessonId: data.lessonId,
    });

    return { success: true, error: false };
  } catch (error) {
    console.error("Error updating assignment:", error);

    let errorMessage = "Failed to update a. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function deleteAssignment(
  currentState: currentState,
  formData: FormData,
): Promise<currentState> {
  try {
    const id = Number(formData.get("id"));
    const { role, currentUserId } = await getCurrentAuth();

    if (!id || Number.isNaN(id)) {
      return {
        success: false,
        error: true,
        errorMessage: "Assignment not found!",
      };
    }

    if (role !== "admin" && role !== "teacher") {
      return {
        success: false,
        error: true,
        errorMessage: "Unauthorized action!",
      };
    }

    let examQuery = db.orm.public.Exams.where((exam) => exam.id.eq(id));

    if (role === "teacher") {
      examQuery = examQuery.where((exam) =>
        exam.lesson.some((lesson) => lesson.teacherId.eq(currentUserId as string)),
      );
    }

    const deleted = await examQuery.delete();

    return { success: true, error: false };
  } catch (error) {
    console.error("Error deleting assignment:", error);

    return {
      success: false,
      error: true,
      errorMessage:
        error instanceof Error ? error.message : "Failed to delete assignment. Please try again.",
    };
  }
}

//RESULT ACTIONS
export async function createResult(
  currentState: currentState,
  data: ResultSchema,
): Promise<currentState> {
  try {
    const { role, currentUserId } = await getCurrentAuth();
    await db.orm.public.Result.create({
      score: data.score,
      studentId: data.studentId,
      examId: data.examId || null,
      assignmentId: data.assignmentId || null,
    });

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating result:", error);
    return {
      success: false,
      error: true,
      errorMessage: error instanceof Error ? error.message : "Failed to create result.",
    };
  }
}
export async function updateResult(
  currentState: currentState,
  data: ResultSchema,
): Promise<currentState> {
  try {
    const { id } = data;

    if (!id) {
      return { success: false, error: true, errorMessage: "Exam not found!" };
    }
    await db.orm.public.Result.where({ id: data.id }).update({
      score: data.score,
      studentId: data.studentId,
      examId: data.examId || null,
      assignmentId: data.assignmentId || null,
    });

    return { success: true, error: false };
  } catch (error) {
    console.error("Error updating result:", error);
    return {
      success: false,
      error: true,
      errorMessage: error instanceof Error ? error.message : "Failed to update result.",
    };
  }
}

export async function deleteResult(
  currentState: currentState,
  formData: FormData,
): Promise<currentState> {
  try {
    const id = Number(formData.get("id"));

    if (!Number.isInteger(id) || id <= 0) {
      return {
        success: false,
        error: true,
        errorMessage: "Result not found!",
      };
    }

    await db.orm.public.Result.where((result) => result.id.eq(id)).delete();

    return { success: true, error: false };
  } catch (error) {
    console.error("Error deleting result:", error);
    return {
      success: false,
      error: true,
      errorMessage: error instanceof Error ? error.message : "Failed to delete result.",
    };
  }
}

//CLASS ACTIONS
export async function createClass(
  currentState: currentState,
  data: ClassSchema,
): Promise<currentState> {
  try {
    // Create the subject

    await db.orm.public.Class.create(data);

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating Class:", error);

    let errorMessage = "Failed to create Class. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function updateClass(
  currentState: currentState,
  data: ClassSchema,
): Promise<currentState> {
  try {
    const { id } = data;

    if (id === undefined) {
      return {
        success: false,
        error: true,
        errorMessage: "Subject not found!",
      };
    }

    await db.orm.public.Class.where({ id: data.id }).update(data);

    // revalidatePath("/list/subject");

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating Class:", error);

    let errorMessage = "Failed to update Class. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function deleteClass(
  currentState: currentState,
  formData: FormData,
): Promise<currentState> {
  try {
    const id = Number(formData.get("id"));

    if (!id || Number.isNaN(id)) {
      return {
        success: false,
        error: true,
        errorMessage: "Class not found!",
      };
    }

    await db.orm.public.Class.where({ id }).delete();

    return { success: true, error: false };
  } catch (error) {
    console.error(error);
    return { success: false, error: true };
  }
}

// TEACHER ACTIONS
export async function createTeacher(
  currentState: currentState,
  data: TeacherSchema,
): Promise<currentState> {
  try {
    const {
      username,
      password,
      name,
      surname,
      email,
      phone,
      address,
      bloodType,
      birthday,
      sex,
      img,
      subjects,
    } = data;

    // Create the teacher's Clerk account
    const clerk = await clerkClient();

    const user = await clerk.users.createUser({
      username,
      password,
      firstName: name,
      lastName: surname,
      //   ...(email ? { emailAddress: [email] } : {}),
      publicMetadata: {
        role: "teacher",
      },
    });

    // Create the teacher record
    await db.orm.public.Teacher.create({
      id: user.id,
      username,
      name,
      surname,
      email: email || null,
      phone: phone || null,
      address,
      bloodType: bloodType || null,
      birthday: birthday ? Temporal.Instant.from(`${birthday}T00:00:00Z`) : null,
      sex: sex || null,
      img: img || null,
    });

    // Assign subjects to the teacher
    for (const subjectId of subjects ?? []) {
      await db.orm.public.TeacherSubject.create({
        teacherId: user.id,
        subjectId: Number(subjectId),
      });
    }

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating teacher:", error);

    let errorMessage = "Failed to create teacher. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function updateTeacher(
  currentState: currentState,
  data: TeacherSchema,
): Promise<currentState> {
  try {
    const {
      id,
      username,
      password,
      name,
      surname,
      email,
      phone,
      address,
      bloodType,
      birthday,
      sex,
      img,
      subjects,
    } = data;

    if (!id) {
      throw new Error("Teacher ID is required");
    }

    // 1. Update the Clerk account
    const clerk = await clerkClient();

    await clerk.users.updateUser(id, {
      username,
      firstName: name,
      lastName: surname,
      ...(password ? { password } : {}),
    });

    // 2. Update the teacher's database record
    await db.orm.public.Teacher.where({ id }).update({
      username,
      name,
      surname,
      email: email || null,
      phone: phone || null,
      address,
      bloodType: bloodType || null,
      birthday: birthday ? Temporal.Instant.from(`${birthday}T00:00:00Z`) : null,
      sex: sex || null,
      img: img || null,
    });

    // 3. Synchronize the teacher's subject assignments
    const existingSubjects = await db.orm.public.TeacherSubject.where({ teacherId: id }).all();

    const existingSubjectIds = existingSubjects.map((item) => item.subjectId);

    const selectedSubjectIds = (subjects ?? []).map(Number);

    // Remove assignments that are no longer selected
    for (const subjectId of existingSubjectIds) {
      if (!selectedSubjectIds.includes(subjectId)) {
        await db.orm.public.TeacherSubject.where({
          teacherId: id,
          subjectId,
        }).delete();
      }
    }

    // Add only newly selected subjects
    for (const subjectId of selectedSubjectIds) {
      if (!existingSubjectIds.includes(subjectId)) {
        await db.orm.public.TeacherSubject.create({
          teacherId: id,
          subjectId,
        });
      }
    }
    // revalidatePath("/list/teachers");

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating teacher:", error);

    let errorMessage = "Failed to create teacher. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function deleteTeacher(
  currentState: currentState,
  formData: FormData,
): Promise<currentState> {
  try {
    const id = formData.get("id");

    if (typeof id !== "string" || !id) {
      return {
        success: false,
        error: true,
        errorMessage: "Teacher not found!",
      };
    }

    // Check whether the teacher supervises any classes
    const classes = await db.orm.public.Class.where({ supervisorId: id }).all();

    if (classes.length > 0) {
      return {
        success: false,
        error: true,
        errorMessage: "Reassign this teacher's classes before deleting the teacher.!",
      };
    }

    // Fetch the teacher's subject assignments
    const assignments = await db.orm.public.TeacherSubject.where({ teacherId: id }).all();

    // Delete each subject assignment
    for (const assignment of assignments) {
      await db.orm.public.TeacherSubject.where({
        teacherId: id,
        subjectId: assignment.subjectId,
      }).delete();
    }

    // Delete the teacher's database record
    await db.orm.public.Teacher.where({ id }).delete();

    // Delete the teacher's Clerk account
    const clerk = await clerkClient();
    await clerk.users.deleteUser(id);

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating teacher:", error);

    let errorMessage = "Failed to create teacher. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}

//STUDENT ACTION
export async function createStudent(
  currentState: currentState,
  data: StudentSchema,
): Promise<currentState> {
  try {
    const classItem = await db.orm.public.Class.where({ id: data.classId })
      .include("students")
      .all();
    if (classItem[0] && classItem[0].capacity === classItem[0].students.length) {
      return { success: false, error: true, errorMessage: "Class limit exceeded!" };
    }
    const {
      username,
      password,
      name,
      surname,
      email,
      phone,
      address,
      bloodType,
      birthday,
      sex,
      img,
      gradeId,
      classId,
      parentId,
    } = data;

    // Create the teacher's Clerk account
    const clerk = await clerkClient();

    const user = await clerk.users.createUser({
      username,
      password,
      firstName: name,
      lastName: surname,
      //   ...(email ? { emailAddress: [email] } : {}),
      publicMetadata: {
        role: "student",
      },
    });

    // Create the teacher record
    await db.orm.public.Student.create({
      id: user.id,
      username,
      name,
      surname,
      email: email || null,
      phone: phone || null,
      address,
      bloodType: bloodType || null,
      birthday: birthday ? Temporal.Instant.from(`${birthday}T00:00:00Z`) : null,
      sex: sex || null,
      img: img || null,
      gradeId: gradeId,
      classId: classId,
      parentId: parentId,
    });

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating teacher:", error);

    let errorMessage = "Failed to create teacher. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function updateStudent(
  currentState: currentState,
  data: StudentSchema,
): Promise<currentState> {
  try {
    const classItem = await db.orm.public.Class.where({ id: data.classId })
      .include("students")
      .all();
    if (classItem[0] && classItem[0].capacity === classItem[0].students.length) {
      return { success: false, error: true, errorMessage: "Class limit exceeded!" };
    }
    const {
      id,
      username,
      password,
      name,
      surname,
      email,
      phone,
      address,
      bloodType,
      birthday,
      sex,
      img,
      gradeId,
      classId,
      parentId,
    } = data;

    if (!id) {
      return {
        success: false,
        error: true,
        errorMessage: "Student not found!",
      };
    }

    // 1. Update the Clerk account
    const clerk = await clerkClient();

    await clerk.users.updateUser(id, {
      username,
      firstName: name,
      lastName: surname,
      ...(password ? { password } : {}),
    });

    // 2. Update the teacher's database record
    await db.orm.public.Student.where({ id }).update({
      username,
      name,
      surname,
      email: email || null,
      phone: phone || null,
      address,
      bloodType: bloodType || null,
      birthday: birthday ? Temporal.Instant.from(`${birthday}T00:00:00Z`) : null,
      sex: sex || null,
      img: img || null,
      gradeId: gradeId,
      classId: classId,
      parentId: parentId,
    });

    // revalidatePath("/list/students");

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating teacher:", error);

    let errorMessage = "Failed to create teacher. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function deleteStudent(
  currentState: currentState,
  formData: FormData,
): Promise<currentState> {
  try {
    const id = formData.get("id");

    if (typeof id !== "string" || !id) {
      return {
        success: false,
        error: true,
        errorMessage: "Student not found!",
      };
    }

    // Delete the student's database record
    await db.orm.public.Student.where({ id }).delete();

    // Delete the student's Clerk account
    const clerk = await clerkClient();
    await clerk.users.deleteUser(id);

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating student:", error);

    let errorMessage = "Failed to create student. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}

//EVENT ACTIONS
export async function createEvent(
  currentState: currentState,
  data: EventSchema,
): Promise<currentState> {
  try {
    await db.orm.public.Events.create({
      title: data.title,
      description: data.description,
      startDate: Temporal.Instant.from(new Date(data.startDate).toISOString()),
      endDate: Temporal.Instant.from(new Date(data.endDate).toISOString()),
      classId: data.classId || null,
    });

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating event:", error);

    return {
      success: false,
      error: true,
      errorMessage: "Failed to create event",
    };
  }
}
export async function updateEvent(
  currentState: currentState,
  data: EventSchema,
): Promise<currentState> {
  try {
    const { id } = data;

    if (!id) {
      return { success: false, error: true, errorMessage: "Event not found!" };
    }
    await db.orm.public.Events.where({ id }).update({
      title: data.title,
      description: data.description,
      startDate: Temporal.Instant.from(new Date(data.startDate).toISOString()),
      endDate: Temporal.Instant.from(new Date(data.endDate).toISOString()),
      classId: data.classId || null,
    });

    return { success: true, error: false };
  } catch (error) {
    console.error("Error updating event:", error);

    let errorMessage = "Failed to update event. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function deleteEvent(
  currentState: currentState,
  formData: FormData,
): Promise<currentState> {
  try {
    const id = Number(formData.get("id"));

    if (!id || Number.isNaN(id)) {
      return {
        success: false,
        error: true,
        errorMessage: "Event not found!",
      };
    }

    await db.orm.public.Events.where({ id }).delete();

    return { success: true, error: false };
  } catch (error) {
    console.error("Error deleting event:", error);

    return {
      success: false,
      error: true,
      errorMessage:
        error instanceof Error ? error.message : "Failed to delete event. Please try again.",
    };
  }
}

//ANNOUNCEMENT ACTIONS
export async function createAnnouncement(
  currentState: currentState,
  data: AnnouncementSchema,
): Promise<currentState> {
  try {
    await db.orm.public.Announcements.create({
      title: data.title,
      description: data.description,
      date: Temporal.Instant.from(new Date(data.date).toISOString()),
      classId: data.classId || null,
    });

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating announcement:", error);

    return {
      success: false,
      error: true,
      errorMessage: "Failed to create announcement",
    };
  }
}
export async function updateAnnouncement(
  currentState: currentState,
  data: AnnouncementSchema,
): Promise<currentState> {
  try {
    const { id } = data;

    if (!id) {
      return { success: false, error: true, errorMessage: "Event not found!" };
    }
    await db.orm.public.Announcements.where({ id }).update({
      title: data.title,
      description: data.description,
      date: Temporal.Instant.from(new Date(data.date).toISOString()),
      classId: data.classId || null,
    });

    return { success: true, error: false };
  } catch (error) {
    console.error("Error updating announcement:", error);

    let errorMessage = "Failed to update announcement. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function deleteAnnouncement(
  currentState: currentState,
  formData: FormData,
): Promise<currentState> {
  try {
    const id = Number(formData.get("id"));

    if (!id || Number.isNaN(id)) {
      return {
        success: false,
        error: true,
        errorMessage: "Announcement not found!",
      };
    }

    await db.orm.public.Announcements.where({ id }).delete();

    return { success: true, error: false };
  } catch (error) {
    console.error("Error deleting announcement:", error);

    return {
      success: false,
      error: true,
      errorMessage:
        error instanceof Error ? error.message : "Failed to delete announcement. Please try again.",
    };
  }
}

//STUDENT ACTION

export async function createParent(
  currentState: currentState,
  data: ParentSchema,
): Promise<currentState> {
  try {
    const { username, password, name, surname, email, phone, address, img } = data;

    // Create the teacher's Clerk account
    const clerk = await clerkClient();

    const user = await clerk.users.createUser({
      username,
      password,
      firstName: name,
      lastName: surname,
      //   ...(email ? { emailAddress: [email] } : {}),
      publicMetadata: {
        role: "parent",
      },
    });

    // Create the teacher record
    await db.orm.public.Parent.create({
      id: user.id,
      username,
      name,
      surname,
      email: email || null,
      phone: phone,
      address,
      img: img || null,
    });

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating parent:", error);

    let errorMessage = "Failed to create p. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function updateParent(
  currentState: currentState,
  data: ParentSchema,
): Promise<currentState> {
  try {
    const { id, username, password, name, surname, email, phone, address, img } = data;

    if (!id) {
      return {
        success: false,
        error: true,
        errorMessage: "Student not found!",
      };
    }

    // 1. Update the Clerk account
    const clerk = await clerkClient();

    await clerk.users.updateUser(id, {
      username,
      firstName: name,
      lastName: surname,
      ...(password ? { password } : {}),
    });

    // 2. Update the teacher's database record
    await db.orm.public.Parent.where({ id }).update({
      username,
      name,
      surname,
      email: email || null,
      phone: phone,
      address,
      img: img || null,
    });

    // revalidatePath("/list/students");

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating parent:", error);

    let errorMessage = "Failed to create parent. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
export async function deleteParent(
  currentState: currentState,
  formData: FormData,
): Promise<currentState> {
  try {
    const id = formData.get("id");

    if (typeof id !== "string" || !id) {
      return {
        success: false,
        error: true,
        errorMessage: "Parent not found!",
      };
    }

    // Delete the student's database record
    await db.orm.public.Parent.where({ id }).delete();

    // Delete the student's Clerk account
    const clerk = await clerkClient();
    await clerk.users.deleteUser(id);

    return { success: true, error: false };
  } catch (error) {
    console.error("Error creating parent:", error);

    let errorMessage = "Failed to create parent. Please try again.";

    if (error instanceof Error) {
      errorMessage = error.message;
    }

    return {
      success: false,
      error: true,
      errorMessage,
    };
  }
}
