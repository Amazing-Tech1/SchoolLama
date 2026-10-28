"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import InputField from "../InputField";
import { parentSchema, ParentSchema } from "@/lib/FormValidatorSchema";
import {
  Dispatch,
  SetStateAction,
  startTransition,
  useActionState,
  useEffect,
  useState,
} from "react";
import { createParent, updateParent } from "@/lib/actions";
import { useRouter } from "next/navigation";
import { toast } from "react-toastify";
import { CldUploadButton } from "next-cloudinary";
import type { CloudinaryUploadWidgetInfo } from "next-cloudinary";
import Image from "next/image";

const ParentForm = ({
  type,
  data,
  setOpen,
}: {
  type: "create" | "update";
  data?: any;
  setOpen: Dispatch<SetStateAction<boolean>>;
}) => {
  const {
    register,
    reset,
    handleSubmit,
    setValue,
    formState: { errors },
  } = useForm<ParentSchema>({
    resolver: zodResolver(parentSchema),
  });

  const [state, formAction] = useActionState(type === "create" ? createParent : updateParent, {
    success: false,
    error: false,
    errorMessage: "",
  });
  const [previewImage, setPreviewImage] = useState<string | null>(data?.img || null);

  const onSubmit = handleSubmit((data) => {
    startTransition(() => {
      formAction(data);
    });
  });

  const router = useRouter();

  useEffect(() => {
    if (state.success) {
      toast.success(`Parent account has been ${type === "create" ? "created" : "updated"}!`);

      setOpen(false);
      router.refresh();
    }

    if (state.error && state.errorMessage) {
      toast.error(state.errorMessage);
    }
  }, [state, type, setOpen, router]);

  // console.log("Teacher Subjects", TeacherSubject);

  return (
    <form onSubmit={onSubmit} className="flex max-h-[80vh] flex-col gap-4">
      {/* Scrollable form content */}
      <div className="min-h-0 flex-1 space-y-4 overflow-y-auto overscroll-contain pr-2">
        <h1 className="text-xl font-semibold">
          {type === "create" ? "Create a new Parent" : "Update a Parent"}
        </h1>

        <span className="text-xs font-medium text-gray-400">Authentication Information</span>

        {/* Cloudinary image upload with preview */}
        <div className="flex w-full flex-col gap-2">
          <label className="text-xs text-gray-500">Parent Photo</label>

          <CldUploadButton
            uploadPreset={process.env.NEXT_PUBLIC_CLOUDINARY_UPLOAD_PRESET!}
            onSuccess={(result, { widget }) => {
              if (result?.info && typeof result.info !== "string") {
                const resource = result.info as CloudinaryUploadWidgetInfo;

                if (resource.secure_url) {
                  setValue("img", resource.secure_url, {
                    shouldValidate: true,
                    shouldDirty: true,
                  });

                  setPreviewImage(resource.secure_url);

                  toast.success("Photo uploaded successfully!");
                }
              }

              widget.close();
            }}
            onError={(error) => {
              console.error("Cloudinary upload error:", error);
              toast.error("Photo upload failed.");
            }}
            options={{
              sources: ["local"],
              multiple: false,
              maxFiles: 1,
              resourceType: "image",
            }}
          >
            <div className="flex cursor-pointer items-center gap-2 text-xs text-gray-500">
              <Image src="/upload.png" alt="" width={28} height={28} />
              <span>{previewImage ? "Change photo" : "Upload a photo"}</span>
            </div>
          </CldUploadButton>

          {/* Image preview */}
          {previewImage && (
            <div className="mt-2">
              <p className="mb-2 text-xs text-gray-500">Photo preview</p>

              <Image
                src={previewImage}
                alt="Teacher photo preview"
                width={120}
                height={120}
                unoptimized
                className="h-28 w-28 rounded-md border border-gray-200 object-cover"
              />
            </div>
          )}

          <input type="hidden" {...register("img")} />

          {errors.img?.message && (
            <p className="text-xs text-red-400">{errors.img.message.toString()}</p>
          )}
        </div>
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
            label="Username"
            name="username"
            defaultValue={data?.username}
            register={register}
            error={errors?.username}
          />

          <InputField
            label="Email"
            name="email"
            defaultValue={data?.email}
            register={register}
            error={errors?.email}
          />

          <InputField
            label="Password"
            name="password"
            type="password"
            defaultValue={data?.password}
            register={register}
            error={errors?.password}
          />
        </div>

        <span className="text-xs font-medium text-gray-400">Personal Information</span>

        <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
          <InputField
            label="Name"
            name="name"
            defaultValue={data?.name}
            register={register}
            error={errors.name}
          />

          <InputField
            label="Surname"
            name="surname"
            defaultValue={data?.surname}
            register={register}
            error={errors.surname}
          />

          <InputField
            label="Phone"
            name="phone"
            defaultValue={data?.phone}
            register={register}
            error={errors.phone}
          />

          <InputField
            label="Address"
            name="address"
            defaultValue={data?.address}
            register={register}
            error={errors.address}
          />
        </div>
      </div>

      {/* Fixed footer */}
      <button
        type="submit"
        className="mt-6 w-full rounded-md bg-blue-400 p-2 text-white transition hover:bg-blue-500 sm:w-auto sm:min-w-28"
      >
        {type === "create" ? "Create" : "Update"}
      </button>
    </form>
  );
};

export default ParentForm;
