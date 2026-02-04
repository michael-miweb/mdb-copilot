import React from 'react';
import { render } from '@testing-library/react-native';
import App from '../App';

describe('App', () => {
  it('renders without crashing', () => {
    const { toJSON } = render(<App />);
    expect(toJSON()).toBeTruthy();
  });

  it('renders with expected structure', () => {
    const { toJSON } = render(<App />);
    const tree = toJSON();

    // Verify the app renders a view with children
    expect(tree).not.toBeNull();
    expect(tree?.type).toBe('div'); // react-native-web renders as div
    expect(tree?.children).toBeDefined();
  });

  it('renders app content correctly', () => {
    const { toJSON } = render(<App />);
    const treeString = JSON.stringify(toJSON());

    // Check that the rendered content contains expected text
    expect(treeString).toContain('MDB Copilot');
    expect(treeString.match(/Light Mode|Dark Mode/)).toBeTruthy();
  });
});
