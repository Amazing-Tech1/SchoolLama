"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";

import InputField from "../InputField";

import { classSchema, ClassSchema } from "@/lib/FormValidatorSchema";
import { createClass, updateClass } from "@/lib/actions";
import { Dispatch, SetStateAction, useActionState, useEffect, startTransition } from "react";
import { toast } from "react-toastify";
import { useRouter } from "next/navigation";

const ClassForm = ({
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
    handleSubmit,
    formState: { errors },
  } = useForm<ClassSchema>({
    resolver: zodResolver(classSchema),
  });
  const [state, formAction] = useActionState(type === "create" ? createClass : updateClass, {
    success: false,
    error: false,
  });
  const onSubmit = handleSubmit((data) => {
    startTransition(() => {
      formAction(data);
    });
  });
  const router = useRouter();

  useEffect(() => {
    if (state.success) {
      toast.success(`Subject has been ${type === "create" ? "created" : "updated"}!`);
      setOpen(false);
      router.refresh();
    }
  }, [state]);

  const { ClassGrades, ClassTeacher = [] } = relatedData;
  console.log("Class Grades:", ClassGrades);
  console.log("teachers :", ClassTeacher);
  return (
    <form className="flex flex-col gap-6" onSubmit={onSubmit}>
      <div className="space-y-1">
        <h1 className="text-xl font-semibold text-gray-800">
          {type === "create" ? "Create Class" : "Update Class"}
        </h1>
        <p className="text-sm text-gray-500">
          Manage the class details, assigned teacher, and grade.
        </p>
      </div>

      <div className="grid grid-cols-1 gap-5 md:grid-cols-2">
        <InputField
          label="Class Name"
          name="name"
          defaultValue={data?.name}
          register={register}
          error={errors.name}
        />

        <InputField
          label="Capacity"
          name="capacity"
          type="number"
          defaultValue={data?.capacity}
          register={register}
          error={errors.capacity}
        />

        {data && (
          <InputField
            label="ID"
            name="id"
            defaultValue={data.id}
            register={register}
            error={errors.id}
            hidden
          />
        )}

        <div className="flex flex-col gap-2">
          <label htmlFor="supervisorId" className="text-sm font-medium text-gray-700">
            Class Teacher
          </label>

          <select
            id="supervisorId"
            {...register("supervisorId")}
            defaultValue={data?.supervisorId ?? ""}
            className="h-11 w-full rounded-lg border border-gray-200 bg-white px-3 text-sm text-gray-700 outline-none transition focus:border-blue-400 focus:ring-2 focus:ring-blue-100"
          >
            <option value="">Select a teacher</option>
            {ClassTeacher.map((teacher: { id: string; name: string; surname: string }) => (
              <option
                key={teacher.id}
                value={teacher.id}
                // selected={data && ClassTeacher.id === data.supervisorId}
              >
                {teacher.name} {teacher.surname}
              </option>
            ))}
          </select>

          {errors.supervisorId?.message && (
            <p className="text-xs text-red-500">{errors.supervisorId.message.toString()}</p>
          )}
        </div>

        <div className="flex flex-col gap-2">
          <label htmlFor="gradeId" className="text-sm font-medium text-gray-700">
            Grade
          </label>

          <select
            id="gradeId"
            {...register("gradeId", { valueAsNumber: true })}
            defaultValue={data?.gradeId ?? ""}
            className="h-11 w-full rounded-lg border border-gray-200 bg-white px-3 text-sm text-gray-700 outline-none transition focus:border-blue-400 focus:ring-2 focus:ring-blue-100"
          >
            <option value="" disabled>
              Select a grade
            </option>
            {ClassGrades.map((grade: { id: number; level: number }) => (
              <option
                key={grade.id}
                value={grade.id}
                // selected={data && ClassGrades.id === data.gradeId}
              >
                Grade {grade.level}
              </option>
            ))}
          </select>

          {errors.gradeId?.message && (
            <p className="text-xs text-red-500">{errors.gradeId.message.toString()}</p>
          )}
        </div>
      </div>

      {state.error && (
        <p className="rounded-lg bg-red-50 px-3 py-2 text-sm text-red-600">
          Something went wrong. Please try again.
        </p>
      )}

      <button className="bg-blue-400 text-white p-2 rounded-md">
        {type === "create" ? "Create" : "Update"}
      </button>
    </form>
  );
};

export default ClassForm;
