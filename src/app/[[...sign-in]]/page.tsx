"use client";

import { useEffect, useState } from "react";
import { useSignIn, useUser } from "@clerk/nextjs";
import { useRouter } from "next/navigation";
import Link from "next/link";
import Image from "next/image";

export default function SignInPage() {
  const { signIn, errors, fetchStatus } = useSignIn();

  const { isLoaded, isSignedIn, user } = useUser();
  const router = useRouter();

  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [formError, setFormError] = useState("");

  const isLoading = fetchStatus === "fetching";

  useEffect(() => {
    if (!isLoaded || !isSignedIn) return;

    const role = user?.publicMetadata?.role;

    if (role === "admin" || role === "teacher" || role === "student" || role === "parent") {
      router.replace(`/${role}`);
    }
  }, [isLoaded, isSignedIn, user, router]);

  async function handleSubmit() {
    setFormError("");

    try {
      const { error } = await signIn.password({
        identifier: username.trim(),
        password,
      });

      if (error) {
        console.error("Clerk sign-in error:", error);
        setFormError(error.message || "Unable to sign in. Please try again.");
        return;
      }

      console.log("Sign-in status:", signIn.status);

      if (signIn.status === "complete") {
        await signIn.finalize({
          navigate: ({ session, decorateUrl }) => {
            console.log("Current session task:", session?.currentTask);

            if (session?.currentTask) {
              setFormError(`Additional step required: ${session.currentTask.key}`);
              return;
            }

            const url = decorateUrl("/");
            window.location.assign(url);
          },
        });
      }
      // else {
      //   console.log("Sign-in requires another step:", signIn);

      //   setFormError(`Sign-in status: ${signIn.status}. Check the browser console for details.`);
      // }
    } catch (error) {
      console.error("Unexpected sign-in error:", error);
      setFormError("Something went wrong. Please try again.");
    }
  }

  return (
    <main className="min-h-screen bg-[#F7F8FA]">
      <div className="grid min-h-screen lg:grid-cols-2">
        {/* Left: branding panel */}
        <section className="relative hidden overflow-hidden bg-lamaSkyLight p-12 text-gray-900 lg:flex lg:flex-col lg:justify-between">
          <div className="absolute -right-24 -top-24 h-80 w-80 rounded-full bg-lamaSky blur-3xl" />
          <div className="absolute -bottom-24 -left-24 h-80 w-80 rounded-full bg-lamaPurple blur-3xl" />

          <Link href="/" className="flex items-center justify-center lg:justify-start gap-2">
            <Image src="/logo.png" alt="logo" width={32} height={32} />
            <span className="hidden lg:block font-bold">SchooLama</span>
          </Link>

          <div className="relative max-w-lg">
            <span className="mb-5 inline-flex rounded-full bg-white px-4 py-2 text-sm text-gray-500">
              School Management System
            </span>
            <h1 className="text-4xl font-semibold leading-tight text-gray-900 xl:text-5xl">
              Everything your school needs, in one place.
            </h1>
            <p className="mt-5 max-w-md leading-7 text-gray-500">
              Manage students, teachers, classes, announcements, and school activities through one
              organized platform.
            </p>
          </div>

          <p className="relative text-sm text-gray-400">
            © {new Date().getFullYear()} SchooLama. All rights reserved.
          </p>
        </section>

        {/* Right: sign-in form */}
        <section className="flex min-h-screen items-center justify-center px-5 py-12 sm:px-8">
          <div className="w-full max-w-md">
            <Link href="/" className="mb-8 flex items-center justify-center gap-3 lg:hidden">
              <Image src="/logo.png" alt="logo" width={32} height={32} />
              <span className="text-xl font-semibold text-gray-900">SchooLama</span>
            </Link>

            <div className="rounded-md bg-white p-6 sm:p-8">
              <div className="mb-6">
                <p className="text-xs font-medium text-gray-400">Welcome back</p>
                <h2 className="mt-2 text-xl font-semibold text-gray-900">
                  Sign in to your account
                </h2>
                <p className="mt-2 text-sm text-gray-500">
                  Enter your school account details to continue.
                </p>
              </div>

              <form
                onSubmit={(e) => {
                  e.preventDefault();
                  handleSubmit();
                }}
                className="space-y-4"
              >
                <div className="space-y-2">
                  <label htmlFor="username" className="block text-xs text-gray-500">
                    Username
                  </label>

                  <input
                    id="username"
                    type="text"
                    name="username"
                    autoComplete="username"
                    placeholder="Enter your username"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    required
                    className="w-full rounded-md p-2 text-sm ring-[1.5px] ring-gray-300 outline-none transition placeholder:text-gray-400 focus:ring-blue-400"
                  />
                </div>

                <div className="space-y-2">
                  <div className="flex items-center justify-between gap-3">
                    <label htmlFor="password" className="block text-xs text-gray-500">
                      Password
                    </label>
                    <Link
                      href="/forgot-password"
                      className="text-xs font-medium text-blue-400 hover:text-blue-500"
                    >
                      Forgot password?
                    </Link>
                  </div>

                  <div className="relative">
                    <input
                      id="password"
                      type={showPassword ? "text" : "password"}
                      name="password"
                      autoComplete="current-password"
                      placeholder="Enter your password"
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      required
                      className="w-full rounded-md p-2 pr-16 text-sm ring-[1.5px] ring-gray-300   outline-none transition placeholder:text-gray-400 focus:ring-blue-400"
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword((visible) => !visible)}
                      className="absolute inset-y-0 right-3 my-auto h-max text-xs font-medium text-gray-400 hover:text-gray-900"
                    >
                      {showPassword ? "Hide" : "Show"}
                    </button>
                  </div>
                </div>

                {formError && (
                  <p role="alert" className="text-xs text-red-400">
                    {formError}
                  </p>
                )}

                {!formError && errors.fields.identifier?.message && (
                  <p role="alert" className="text-xs text-red-400">
                    {errors.fields.identifier.message}
                  </p>
                )}

                {!formError && errors.fields.password?.message && (
                  <p role="alert" className="text-xs text-red-400">
                    {errors.fields.password.message}
                  </p>
                )}

                <button
                  type="submit"
                  disabled={isLoading || !username.trim() || !password}
                  className="w-full rounded-md bg-blue-400 py-2.5 text-sm font-semibold text-white transition hover:bg-blue-500 focus:outline-none focus:ring-4 focus:ring-blue-400/30 disabled:cursor-not-allowed disabled:opacity-60"
                >
                  {isLoading ? (
                    <span className="flex items-center justify-center gap-2">
                      <span className="h-4 w-4 animate-spin rounded-full border-2 border-white/40 border-t-white" />
                      Signing you in...
                    </span>
                  ) : (
                    "Sign in"
                  )}
                </button>
              </form>
            </div>

            <p className="mt-6 text-center text-sm text-gray-500">
              Need help accessing your account?{" "}
              <Link href="/contact" className="font-medium text-blue-400 hover:text-blue-500">
                Contact your administrator
              </Link>
            </p>

            {/* <p className="mt-6 text-center text-xs text-gray-400">
              Secure authentication powered by Clerk
            </p> */}
          </div>
        </section>
      </div>
    </main>
  );
}
