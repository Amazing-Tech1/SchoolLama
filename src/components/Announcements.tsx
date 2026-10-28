import { db } from "@/lib/db";
import { getCurrentAuth } from "@/lib/utils";
import { and, or } from "@prisma/orm-postgres/orm-client";
import { Temporal } from "temporal-polyfill";

type AnnouncementSearchParams = {
  [key: string]: string | string[] | undefined;
};

const Announcements = async ({
  searchParams,
}: {
  searchParams?: Promise<AnnouncementSearchParams>;
}) => {
  const { currentUserId, role } = await getCurrentAuth();
  const params = (await searchParams) ?? {};
  const dateParam = typeof params.date === "string" ? params.date : undefined;
  const parsedDate = dateParam ? new Date(dateParam) : new Date();
  const selectedDate = Number.isNaN(parsedDate.getTime()) ? new Date() : parsedDate;

  const startOfDay = new Date(selectedDate);
  startOfDay.setHours(0, 0, 0, 0);
  const startOfNextDay = new Date(startOfDay);
  startOfNextDay.setDate(startOfNextDay.getDate() + 1);

  if (!currentUserId && role !== "admin") {
    return (
      <div className="rounded-md bg-white p-4">
        <h1 className="text-xl font-semibold">Announcements</h1>
        <p className="mt-4 text-sm text-gray-500">Unable to identify the current user.</p>
      </div>
    );
  }

  const startInstant = Temporal.Instant.fromEpochMilliseconds(startOfDay.getTime());
  const nextDayInstant = Temporal.Instant.fromEpochMilliseconds(startOfNextDay.getTime());

  let announcementsQuery = db.orm.public.Announcements.where((announcement) =>
    and(announcement.date.gte(startInstant), announcement.date.lt(nextDayInstant)),
  );

  switch (role) {
    case "admin":
      break;
    case "teacher":
      announcementsQuery = announcementsQuery.where((announcement) =>
        or(
          announcement.classId.isNull(),
          announcement.class.some((classItem) => classItem.supervisorId.eq(currentUserId!)),
        ),
      );
      break;
    case "student":
      announcementsQuery = announcementsQuery.where((announcement) =>
        or(
          announcement.classId.isNull(),
          announcement.class.some((classItem) =>
            classItem.students.some((student) => student.id.eq(currentUserId!)),
          ),
        ),
      );
      break;
    case "parent":
      announcementsQuery = announcementsQuery.where((announcement) =>
        or(
          announcement.classId.isNull(),
          announcement.class.some((classItem) =>
            classItem.students.some((student) => student.parentId.eq(currentUserId!)),
          ),
        ),
      );
      break;
    default:
      break;
  }

  let announcements;
  try {
    announcements = await announcementsQuery
      .orderBy((announcement) => announcement.date.desc())
      .limit(3)
      .all();
  } catch (error) {
    console.error("Unable to load announcements.", error);
    return (
      <div className="rounded-md bg-white p-4">
        <h1 className="text-xl font-semibold">Announcements</h1>
        <p className="mt-4 text-sm text-gray-500">Announcements are temporarily unavailable.</p>
      </div>
    );
  }

  const colors = ["bg-lamaSkyLight", "bg-lamaPurpleLight", "bg-lamaYellowLight"];

  return (
    <div className="rounded-md bg-white p-4">
      <div className="flex items-center justify-between">
        <h1 className="text-xl font-semibold">Announcements</h1>
        <span className="text-xs text-gray-400">View All</span>
      </div>

      <div className="mt-4 flex flex-col gap-4">
        {announcements.map((announcement, index) => (
          <div key={announcement.id} className={`${colors[index % colors.length]} rounded-md p-4`}>
            <div className="flex items-center justify-between gap-2">
              <h2 className="font-medium">{announcement.title}</h2>
              <span className="whitespace-nowrap rounded-md bg-white px-2 py-1 text-xs text-gray-500">
                {new Date(announcement.date.toString()).toLocaleDateString()}
              </span>
            </div>
            <p className="mt-1 text-sm text-gray-600">{announcement.description}</p>
          </div>
        ))}

        {announcements.length === 0 && (
          <p className="text-sm text-gray-500">No announcements for this date.</p>
        )}
      </div>
    </div>
  );
};

export default Announcements;
