/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "standalone",
  images: {
    remotePatterns: [
      { hostname: "images.pexels.com" },
      {
        protocol: "https",
        hostname: "res.cloudinary.com",
        pathname: "/dckzn6fh5/image/upload/**",
      },
    ],
  },
};

export default nextConfig;
