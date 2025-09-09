import Link from 'next/link';
import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import {
  Cloud,
  Code,
  Database,
  MessageSquare,
  FileText,
  QrCode,
  BarChart3,
  Shield,
  Zap,
} from 'lucide-react';

const apps = [
  {
    name: 'EWM (QR Code Generator)',
    description: 'Advanced QR code generation and management system with analytics',
    icon: QrCode,
    href: '/ewm',
    status: 'Active',
    color: 'bg-blue-500',
  },
  {
    name: 'Documentation Hub',
    description: 'Comprehensive documentation platform built with Nextra',
    icon: FileText,
    href: '/docs',
    status: 'Active',
    color: 'bg-green-500',
  },
  {
    name: 'Chat Platform',
    description: 'Real-time chat application powered by Supabase',
    icon: MessageSquare,
    href: '/chat',
    status: 'Active',
    color: 'bg-purple-500',
  },
  {
    name: 'Analytics Dashboard',
    description: 'Real-time analytics and monitoring dashboard',
    icon: BarChart3,
    href: '/analytics',
    status: 'Coming Soon',
    color: 'bg-orange-500',
  },
];

const features = [
  {
    name: 'Cloud Native',
    description: 'Built for the cloud with modern architecture patterns',
    icon: Cloud,
  },
  {
    name: 'Type Safe',
    description: 'Full TypeScript support with comprehensive type checking',
    icon: Code,
  },
  {
    name: 'Real-time',
    description: 'Live data synchronization across all applications',
    icon: Zap,
  },
  {
    name: 'Secure',
    description: 'Enterprise-grade security with modern authentication',
    icon: Shield,
  },
];

export default function HomePage() {
  return (
    <div className="flex flex-col">
      {/* Hero Section */}
      <section className="container flex flex-col items-center justify-center min-h-[80vh] text-center space-y-8 py-24">
        <div className="flex items-center space-x-2 mb-6">
          <div className="h-12 w-12 bg-primary rounded-lg flex items-center justify-center">
            <Cloud className="h-6 w-6 text-primary-foreground" />
          </div>
          <h1 className="text-4xl sm:text-6xl md:text-7xl font-bold">
            YanYu Cloud Cube
          </h1>
        </div>
        
        <p className="max-w-[42rem] text-muted-foreground sm:text-xl sm:leading-8">
          A modern cloud application platform that brings together all your essential tools 
          and services in one unified experience. Built with Next.js 15, TypeScript, and 
          cutting-edge technologies.
        </p>
        
        <div className="flex flex-col sm:flex-row gap-4">
          <Button size="lg" asChild>
            <Link href="/apps">Explore Applications</Link>
          </Button>
          <Button variant="outline" size="lg" asChild>
            <Link href="/docs">View Documentation</Link>
          </Button>
        </div>
      </section>

      {/* Applications Section */}
      <section className="container py-24">
        <div className="text-center mb-16">
          <h2 className="text-3xl font-bold mb-4">Integrated Applications</h2>
          <p className="text-muted-foreground max-w-2xl mx-auto">
            Access all your essential tools and services from a single platform. 
            Each application is built with modern standards and seamless integration.
          </p>
        </div>
        
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-2">
          {apps.map((app) => (
            <Card key={app.name} className="hover:shadow-lg transition-shadow">
              <CardHeader>
                <div className="flex items-center space-x-3">
                  <div className={`${app.color} p-2 rounded-lg`}>
                    <app.icon className="h-5 w-5 text-white" />
                  </div>
                  <div className="flex-1">
                    <CardTitle className="text-lg">{app.name}</CardTitle>
                    <div className="flex items-center space-x-2 mt-1">
                      <span
                        className={`inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${
                          app.status === 'Active'
                            ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300'
                            : 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300'
                        }`}
                      >
                        {app.status}
                      </span>
                    </div>
                  </div>
                </div>
              </CardHeader>
              <CardContent>
                <CardDescription className="mb-4">
                  {app.description}
                </CardDescription>
                <Button 
                  variant="outline" 
                  className="w-full" 
                  asChild
                  disabled={app.status !== 'Active'}
                >
                  <Link href={app.href}>
                    {app.status === 'Active' ? 'Launch App' : 'Coming Soon'}
                  </Link>
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

      {/* Features Section */}
      <section className="container py-24 bg-muted/50">
        <div className="text-center mb-16">
          <h2 className="text-3xl font-bold mb-4">Platform Features</h2>
          <p className="text-muted-foreground max-w-2xl mx-auto">
            Built with modern technologies and best practices for reliability, 
            performance, and developer experience.
          </p>
        </div>
        
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
          {features.map((feature) => (
            <Card key={feature.name}>
              <CardHeader className="text-center">
                <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-primary">
                  <feature.icon className="h-6 w-6 text-primary-foreground" />
                </div>
                <CardTitle className="text-lg">{feature.name}</CardTitle>
              </CardHeader>
              <CardContent>
                <CardDescription className="text-center">
                  {feature.description}
                </CardDescription>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

      {/* Stats Section */}
      <section className="container py-24">
        <div className="text-center">
          <h2 className="text-3xl font-bold mb-4">Platform Statistics</h2>
          <div className="grid gap-8 md:grid-cols-3 mt-16">
            <div className="text-center">
              <div className="text-4xl font-bold text-primary mb-2">4</div>
              <div className="text-muted-foreground">Integrated Applications</div>
            </div>
            <div className="text-center">
              <div className="text-4xl font-bold text-primary mb-2">100%</div>
              <div className="text-muted-foreground">TypeScript Coverage</div>
            </div>
            <div className="text-center">
              <div className="text-4xl font-bold text-primary mb-2">15.x</div>
              <div className="text-muted-foreground">Next.js Version</div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}