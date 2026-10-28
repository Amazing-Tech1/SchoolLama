"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import InputField from "../InputField";
import { resultSchema, ResultSchema } from "@/lib/FormValidatorSchema";
import {
  Dispatch,
  SetStateAction,
  startTransition,
  useActionState,
  useEffect,
  useState,
} from "react";
import { createResult, updateResult } from "@/lib/actions";
import { useRouter } from "next/navigation";
import { toast } from "react-toastify";

type ResultFormProps = {
  type: "create" | "update";
  data?: Partial<ResultSchema>;
  setOpen: Dispatch<SetStateAction<boolean>>;
  relatedData: any;
};

type AssessmentType = "" | "exam" | "assignment";

const ResultForm = ({ type, data, setOpen, relatedData }: ResultFormProps) => {
  const {
    register,
    handleSubmit,
    setValue,
    watch,
    formState: { errors },
  } = useForm<ResultSchema>({
    resolver: zodResolver(resultSchema),
  });

  const [assessmentType, setAssessmentType] = useState<AssessmentType>(
    data?.examId != null ? "exam" : data?.assignmentId != null ? "assignment" : "",
  );

  const [state, formAction] = useActionState(type === "create" ? createResult : updateResult, {
    success: false,
    error: false,
    errorMessage: "",
  });

  const selectedExamId = watch("examId");
  const selectedAssignmentId = watch("assignmentId");
  const router = useRouter();

  const { students = [], exams = [], assignments = [] } = relatedData;

  console.log("Result data:", data);
  console.log("Exam ID:", data?.examId);
  console.log("Assignment ID:", data?.assignmentId);
  console.log("Available exams:", exams);
  console.log("Available assignments:", assignments);
  const handleAssessmentTypeChange = (newType: AssessmentType) => {
    setAssessmentType(newType);

    setValue("examId", undefined, { shouldValidate: true });
    setValue("assignmentId", undefined, { shouldValidate: true });
  };

  const onSubmit = handleSubmit((formData) => {
    startTransition(() => formAction(formData));
  });

  useEffect(() => {
    if (type !== "update") return;

    if (data?.examId != null) {
      setAssessmentType("exam");
      setValue("examId", data.examId);
    } else if (data?.assignmentId != null) {
      setAssessmentType("assignment");
      setValue("assignmentId", data.assignmentId);
    }
  }, [type, data?.examId, data?.assignmentId, setValue]);

  useEffect(() => {
    if (state.success) {
      toast.success(`Result has been ${type === "create" ? "created" : "updated"}!`);
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
          {type === "create" ? "Create a result" : "Update a result"}
        </h1>

        {data?.id !== undefined && (
          <InputField
            label="id"
            name="id"
            register={register}
            hidden
            defaultValue={String(data.id)}
          />
        )}

        <InputField
          label="Score"
          name="score"
          type="number"
          register={register}
          defaultValue={String(data?.score ?? "")}
          error={errors.score}
          inputProps={{ min: 0, step: 1 }}
        />

        <div className="flex flex-col gap-2">
          <label htmlFor="studentId" className="text-xs text-gray-500">
            Student
          </label>

          <select
            id="studentId"
            className="w-full rounded-md border border-gray-300 bg-white p-2 text-sm"
            defaultValue={data?.studentId}
            {...register("studentId")}
          >
            <option value="">Select a student</option>
            {students.map((student: { id: number; name: string; surname: string }) => (
              <option key={student.id} value={student.id}>
                {student.name} {student.surname}
              </option>
            ))}
          </select>

          {errors.studentId?.message && (
            <p className="text-xs text-red-400">{errors.studentId.message}</p>
          )}
        </div>

        {/* Assessment type */}
        <div className="flex flex-col gap-2">
          <label htmlFor="assessmentType" className="text-xs text-gray-500">
            Assessment type
          </label>

          <select
            id="assessmentType"
            value={assessmentType}
            onChange={(event) => handleAssessmentTypeChange(event.target.value as AssessmentType)}
            className="w-full rounded-md border border-gray-300 bg-white p-2 text-sm"
          >
            <option value="">Select assessment type</option>
            <option value="exam">Exam</option>
            <option value="assignment">Assignment</option>
          </select>
        </div>

        {/* Show only the relevant assessment dropdown */}
        {assessmentType === "exam" && (
          <div className="flex flex-col gap-2">
            <label htmlFor="examId" className="text-xs text-gray-500">
              Exam
            </label>

            <select
              id="examId"
              value={selectedExamId ?? ""}
              className="w-full rounded-md border border-gray-300 bg-white p-2 text-sm"
              {...register("examId")}
            >
              <option value="">Select an exam</option>

              {exams.map((exam: { id: number; title: string }) => (
                <option key={exam.id} value={exam.id}>
                  {exam.title}
                </option>
              ))}
            </select>
            {errors.examId?.message && (
              <p className="text-xs text-red-400">{errors.examId.message}</p>
            )}
          </div>
        )}

        {assessmentType === "assignment" && (
          <div className="flex flex-col gap-2">
            <label htmlFor="assignmentId" className="text-xs text-gray-500">
              Assignment
            </label>

            <select
              id="assignmentId"
              value={selectedAssignmentId ?? ""}
              className="w-full rounded-md border border-gray-300 bg-white p-2 text-sm"
              {...register("assignmentId")}
            >
              <option value="">Select an assignment</option>

              {assignments.map((assignment: { id: number; title: string }) => (
                <option key={assignment.id} value={assignment.id}>
                  {assignment.title}
                </option>
              ))}
            </select>

            {errors.assignmentId?.message && (
              <p className="text-xs text-red-400">{errors.assignmentId.message}</p>
            )}
          </div>
        )}

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

export default ResultForm;
