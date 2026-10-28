import Image from "next/image";
import AttendanceChart from "./AttendanceChart";
import { db } from "@/lib/db";
import { Temporal } from "temporal-polyfill";
import { and } from "@prisma/orm-postgres/orm-client";

const AttendanceChartContainer = async () => {
  const today = new Date();

  // Get Monday at midnight
  const dayOfWeek = today.getDay();
  const daysSinceMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;

  const monday = new Date(today);
  monday.setDate(today.getDate() - daysSinceMonday);
  monday.setHours(0, 0, 0, 0);

  // Get next Monday at midnight
  const nextMonday = new Date(monday);
  nextMonday.setDate(monday.getDate() + 7);

  // Fetch this week's attendance records
  const mondayInstant = Temporal.Instant.fromEpochMilliseconds(monday.getTime());

  const nextMondayInstant = Temporal.Instant.fromEpochMilliseconds(nextMonday.getTime());

  const attendanceRecords = await db.orm.public.Attendance.where((attendance) =>
    and(attendance.date.gte(mondayInstant), attendance.date.lt(nextMondayInstant)),
  ).all();

  const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  const data = days.map((name, index) => {
    const date = new Date(monday);
    date.setDate(monday.getDate() + index);

    const dailyRecords = attendanceRecords.filter((record) => {
      const recordDate = new Date(record.date.toString());

      return recordDate.toDateString() === date.toDateString();
    });

    return {
      name,
      present: dailyRecords.filter((record) => record.present).length,
      absent: dailyRecords.filter((record) => !record.present).length,
    };
  });

  return (
    <div className="bg-white rounded-lg p-4 h-full">
      <div className="flex justify-between items-center">
        <h1 className="text-lg font-semibold">Attendance</h1>
        <Image src="/moreDark.png" alt="" width={20} height={20} />
      </div>

      <AttendanceChart data={data} />
    </div>
  );
};

export default AttendanceChartContainer;
