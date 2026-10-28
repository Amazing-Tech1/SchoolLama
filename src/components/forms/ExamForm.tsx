"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import InputField from "../InputField";
import { examSchema, ExamSchema } from "@/lib/FormValidatorSchema";
import {
  Dispatch,
  SetStateAction,
  startTransition,
  useActionState,
  useEffect,
  useState,
} from "react";
import { createExam, updateExam } from "@/lib/actions";
import { useRouter } from "next/navigation";
import { toast } from "react-toastify";

const ExamForm = ({
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
    setValue,
    formState: { errors },
  } = useForm<ExamSchema>({
    resolver: zodResolver(examSchema),
    defaultValues: {
      ...data,
      startTime: "",
      endTime: "",
    },
  });

  const [state, formAction] = useActionState(type === "create" ? createExam : updateExam, {
    success: false,
    error: false,
    errorMessage: "",
  });

  useEffect(() => {
    if (type === "update" && data) {
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

      reset({
        ...data,
        startTime: formatDateTime(data.startTime),
        endTime: formatDateTime(data.endTime),
      });
    }
  }, [data, type, reset]);

  const onSubmit = handleSubmit((data) => {
    startTransition(() => {
      formAction(data);
    });
  });

  const router = useRouter();

  useEffect(() => {
    if (state.success) {
      toast.success(`Exam has been ${type === "create" ? "created" : "updated"}!`);

      setOpen(false);
      router.refresh();
    }

    if (state.error && state.errorMessage) {
      toast.error(state.errorMessage);
    }
  }, [state, type, setOpen, router]);
  const { examLessons = [] } = relatedData;

  //   console.log("examLesson", examLessons);
  // console.log("Teacher Subjects", TeacherSubject);

  return (
    <form onSubmit={onSubmit} className="flex max-h-[80vh] flex-col gap-4">
      {/* Scrollable form content */}
      <div className="min-h-0 flex-1 space-y-4 overflow-y-auto overscroll-contain pr-2">
        <h1 className="text-xl font-semibold">
          {type === "create" ? "Create a new Exam" : "Update a Exam"}
        </h1>

        <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
          {data && (
            <InputField
              label="id"
              name="id"
              defaultValue={data?.id}
              register={register}
              error={errors?.id}
              hidden
            />
          )}
          <InputField
            label="Title"
            name="title"
            defaultValue={data?.title}
            register={register}
            error={errors?.title}
          />

          <InputField
            label="Start Time"
            name="startTime"
            // defaultValue={data?.startTime}
            register={register}
            error={errors?.startTime}
            type="datetime-local"
          />
          <InputField
            label="End Time"
            name="endTime"
            // defaultValue={data?.endTime}
            register={register}
            error={errors?.endTime}
            type="datetime-local"
          />
        </div>

        <select
          id="lesson"
          className="w-full rounded-md border border-gray-300 bg-white p-2 text-sm text-gray-900"
          {...register("lessonId")}
          defaultValue={data?.lessonId ?? ""}
        >
          <option value="" disabled>
            Select a lesson
          </option>

          {examLessons.map((lesson: { id: number; name: string }) => (
            <option key={lesson.id} value={lesson.id} className="bg-white text-gray-900">
              {lesson.name}
            </option>
          ))}
        </select>

        {/* Fixed footer */}
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

export default ExamForm;
