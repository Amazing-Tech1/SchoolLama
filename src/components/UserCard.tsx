import { db } from "@/lib/db";
import Image from "next/image";

const UserCard = async ({ type }: { type: "admin" | "teacher" | "student" | "parent" }) => {
  let data = 0;

  switch (type) {
    case "admin":
      data = (await db.orm.public.Admin.all()).length;
      break;

    case "teacher":
      data = (await db.orm.public.Teacher.all()).length;
      break;

    case "student":
      data = (await db.orm.public.Student.all()).length;
      break;

    case "parent":
      data = (await db.orm.public.Parent.all()).length;
      break;
  }

  return (
    <div className="rounded-2xl odd:bg-lamaPurple even:bg-lamaYellow p-4 flex-1 min-w-[130px]">
      <div className="flex justify-between items-center">
        <span className="text-[10px] bg-white px-2 py-1 rounded-full text-green-600">2026/27</span>
        <Image src="/more.png" alt="" width={20} height={20} />
      </div>

      <h1 className="text-2xl font-semibold my-4">{data.toLocaleString()}</h1>
      <h2 className="capitalize text-sm font-medium text-gray-500">{type}s</h2>
    </div>
  );
};
export default UserCard;
