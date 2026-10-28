import { auth } from "@clerk/nextjs/server";
// import { startOfWeek } from "temporal-polyfill/fns/ZonedDateTime";

export async function getCurrentAuth() {
  const { sessionClaims, userId } = await auth();
  const metadata = sessionClaims?.metadata as { role?: string } | undefined;

  console.log(userId);
  return { role: metadata?.role, currentUserId: userId };
}

export function currentWorkWeek() {
  const today = new Date();
  const dayOfWeek = today.getDay();
  const daysFromMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;

  const startOfWeek = new Date(today);
  startOfWeek.setDate(today.getDate() - daysFromMonday);
  startOfWeek.setHours(0, 0, 0, 0);

  // const endOfWeek = new Date(startOfWeek);
  // endOfWeek.setDate(startOfWeek.getDate() + 4);
  // endOfWeek.setHours(23, 59, 59, 999);

  return startOfWeek;
}

type ScheduleLesson = {
  title: string;
  start: Date;
  end: Date;
};

export function adjustScheduleToCurrentWeek(lessons: ScheduleLesson[]) {
  const startOfWeek = currentWorkWeek();

  return lessons.map((lesson) => {
    const dayOfWeek = lesson.start.getDay();
    const daysFromMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;

    const start = new Date(startOfWeek);
    start.setDate(start.getDate() + daysFromMonday);
    start.setHours(
      lesson.start.getHours(),
      lesson.start.getMinutes(),
      lesson.start.getSeconds(),
      lesson.start.getMilliseconds(),
    );

    const end = new Date(start);
    end.setHours(
      lesson.end.getHours(),
      lesson.end.getMinutes(),
      lesson.end.getSeconds(),
      lesson.end.getMilliseconds(),
    );

    if (end <= start) {
      end.setDate(end.getDate() + 1);
    }

    return {
      title: lesson.title,
      start,
      end,
    };
  });
}
