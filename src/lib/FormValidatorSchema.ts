import z from "zod";

export const subjectSchema = z.object({
  id: z.coerce.number().optional(),
  name: z.string().min(1, { message: "Subject name is required!" }),
  teacher: z.array(z.string()),
});

export type SubjectSchema = z.infer<typeof subjectSchema>;

export const classSchema = z.object({
  id: z.coerce.number().optional(),
  name: z.string().min(1, { message: "Class name is required!" }),
  capacity: z.coerce.number().min(1, { message: "Capacity field is required!" }),
  gradeId: z.coerce.number().min(1, { message: "Grade name is required!" }),
  supervisorId: z.coerce.string().optional(),
});

export const examSchema = z.object({
  id: z.coerce.number().optional(),
  title: z.string().min(1, { message: "Title name is required!" }),
  startTime: z.string().min(1, { message: "StartTime is required!" }),
  endTime: z.string().min(1, { message: "EndTime is required!" }),
  lessonId: z.coerce.number().min(1, { message: "lessonId field is required!" }),
});

export type ExamSchema = z.infer<typeof examSchema>;

export const assignmentSchema = z.object({
  id: z.coerce.number().optional(),
  title: z.string().min(1, { message: "Title name is required!" }),
  startTime: z.string().min(1, { message: "StartTime is required!" }),
  dueTime: z.string().min(1, { message: "DueTime is required!" }),
  lessonId: z.coerce.number().min(1, { message: "lessonId field is required!" }),
});

export type AssignmentSchema = z.infer<typeof assignmentSchema>;

export const resultSchema = z
  .object({
    id: z.coerce.number().optional(),

    score: z.coerce.number().int().min(0, { message: "Score must be a nonnegative whole number!" }),

    studentId: z.string().min(1, { message: "Student is required!" }),

    examId: z.preprocess(
      (value) => (value === "" || value == null ? undefined : Number(value)),
      z.number().int().positive().optional(),
    ),

    assignmentId: z.preprocess(
      (value) => (value === "" || value == null ? undefined : Number(value)),
      z.number().int().positive().optional(),
    ),
  })
  .refine(
    (data) =>
      (data.examId !== undefined && data.assignmentId === undefined) ||
      (data.examId === undefined && data.assignmentId !== undefined),
    {
      message: "Select either an exam or an assignment, but not both!",
      path: ["examId"],
    },
  );

export type ResultSchema = z.infer<typeof resultSchema>;

export type ClassSchema = z.infer<typeof classSchema>;

export const teacherSchema = z.object({
  id: z.string().optional(),
  username: z
    .string()
    .min(3, { message: "Username must be at least 3 characters long!" })
    .max(20, { message: "Username must be at most 20 characters long!" }),
  email: z.string().email({ message: "Invalid email address!" }).optional().or(z.literal("")),
  password: z
    .string()
    .min(8, { message: "Password must be at least 8 characters long!" })
    .optional()
    .or(z.literal("")),
  name: z.string().min(1, { message: " Name is required!" }),
  surname: z.string().min(1, { message: "Surname is required!" }),
  phone: z.string().min(1, { message: "Phone is required!" }).optional(),
  address: z.string().min(1, { message: "Address is required!" }),
  bloodType: z.string().min(1, { message: "Blood Type is required!" }),
  birthday: z.string().min(1, { message: "Birthday is required!" }),
  sex: z.enum(["MALE", "FEMALE"], { message: "Sex is required!" }),
  img: z.string().optional(),
  subjects: z.array(z.string()).optional(),
});

export type TeacherSchema = z.infer<typeof teacherSchema>;

export const studentSchema = z.object({
  id: z.string().optional(),
  username: z
    .string()
    .min(3, { message: "Username must be at least 3 characters long!" })
    .max(20, { message: "Username must be at most 20 characters long!" }),
  email: z.string().email({ message: "Invalid email address!" }).optional().or(z.literal("")),
  password: z
    .string()
    .min(8, { message: "Password must be at least 8 characters long!" })
    .optional()
    .or(z.literal("")),
  name: z.string().min(1, { message: " Name is required!" }),
  surname: z.string().min(1, { message: "Surname is required!" }),
  phone: z.string().min(1, { message: "Phone is required!" }).optional(),
  address: z.string().min(1, { message: "Address is required!" }),
  bloodType: z.string().min(1, { message: "Blood Type is required!" }),
  birthday: z.string().min(1, { message: "Birthday is required!" }),
  sex: z.enum(["MALE", "FEMALE"], { message: "Sex is required!" }),
  img: z.string().optional(),
  gradeId: z.coerce.number().min(1, { message: "Grade is required!" }),
  classId: z.coerce.number().min(1, { message: "Class is required!" }),
  parentId: z.string().min(1, { message: "Parent Id is required!" }),
});

export type StudentSchema = z.infer<typeof studentSchema>;

export const eventSchema = z.object({
  id: z.coerce.number().optional(),
  title: z.string().min(1, { message: "Title name is required!" }),
  description: z.string().min(1, { message: "Description is required!" }),
  startDate: z.string().min(1, { message: "StartDate is required!" }),
  endDate: z.string().min(1, { message: "EndDate is required!" }),
  classId: z.coerce
    .number()
    .min(1, { message: "lessonId field is required!" })
    .optional()
    .or(z.literal("")),
});

export type EventSchema = z.infer<typeof eventSchema>;

export const announcementSchema = z.object({
  id: z.coerce.number().optional(),
  title: z.string().min(1, { message: "Title name is required!" }),
  description: z.string().min(1, { message: "Description is required!" }),
  date: z.string().min(1, { message: "StartDate is required!" }),
  classId: z.coerce
    .number()
    .min(1, { message: "lessonId field is required!" })
    .optional()
    .or(z.literal("")),
});

export type AnnouncementSchema = z.infer<typeof announcementSchema>;

export const parentSchema = z.object({
  id: z.string().optional(),
  username: z
    .string()
    .min(3, { message: "Username must be at least 3 characters long!" })
    .max(20, { message: "Username must be at most 20 characters long!" }),
  email: z.string().email({ message: "Invalid email address!" }).optional().or(z.literal("")),
  password: z
    .string()
    .min(8, { message: "Password must be at least 8 characters long!" })
    .optional()
    .or(z.literal("")),
  name: z.string().min(1, { message: " Name is required!" }),
  surname: z.string().min(1, { message: "Surname is required!" }),
  phone: z.string().min(1, { message: "Phone is required!" }),
  address: z.string().min(1, { message: "Address is required!" }),
  img: z.string().optional(),
});

export type ParentSchema = z.infer<typeof parentSchema>;
