import Announcements from "@/components/Announcements";
import BigCalenderContainer from "@/components/BigCalenderContainer";
import EventCalendar from "@/components/EventCalendar";
import { db } from "@/lib/db";
import { getCurrentAuth } from "@/lib/utils";

const StudentPage = async () => {
  const { currentUserId } = await getCurrentAuth();
  const student = await db.orm.public.Student.where((student) =>
    student.id.eq(currentUserId as string),
  )
    .include("class")
    .all();

  console.log(student);
  const classItem = student[0];

  return (
    <div className="p-4 flex gap-4 flex-col xl:flex-row">
      {/* LEFT */}
      <div className="w-full xl:w-2/3">
        <div className="h-full bg-white p-4 rounded-md">
          <h1 className="text-xl font-semibold">Schedule</h1>

          {classItem ? (
            <BigCalenderContainer type="classId" id={classItem.classId} />
          ) : (
            <p>Student record not found.</p>
          )}
        </div>
      </div>

      {/* RIGHT */}
      <div className="w-full xl:w-1/3 flex flex-col gap-8">
        <EventCalendar />
        <Announcements />
      </div>
    </div>
  );
};

export default StudentPage;
