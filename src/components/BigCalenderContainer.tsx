import { db } from "@/lib/db";
import BigCalendar from "./BigCalender";
import { adjustScheduleToCurrentWeek } from "@/lib/utils";

type Props = {
  type: "teacherId" | "classId";
  id: string | number;
};

const BigCalenderContainer = async ({ type, id }: Props) => {
  const lessons =
    type === "teacherId"
      ? await db.orm.public.Lesson.where((lesson) => lesson.teacherId.eq(String(id)))
          .include("subject")
          .include("class")
          .all()
      : await db.orm.public.Lesson.where((lesson) => lesson.classId.eq(Number(id)))
          .include("subject")
          .include("class")
          .all();

  const data = lessons.map((lesson) => ({
    title: lesson.name,
    start: new Date(Number(lesson.startTime.epochMilliseconds)),
    end: new Date(Number(lesson.endTime.epochMilliseconds)),
  }));

  const schedule = adjustScheduleToCurrentWeek(data);

  return <BigCalendar data={schedule} />;
};

export default BigCalenderContainer;
