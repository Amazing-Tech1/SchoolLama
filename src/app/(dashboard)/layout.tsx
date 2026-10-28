import Menu from "@/components/Menu";
import Navbar from "@/components/Navbar";
import Image from "next/image";
import Link from "next/link";
import { auth, currentUser } from "@clerk/nextjs/server";
import { isUserRole } from "@/lib/auth";
import { redirect } from "next/navigation";

export default async function DashboardLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const { isAuthenticated } = await auth();

  if (!isAuthenticated) {
    await auth.protect();
  }

  const user = await currentUser();
  const role = user?.publicMetadata?.role;

  if (!isUserRole(role)) {
    redirect("/");
  }

  return (
    <div className="flex h-dvh overflow-hidden">
      <aside className="flex h-full w-[14%] shrink-0 flex-col overflow-y-auto overflow-x-hidden overscroll-contain p-4 md:w-[8%] lg:w-[16%] xl:w-[14%]">
        <Link href="/" className="flex items-center justify-center lg:justify-start gap-2">
          <Image src="/logo.png" alt="logo" width={32} height={32} />
          <span className="hidden lg:block font-bold">SchooLama</span>
        </Link>

        <Menu />
      </aside>

      <div className="flex h-full min-h-0 min-w-0 flex-1 flex-col overflow-hidden bg-[#F7F8FA]">
        <header className="sticky top-0 z-20 shrink-0 bg-[#F7F8FA]">
          <Navbar />
        </header>
        <main className="min-h-0 flex-1 overflow-y-auto overflow-x-hidden">{children}</main>
      </div>
    </div>
  );
}
