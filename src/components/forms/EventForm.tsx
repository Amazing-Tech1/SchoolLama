"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import InputField from "../InputField";
import { eventSchema, EventSchema } from "@/lib/FormValidatorSchema";
import { Dispatch, SetStateAction, startTransition, useActionState, useEffect } from "react";
import { createEvent, updateEvent } from "@/lib/actions";
import { useRouter } from "next/navigation";
import { toast } from "react-toastify";

const EventForm = ({
  type,
  data,
  setOpen,
  relatedData,
}: {
  type: "create" | "update";
  data?: any;
  setOpen: Dispatch<SetStateAction<boolean>>;
  relatedData: any;
}) => {
  const {
    register,
    reset,
    handleSubmit,
    formState: { errors },
  } = useForm<EventSchema>({
    resolver: zodResolver(eventSchema),
    defaultValues: {
      ...data,
      startDate: "",
      endDate: "",
    },
  });

  const [state, formAction] = useActionState(type === "create" ? createEvent : updateEvent, {
    success: false,
    error: false,
    errorMessage: "",
  });

  const formatDateTime = (value: any) => {
    if (!value) return "";

    const date = new Date(value.toString());

    if (Number.isNaN(date.getTime())) {
      console.log("Invalid exam date:", value);
      return "";
    }

    const pad = (num: number) => String(num).padStart(2, "0");

    return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(
      date.getDate(),
    )}T${pad(date.getHours())}:${pad(date.getMinutes())}`;
  };

  useEffect(() => {
    if (type === "update" && data) {
      reset({
        ...data,
        startDate: formatDateTime(data.startDate),
        endDate: formatDateTime(data.endDate),
      });
    }
  }, [data, type, reset]);

  const onSubmit = handleSubmit((formData) => {
    startTransition(() => {
      formAction(formData);
    });
  });

  const router = useRouter();
  const { classList = [] } = relatedData;

  useEffect(() => {
    if (state.success) {
      toast.success(`Event has been ${type === "create" ? "created" : "updated"}!`);

      setOpen(false);
      router.refresh();
    }

    if (state.error && state.errorMessage) {
      toast.error(state.errorMessage);
    }
  }, [state, type, setOpen, router]);

  return (
    <form onSubmit={onSubmit} className="flex max-h-[80vh] flex-col gap-4">
      <div className="min-h-0 flex-1 space-y-4 overflow-y-auto overscroll-contain pr-2">
        <h1 className="text-xl font-semibold">
          {type === "create" ? "Create a new Event" : "Update Event"}
        </h1>

        <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
          {data && (
            <InputField
              label="id"
              name="id"
              defaultValue={data.id}
              register={register}
              error={errors.id}
              hidden
            />
          )}

          <InputField
            label="Title"
            name="title"
            defaultValue={data?.title}
            register={register}
            error={errors.title}
          />

          <InputField
            label="Start Date"
            name="startDate"
            register={register}
            error={errors.startDate}
            type="datetime-local"
          />

          <InputField
            label="End Date"
            name="endDate"
            register={register}
            error={errors.endDate}
            type="datetime-local"
          />
        </div>
        <div className="w-full flex flex-col gap-2">
          <label htmlFor="description" className="text-xs text-gray-500">
            Description
          </label>

          <textarea
            id="description"
            rows={3}
            className="w-full rounded-md border border-gray-300 p-2 text-sm"
            {...register("description")}
            defaultValue={data?.description}
          />

          {errors.description && (
            <p className="text-xs text-red-500">{errors.description.message}</p>
          )}
        </div>
        <div className="flex flex-col gap-2">
          <label htmlFor="classId" className="text-xs text-gray-500">
            Class (optional)
          </label>

          <select
            id="classId"
            className="w-full rounded-md border border-gray-300 bg-white p-2 text-sm text-gray-900"
            {...register("classId")}
          >
            <option value="">All classes (general event)</option>

            {classList.map((classItem: { id: number; name: string }) => (
              <option key={classItem.id} value={classItem.id}>
                {classItem.name}
              </option>
            ))}
          </select>

          {errors.classId && <p className="text-xs text-red-500">{errors.classId.message}</p>}
        </div>

        <button
          type="submit"
          className="w-full rounded-md bg-blue-400 p-2 text-white transition hover:bg-blue-500"
        >
          {type === "create" ? "Create" : "Update"}
        </button>
      </div>
    </form>
  );
};

export default EventForm;
