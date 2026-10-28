import Pagination from "@/components/Pagination";
import Table from "@/components/Table";
import TableSearch from "@/components/TableSearch";
import Image from "next/image";
import type { Models } from "@/prisma/contract";
import { db } from "@/lib/db";
import { ITEM_PER_PAGE } from "@/lib/settings";
import { or } from "@prisma/orm-postgres/orm-client";
import FormContainer from "@/components/FormContainer";
import { serialize } from "@/lib/serialize";
import { getCurrentAuth } from "@/lib/utils";

const EventListPage = async ({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | undefined }>;
}) => {
  const { role, currentUserId } = await getCurrentAuth();
  const columns = [
    { header: "Title", accessor: "title" },
    { header: "Class", accessor: "class" },
    {
      header: "Date",
      accessor: "date",
      className: "hidden md:table-cell",
    },
    {
      header: "Start Time",
      accessor: "startTime",
      className: "hidden md:table-cell",
    },
    {
      header: "End Time",
      accessor: "endTime",
      className: "hidden md:table-cell",
    },
    ...(role === "admin"
      ? [
          {
            header: "Actions",
            accessor: "action",
          },
        ]
      : []),
  ];

  const { page, ...queryParams } = await searchParams;

  const parsedPage = Number.parseInt(page ?? "1", 10);
  const p = Number.isNaN(parsedPage) || parsedPage < 1 ? 1 : parsedPage;

  const parsedClassId = queryParams.classId ? Number.parseInt(queryParams.classId, 10) : undefined;

  const classId =
    parsedClassId !== undefined && !Number.isNaN(parsedClassId) ? parsedClassId : undefined;

  const search = queryParams.search?.trim();

  let eventQuery = db.orm.public.Events;
  let eventCountQuery = db.orm.public.Events;

  if (classId !== undefined) {
    eventQuery = eventQuery.where((event) => event.classId.eq(classId));

    eventCountQuery = eventCountQuery.where((event) => event.classId.eq(classId));
  }

  if (search) {
    eventQuery = eventQuery.where((event) => event.title.ilike(`%${search}%`));

    eventCountQuery = eventCountQuery.where((event) => event.title.ilike(`%${search}%`));
  }

  // ROLE CONDITION

  console.log(currentUserId);

  switch (role) {
    case "admin":
      break;

    case "teacher":
      eventQuery = eventQuery.where((event) =>
        or(
          event.class.some((classItem) => classItem.supervisorId.eq(currentUserId as string)),
          event.class.none(),
        ),
      );

      eventCountQuery = eventCountQuery.where((event) =>
        or(
          event.class.some((classItem) => classItem.supervisorId.eq(currentUserId as string)),
          event.class.none(),
        ),
      );
      break;

    case "student":
      eventQuery = eventQuery.where((event) =>
        or(
          event.class.some((classItem) =>
            classItem.students.some((student) => student.id.eq(currentUserId as string)),
          ),
          event.class.none(),
        ),
      );

      eventCountQuery = eventCountQuery.where((event) =>
        or(
          event.class.some((classItem) =>
            classItem.students.some((student) => student.id.eq(currentUserId as string)),
          ),
          event.class.none(),
        ),
      );
      break;

    case "parent":
      eventQuery = eventQuery.where((event) =>
        or(
          event.class.some((classItem) =>
            classItem.students.some((student) => student.parentId.eq(currentUserId as string)),
          ),
          event.class.none(),
        ),
      );

      eventCountQuery = eventCountQuery.where((event) =>
        or(
          event.class.some((classItem) =>
            classItem.students.some((student) => student.parentId.eq(currentUserId as string)),
          ),
          event.class.none(),
        ),
      );
      break;

    default:
      break;
  }

  const events = await eventQuery
    .include("class")
    .orderBy((event) => event.id.asc())
    .offset(ITEM_PER_PAGE * (p - 1))
    .limit(ITEM_PER_PAGE)
    .all();

  const countResult = await eventCountQuery.aggregate((agg) => ({
    total: agg.count(),
  }));

  const count = countResult.total;

  const renderRow = (item: Models.public_Events) => {
    const startDate = new Date(item.startDate.toString());
    const endDate = new Date(item.endDate.toString());

    return (
      <tr
        key={item.id}
        className="border-b border-gray-200 even:bg-slate-50 text-sm hover:bg-lamaPurpleLight"
      >
        <td className="p-4">{item.title}</td>

        <td>{item.class?.name ?? "_"}</td>

        <td className="hidden md:table-cell">{startDate.toLocaleDateString("en-US")}</td>

        <td className="hidden md:table-cell">
          {startDate.toLocaleTimeString("en-US", {
            hour: "2-digit",
            minute: "2-digit",
            hour12: false,
          })}
        </td>

        <td className="hidden md:table-cell">
          {endDate.toLocaleTimeString("en-US", {
            hour: "2-digit",
            minute: "2-digit",
            hour12: false,
          })}
        </td>

        <td>
          <div className="flex items-center gap-2">
            {role === "admin" && (
              <>
                <FormContainer table="event" type="update" data={serialize(item)} />
                <FormContainer table="event" type="delete" id={item.id} />
              </>
            )}
          </div>
        </td>
      </tr>
    );
  };

  return (
    <div className="bg-white p-4 rounded-md flex-1 m-4 mt-0">
      <div className="flex items-center justify-between">
        <h1 className="hidden md:block text-lg font-semibold">All Events</h1>

        <div className="flex flex-col md:flex-row items-center gap-4 w-full md:w-auto">
          <TableSearch />

          <div className="flex items-center gap-4 self-end">
            <button
              type="button"
              aria-label="Filter events"
              className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow"
            >
              <Image src="/filter.png" alt="" width={14} height={14} />
            </button>

            <button
              type="button"
              aria-label="Sort events"
              className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow"
            >
              <Image src="/sort.png" alt="" width={14} height={14} />
            </button>

            {role === "admin" && <FormContainer table="event" type="create" />}
          </div>
        </div>
      </div>

      <Table columns={columns} renderRow={renderRow} data={events} />

      <Pagination page={p} count={count} />
    </div>
  );
};

export default EventListPage;
