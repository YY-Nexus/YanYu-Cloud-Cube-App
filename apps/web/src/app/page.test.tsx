import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import HomePage from '../app/page';

// Mock next-themes
vi.mock('next-themes', () => ({
  useTheme: () => ({
    theme: 'light',
    setTheme: vi.fn(),
  }),
}));

// Mock next/link
vi.mock('next/link', () => ({
  default: ({ children, href }: any) => <a href={href}>{children}</a>,
}));

describe('HomePage', () => {
  it('renders the main heading', () => {
    render(<HomePage />);
    expect(screen.getByText('YanYu Cloud Cube')).toBeInTheDocument();
  });

  it('renders the hero description', () => {
    render(<HomePage />);
    expect(
      screen.getByText(/A modern cloud application platform/i)
    ).toBeInTheDocument();
  });

  it('renders application cards', () => {
    render(<HomePage />);
    expect(screen.getByText('EWM (QR Code Generator)')).toBeInTheDocument();
    expect(screen.getByText('Documentation Hub')).toBeInTheDocument();
    expect(screen.getByText('Chat Platform')).toBeInTheDocument();
  });

  it('renders feature cards', () => {
    render(<HomePage />);
    expect(screen.getByText('Cloud Native')).toBeInTheDocument();
    expect(screen.getByText('Type Safe')).toBeInTheDocument();
    expect(screen.getByText('Real-time')).toBeInTheDocument();
    expect(screen.getByText('Secure')).toBeInTheDocument();
  });
});