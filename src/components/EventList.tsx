import { db } from "@/lib/db";
import { Temporal } from "temporal-polyfill";

const EventList = async ({ dateParam }: { dateParam: string | undefined }) => {
  const date = dateParam ? new Date(dateParam) : new Date();

  const startOfDay = new Date(date);
  startOfDay.setHours(0, 0, 0, 0);

  const endOfDay = new Date(date);
  endOfDay.setHours(23, 59, 59, 999);

  const startInstant = Temporal.Instant.fromEpochMilliseconds(startOfDay.getTime());

  const endInstant = Temporal.Instant.fromEpochMilliseconds(endOfDay.getTime());

  const events = await db.orm.public.Events.where((event) => event.startDate.lte(endInstant)).all();

  const filteredEvents = events.filter(
    (event) => Temporal.Instant.compare(event.endDate, startInstant) >= 0,
  );

  console.log("filteredEvents:", filteredEvents);

  return (
    <div>
      {filteredEvents.map((event) => (
        <div
          className="p-5 rounded-md border-2 border-gray-100 border-t-4 odd:border-t-lamaSky even:border-t-lamaPurple"
          key={event.id}
        >
          <div className="flex items-center justify-between">
            <h1 className="font-semibold text-gray-600">{event.title}</h1>
            <span className="text-gray-300 text-xs">
              {new Date(event.startDate.toString()).toLocaleTimeString([], {
                hour: "2-digit",
                minute: "2-digit",
              })}
            </span>
          </div>

          <p className="mt-2 text-gray-400 text-sm">{event.description}</p>
        </div>
      ))}
    </div>
  );
};

export default EventList;
