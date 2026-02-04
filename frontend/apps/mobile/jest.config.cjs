const path = require('path');

/** @type {import('jest').Config} */
module.exports = {
  testEnvironment: 'node',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.ts'],
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
  moduleNameMapper: {
    '^@mdb/shared$': '<rootDir>/../../packages/shared/src',
    '^@mdb/shared/(.*)$': '<rootDir>/../../packages/shared/src/$1',
    // Mock react-native with react-native-web for testing
    '^react-native$': 'react-native-web',
  },
  transform: {
    '^.+\\.(js|jsx|ts|tsx)$': ['babel-jest', { configFile: './babel.config.cjs' }],
  },
  // Transform all relevant packages including pnpm .pnpm folder
  transformIgnorePatterns: [
    '/node_modules/(?!((jest-)?react-native(-web)?|@react-native(-community)?|expo(nent)?|@expo(nent)?/.*|@expo-google-fonts/.*|react-navigation|@react-navigation/.*|native-base|react-native-svg|react-native-paper|\\.pnpm/))',
  ],
  testPathIgnorePatterns: ['/node_modules/', '/android/', '/ios/'],
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/index.ts',
  ],
  // Resolve modules from the monorepo root
  moduleDirectories: ['node_modules', path.join(__dirname, '../../..', 'node_modules')],
};
