/**
 * Mock Fetch Utilities for Testing
 *
 * Provides helpers to mock fetch/API responses in tests.
 *
 * Usage:
 * ```typescript
 * import { createMockFetch, mockJsonResponse, mockErrorResponse } from '@mdb/shared/test-utils';
 *
 * // Mock multiple endpoints
 * global.fetch = createMockFetch({
 *   '/api/users': { users: [{ id: '1', name: 'John' }] },
 *   '/api/properties': { properties: [] },
 * });
 *
 * // Or use individual response helpers
 * global.fetch = jest.fn().mockResolvedValue(mockJsonResponse({ success: true }));
 * ```
 */

type MockResponseData = Record<string, unknown> | unknown[];

interface MockFetchOptions {
  status?: number;
  statusText?: string;
  headers?: Record<string, string>;
}

/**
 * Creates a mock fetch function that returns predefined responses based on URL
 * @param responses - Map of URL patterns to response data
 * @param defaultOptions - Default response options (status, headers, etc.)
 */
export function createMockFetch(
  responses: Record<string, MockResponseData>,
  defaultOptions: MockFetchOptions = {}
): typeof fetch {
  const { status = 200, statusText = 'OK', headers = {} } = defaultOptions;

  return ((url: string | URL | Request, _init?: RequestInit) => {
    const urlString = typeof url === 'string' ? url : url.toString();

    // Find matching response
    const matchedUrl = Object.keys(responses).find(
      (pattern) => urlString.includes(pattern) || urlString.endsWith(pattern)
    );

    if (matchedUrl) {
      const responseData = responses[matchedUrl];
      return Promise.resolve(
        mockJsonResponse(responseData, { status, statusText, headers })
      );
    }

    // Return 404 for unmatched URLs
    return Promise.resolve(
      mockErrorResponse(404, `No mock found for URL: ${urlString}`)
    );
  }) as typeof fetch;
}

/**
 * Creates a mock Response object with JSON data
 * @param data - The JSON data to return
 * @param options - Response options (status, headers, etc.)
 */
export function mockJsonResponse(
  data: MockResponseData,
  options: MockFetchOptions = {}
): Response {
  const { status = 200, statusText = 'OK', headers = {} } = options;

  return {
    ok: status >= 200 && status < 300,
    status,
    statusText,
    headers: new Headers({
      'Content-Type': 'application/json',
      ...headers,
    }),
    json: () => Promise.resolve(data),
    text: () => Promise.resolve(JSON.stringify(data)),
    blob: () => Promise.resolve(new Blob([JSON.stringify(data)])),
    clone: function () {
      return this;
    },
    arrayBuffer: () => Promise.resolve(new ArrayBuffer(0)),
    formData: () => Promise.resolve(new FormData()),
    body: null,
    bodyUsed: false,
    redirected: false,
    type: 'basic',
    url: '',
    bytes: () => Promise.resolve(new Uint8Array()),
  } as Response;
}

/**
 * Creates a mock error Response
 * @param status - HTTP status code (e.g., 404, 500)
 * @param message - Error message
 */
export function mockErrorResponse(status: number, message: string): Response {
  const errorData = { error: message, status };
  return mockJsonResponse(errorData, {
    status,
    statusText: message,
  });
}

/**
 * Creates a mock network error (fetch rejection)
 */
export function mockNetworkError(message = 'Network error'): Promise<never> {
  return Promise.reject(new Error(message));
}

/**
 * Creates a delayed mock response for testing loading states
 * @param data - Response data
 * @param delayMs - Delay in milliseconds
 */
export function mockDelayedResponse(
  data: MockResponseData,
  delayMs = 100
): Promise<Response> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(mockJsonResponse(data));
    }, delayMs);
  });
}
