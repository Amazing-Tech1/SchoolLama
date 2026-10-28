import FormContainer from "@/components/FormContainer";
import Pagination from "@/components/Pagination";
import Table from "@/components/Table";
import TableSearch from "@/components/TableSearch";

import { db } from "@/lib/db";
import { ITEM_PER_PAGE } from "@/lib/settings";
import { getCurrentAuth } from "@/lib/utils";
import type { Models } from "@/prisma/contract";
import { or } from "@prisma/orm-postgres/orm-client";

import Image from "next/image";

const getColumns = (role?: string) => [
  {
    header: "Title",
    accessor: "title",
  },
  {
    header: "Class",
    accessor: "class",
  },
  {
    header: "Date",
    accessor: "date",
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

const AnnouncementListPage = async ({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | undefined }>;
}) => {
  const { currentUserId, role } = await getCurrentAuth();
  const { page, ...queryParams } = await searchParams;

  const parsedPage = Number.parseInt(page ?? "1", 10);
  const p = Number.isNaN(parsedPage) || parsedPage < 1 ? 1 : parsedPage;

  const parsedClassId = queryParams.classId ? Number.parseInt(queryParams.classId, 10) : undefined;

  const classId =
    parsedClassId !== undefined && !Number.isNaN(parsedClassId) ? parsedClassId : undefined;

  const search = queryParams.search?.trim();

  let announcementQuery = db.orm.public.Announcements;
  let announcementCountQuery = db.orm.public.Announcements;

  // FILTER BY CLASS
  if (classId !== undefined) {
    announcementQuery = announcementQuery.where((announcement) => announcement.classId.eq(classId));

    announcementCountQuery = announcementCountQuery.where((announcement) =>
      announcement.classId.eq(classId),
    );
  }

  // SEARCH BY TITLE
  if (search) {
    announcementQuery = announcementQuery.where((announcement) =>
      announcement.title.ilike(`%${search}%`),
    );

    announcementCountQuery = announcementCountQuery.where((announcement) =>
      announcement.title.ilike(`%${search}%`),
    );
  }

  // ROLE CONDITION

  console.log(currentUserId);

  switch (role) {
    case "admin":
      break;

    case "teacher":
      announcementQuery = announcementQuery.where((event) =>
        or(
          event.class.some((classItem) => classItem.supervisorId.eq(currentUserId as string)),
          event.class.none(),
        ),
      );

      announcementCountQuery = announcementCountQuery.where((event) =>
        or(
          event.class.some((classItem) => classItem.supervisorId.eq(currentUserId as string)),
          event.class.none(),
        ),
      );
      break;

    case "student":
      announcementQuery = announcementQuery.where((event) =>
        or(
          event.class.some((classItem) =>
            classItem.students.some((student) => student.id.eq(currentUserId as string)),
          ),
          event.class.none(),
        ),
      );

      announcementCountQuery = announcementCountQuery.where((event) =>
        or(
          event.class.some((classItem) =>
            classItem.students.some((student) => student.id.eq(currentUserId as string)),
          ),
          event.class.none(),
        ),
      );
      break;

    case "parent":
      announcementQuery = announcementQuery.where((event) =>
        or(
          event.class.some((classItem) =>
            classItem.students.some((student) => student.parentId.eq(currentUserId as string)),
          ),
          event.class.none(),
        ),
      );

      announcementCountQuery = announcementCountQuery.where((event) =>
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

  // GET ANNOUNCEMENTS
  const announcements = await announcementQuery
    .include("class")
    .orderBy((announcement) => announcement.id.asc())
    .offset(ITEM_PER_PAGE * (p - 1))
    .limit(ITEM_PER_PAGE)
    .all();

  // COUNT ANNOUNCEMENTS
  const countResult = await announcementCountQuery.aggregate((agg) => ({
    total: agg.count(),
  }));

  const count = countResult.total;

  // TABLE ROW
  const renderRow = (item: Models.public_Announcements) => {
    const date = new Date(item.date.toString());

    // Serializable data for the client-side modal
    const announcementForModal = {
      id: item.id,
      title: item.title,
      description: item.description,
      classId: item.classId,
      date: item.date.toString(),
    };

    return (
      <tr
        key={item.id}
        className="border-b border-gray-200 even:bg-slate-50 text-sm hover:bg-lamaPurpleLight"
      >
        <td className="p-4">{item.title}</td>

        <td>{item.class?.name ?? "_"}</td>

        <td className="hidden md:table-cell">{date.toLocaleDateString("en-US")}</td>

        <td>
          <div className="flex items-center gap-2">
            {role === "admin" && (
              <>
                <FormContainer table="announcement" type="update" data={announcementForModal} />

                <FormContainer table="announcement" type="delete" id={item.id} />
              </>
            )}
          </div>
        </td>
      </tr>
    );
  };

  return (
    <div className="bg-white p-4 rounded-md flex-1 m-4 mt-0">
      {/* TOP */}
      <div className="flex items-center justify-between">
        <h1 className="hidden md:block text-lg font-semibold">All Announcements</h1>

        <div className="flex flex-col md:flex-row items-center gap-4 w-full md:w-auto">
          <TableSearch />

          <div className="flex items-center gap-4 self-end">
            <button
              type="button"
              aria-label="Filter announcements"
              className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow"
            >
              <Image src="/filter.png" alt="" width={14} height={14} />
            </button>

            <button
              type="button"
              aria-label="Sort announcements"
              className="w-8 h-8 flex items-center justify-center rounded-full bg-lamaYellow"
            >
              <Image src="/sort.png" alt="" width={14} height={14} />
            </button>

            {role === "admin" && <FormContainer table="announcement" type="create" />}
          </div>
        </div>
      </div>

      {/* LIST */}
      <Table columns={getColumns(role)} renderRow={renderRow} data={announcements} />

      {/* PAGINATION */}
      <Pagination page={p} count={count} />
    </div>
  );
};

export default AnnouncementListPage;
