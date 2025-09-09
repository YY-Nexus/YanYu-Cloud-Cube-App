import type { Metadata } from 'next';
import { ThemeProvider } from '@/components/theme-provider';
import { Header } from '@/components/layout/header';
import { Footer } from '@/components/layout/footer';
import '@/styles/globals.css';

export const metadata: Metadata = {
  title: {
    default: 'YanYu Cloud Cube',
    template: '%s | YanYu Cloud Cube',
  },
  description: 'YanYu Cloud Cube - Modern cloud application platform with integrated tools and services.',
  keywords: ['cloud', 'platform', 'applications', 'nextjs', 'typescript'],
  authors: [{ name: 'YY-Nexus' }],
  creator: 'YY-Nexus',
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: 'https://cloud.yanyu.com',
    title: 'YanYu Cloud Cube',
    description: 'Modern cloud application platform with integrated tools and services.',
    siteName: 'YanYu Cloud Cube',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'YanYu Cloud Cube',
    description: 'Modern cloud application platform with integrated tools and services.',
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className="font-sans">
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <div className="relative flex min-h-screen flex-col">
            <Header />
            <main className="flex-1">{children}</main>
            <Footer />
          </div>
        </ThemeProvider>
      </body>
    </html>
  );
}