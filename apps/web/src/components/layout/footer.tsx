export function Footer() {
  return (
    <footer className="border-t bg-background">
      <div className="container flex flex-col items-center justify-between gap-4 py-10 md:h-24 md:flex-row md:py-0">
        <div className="flex flex-col items-center gap-4 px-8 md:flex-row md:gap-2 md:px-0">
          <div className="h-6 w-6 bg-primary rounded-sm" />
          <p className="text-center text-sm leading-loose text-muted-foreground md:text-left">
            Built by{' '}
            <a
              href="https://github.com/YY-Nexus"
              target="_blank"
              rel="noreferrer"
              className="font-medium underline underline-offset-4"
            >
              YY-Nexus
            </a>
            . The source code is available on{' '}
            <a
              href="https://github.com/YY-Nexus/YanYu-Cloud-Cube-App"
              target="_blank"
              rel="noreferrer"
              className="font-medium underline underline-offset-4"
            >
              GitHub
            </a>
            .
          </p>
        </div>
        <div className="flex items-center space-x-4">
          <p className="text-xs text-muted-foreground">
            © 2024 YanYu Cloud Cube. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}