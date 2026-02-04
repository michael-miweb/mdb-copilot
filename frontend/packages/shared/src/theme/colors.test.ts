import { describe, expect, it } from 'vitest';
import { colors, spacing, borderRadius } from './colors';

describe('Design Tokens', () => {
  describe('colors', () => {
    describe('light mode', () => {
      it('should have correct primary color (Violet)', () => {
        expect(colors.light.primary).toBe('#7c4dff');
      });

      it('should have correct secondary color (Magenta)', () => {
        expect(colors.light.secondary).toBe('#f3419f');
      });

      it('should have white background', () => {
        expect(colors.light.background).toBe('#ffffff');
      });

      it('should have correct surface color', () => {
        expect(colors.light.surface).toBe('#f5f5f5');
      });

      it('should have correct text colors', () => {
        expect(colors.light.onBackground).toBe('#1a1a1a');
        expect(colors.light.onSurface).toBe('#1a1a1a');
        expect(colors.light.onPrimary).toBe('#ffffff');
        expect(colors.light.onSecondary).toBe('#ffffff');
      });
    });

    describe('dark mode', () => {
      it('should have correct primary color (Indigo)', () => {
        expect(colors.dark.primary).toBe('#5750d8');
      });

      it('should have correct secondary color (Orchidée)', () => {
        expect(colors.dark.secondary).toBe('#d063de');
      });

      it('should have correct dark background', () => {
        expect(colors.dark.background).toBe('#1e2334');
      });

      it('should have correct dark surface', () => {
        expect(colors.dark.surface).toBe('#282d3e');
      });

      it('should have correct text colors for dark mode', () => {
        expect(colors.dark.onBackground).toBe('#ffffff');
        expect(colors.dark.onSurface).toBe('#ffffff');
        expect(colors.dark.onPrimary).toBe('#ffffff');
        expect(colors.dark.onSecondary).toBe('#ffffff');
      });
    });

    it('should have valid HEX color format for all colors', () => {
      const hexColorRegex = /^#[0-9a-fA-F]{6}$/;

      Object.values(colors.light).forEach((color) => {
        expect(color).toMatch(hexColorRegex);
      });

      Object.values(colors.dark).forEach((color) => {
        expect(color).toMatch(hexColorRegex);
      });
    });
  });

  describe('spacing', () => {
    it('should have correct spacing values (base 8px, multiples)', () => {
      expect(spacing.xs).toBe(4);
      expect(spacing.sm).toBe(8);
      expect(spacing.md).toBe(16);
      expect(spacing.lg).toBe(24);
      expect(spacing.xl).toBe(32);
      expect(spacing.xxl).toBe(48);
    });

    it('should follow 4px grid system', () => {
      Object.values(spacing).forEach((value) => {
        expect(value % 4).toBe(0);
      });
    });
  });

  describe('borderRadius', () => {
    it('should have correct pill radius (24px)', () => {
      expect(borderRadius.pill).toBe(24);
    });

    it('should have correct card radius (16px)', () => {
      expect(borderRadius.card).toBe(16);
    });

    it('should have correct input radius (12px)', () => {
      expect(borderRadius.input).toBe(12);
    });

    it('should have correct bottom sheet radius (24px)', () => {
      expect(borderRadius.bottomSheet).toBe(24);
    });

    it('should have correct button radius (12px)', () => {
      expect(borderRadius.button).toBe(12);
    });
  });
});
