"use client";

import { ITEM_PER_PAGE } from "@/lib/settings";
import { usePathname, useRouter, useSearchParams } from "next/navigation";

const Pagination = ({ page, count }: { page: number; count: number }) => {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();

  const totalPages = Math.ceil(count / ITEM_PER_PAGE);

  const canPrev = page > 1;
  const canNext = page < totalPages;

  function changePage(newPage: number) {
    if (newPage < 1 || newPage > totalPages) return;

    const params = new URLSearchParams(searchParams.toString());
    params.set("page", newPage.toString());

    router.push(`${pathname}?${params.toString()}`);
  }

  return (
    <div className="p-4 flex items-center justify-between text-gray-500">
      <button
        disabled={!canPrev}
        className="py-2 px-4 rounded-md bg-slate-200 text-xs font-semibold disabled:opacity-50 disabled:cursor-not-allowed"
        onClick={() => changePage(page - 1)}
      >
        Prev
      </button>

      <div className="flex items-center gap-2 text-sm">
        {Array.from({ length: totalPages }, (_, index) => {
          const pageIndex = index + 1;

          return (
            <button
              key={pageIndex}
              className={`px-2 rounded-sm ${page === pageIndex ? "bg-lamaSky" : ""}`}
              onClick={() => changePage(pageIndex)}
            >
              {pageIndex}
            </button>
          );
        })}
      </div>

      <button
        disabled={!canNext}
        className="py-2 px-4 rounded-md bg-slate-200 text-xs font-semibold disabled:opacity-50 disabled:cursor-not-allowed"
        onClick={() => changePage(page + 1)}
      >
        Next
      </button>
    </div>
  );
};

export default Pagination;
