import { describe, expect, it } from 'vitest';
import {
  createMockFetch,
  mockJsonResponse,
  mockErrorResponse,
  mockNetworkError,
  mockDelayedResponse,
} from './mockFetch';

describe('Mock Fetch Utilities', () => {
  describe('mockJsonResponse', () => {
    it('creates a response with JSON data', async () => {
      const data = { id: '1', name: 'Test' };
      const response = mockJsonResponse(data);

      expect(response.ok).toBe(true);
      expect(response.status).toBe(200);
      expect(await response.json()).toEqual(data);
    });

    it('creates a response with custom status', async () => {
      const data = { created: true };
      const response = mockJsonResponse(data, { status: 201 });

      expect(response.ok).toBe(true);
      expect(response.status).toBe(201);
    });

    it('sets ok to false for error status codes', () => {
      const response = mockJsonResponse({}, { status: 400 });
      expect(response.ok).toBe(false);
    });

    it('includes Content-Type header', () => {
      const response = mockJsonResponse({});
      expect(response.headers.get('Content-Type')).toBe('application/json');
    });

    it('allows custom headers', () => {
      const response = mockJsonResponse({}, {
        headers: { 'X-Custom': 'value' },
      });
      expect(response.headers.get('X-Custom')).toBe('value');
    });
  });

  describe('mockErrorResponse', () => {
    it('creates a 404 error response', async () => {
      const response = mockErrorResponse(404, 'Not found');

      expect(response.ok).toBe(false);
      expect(response.status).toBe(404);
      expect(await response.json()).toEqual({
        error: 'Not found',
        status: 404,
      });
    });

    it('creates a 500 error response', async () => {
      const response = mockErrorResponse(500, 'Server error');

      expect(response.status).toBe(500);
      expect(response.statusText).toBe('Server error');
    });
  });

  describe('mockNetworkError', () => {
    it('rejects with a network error', async () => {
      await expect(mockNetworkError()).rejects.toThrow('Network error');
    });

    it('allows custom error message', async () => {
      await expect(mockNetworkError('Connection timeout')).rejects.toThrow(
        'Connection timeout'
      );
    });
  });

  describe('mockDelayedResponse', () => {
    it('returns response after delay', async () => {
      const data = { delayed: true };
      const start = Date.now();

      const response = await mockDelayedResponse(data, 50);
      const elapsed = Date.now() - start;

      expect(elapsed).toBeGreaterThanOrEqual(40); // Allow some variance
      expect(await response.json()).toEqual(data);
    });
  });

  describe('createMockFetch', () => {
    it('returns matching response for URL', async () => {
      const mockFetch = createMockFetch({
        '/api/users': { users: [{ id: '1' }] },
      });

      const response = await mockFetch('/api/users');
      expect(await response.json()).toEqual({ users: [{ id: '1' }] });
    });

    it('returns 404 for unmatched URL', async () => {
      const mockFetch = createMockFetch({});

      const response = await mockFetch('/api/unknown');
      expect(response.status).toBe(404);
    });

    it('matches partial URLs', async () => {
      const mockFetch = createMockFetch({
        '/api/properties': { properties: [] },
      });

      const response = await mockFetch('https://example.com/api/properties?page=1');
      expect(response.ok).toBe(true);
    });

    it('handles multiple endpoints', async () => {
      const mockFetch = createMockFetch({
        '/api/users': { users: [] },
        '/api/properties': { properties: [] },
        '/api/contacts': { contacts: [] },
      });

      const users = await mockFetch('/api/users');
      const properties = await mockFetch('/api/properties');
      const contacts = await mockFetch('/api/contacts');

      expect(await users.json()).toEqual({ users: [] });
      expect(await properties.json()).toEqual({ properties: [] });
      expect(await contacts.json()).toEqual({ contacts: [] });
    });
  });
});
