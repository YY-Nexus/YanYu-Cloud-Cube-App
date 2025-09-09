import Navbar from '@/components/Navbar';
import './globals.css';
import type { Metadata } from 'next';
// import { Inter } from 'next/font/google';
import Footer from '@/components/Footer';
import { Analytics } from '@vercel/analytics/react';
import PlausibleProvider from 'next-plausible';
import { Suspense } from 'react';

// Use system fonts instead of Google Fonts to avoid network issues during build
// const inter = Inter({
//   subsets: ['latin'],
//   display: 'swap',
//   fallback: ['system-ui', 'arial']
// });

let title = 'QrGPT - QR Code Generator';
let description = 'Generate your AI QR Code in seconds';
let url = 'https://www.qrgpt.io';
let ogimage = 'https://www.qrgpt.io/og-image.png';
let sitename = 'qrGPT.io';

export const metadata: Metadata = {
  metadataBase: new URL(url),
  title,
  description,
  icons: {
    icon: '/favicon.ico',
  },
  openGraph: {
    images: [ogimage],
    title,
    description,
    url: url,
    siteName: sitename,
    locale: 'en_US',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    images: [ogimage],
    title,
    description,
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <head>
        <PlausibleProvider domain="qrgpt.io" />
      </head>
      <body className="font-sans">
        <Suspense fallback={<div>Loading...</div>}>
          <Navbar />
        </Suspense>
        <main>{children}</main>
        <Analytics />
        <Footer />
      </body>
    </html>
  );
}
