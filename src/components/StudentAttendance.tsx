import { db } from "@/lib/db";
import { and } from "@prisma/orm-postgres/orm-client";
import { Temporal } from "temporal-polyfill";

const StudentAttendance = async ({ id }: { id: string }) => {
  const startOfYear = Temporal.Instant.from(`${new Date().getFullYear()}-01-01T00:00:00Z`);

  const attendance = await db.orm.public.Attendance.where((attendance) =>
    and(attendance.studentId.eq(id), attendance.date.gte(startOfYear)),
  ).all();

  const totalDays = attendance.length;
  const presentDays = attendance.filter((day) => day.present).length;
  const percentage = totalDays > 0 ? Math.round((presentDays / totalDays) * 100) : 0;

  console.log(percentage);
  return (
    <div className="">
      <h1 className="text-xl font-semibold">{percentage}</h1>
      <span className="text-sm text-gray-400">Attendance</span>
    </div>
  );
};

export default StudentAttendance;
