import Image from "next/image";
import CountChart from "./CountChart";
import { db } from "@/lib/db";

const CountChartContainer = async () => {
  const students = await db.orm.public.Student.all();

  const totalStudents = students.length;

  const boys = students.filter((student) => student.sex === "MALE").length;

  const girls = students.filter((student) => student.sex === "FEMALE").length;

  const boysPercentage = totalStudents > 0 ? Math.round((boys / totalStudents) * 100) : 0;

  const girlsPercentage = totalStudents > 0 ? Math.round((girls / totalStudents) * 100) : 0;

  return (
    <div className="bg-white rounded-xl w-full h-full p-4">
      {/* TITLE */}
      <div className="flex justify-between items-center">
        <h1 className="text-lg font-semibold">Students</h1>
        <Image src="/moreDark.png" alt="" width={20} height={20} />
      </div>

      <CountChart boys={boys} girls={girls} />

      {/* BOTTOM */}
      <div className="flex justify-center gap-16">
        <div className="flex flex-col gap-1">
          <div className="w-5 h-5 bg-lamaSky rounded-full" />
          <h1 className="font-bold">{boys.toLocaleString()}</h1>
          <h2 className="text-xs text-gray-500">Boys ({boysPercentage}%)</h2>
        </div>

        <div className="flex flex-col gap-1">
          <div className="w-5 h-5 bg-lamaYellow rounded-full" />
          <h1 className="font-bold">{girls.toLocaleString()}</h1>
          <h2 className="text-xs text-gray-500">Girls ({girlsPercentage}%)</h2>
        </div>
      </div>
    </div>
  );
};

export default CountChartContainer;
