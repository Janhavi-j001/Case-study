const request = require('supertest');
const app = require('../app');

describe('API Endpoints', () => {
  test('GET /api/health should return 200', async () => {
    const response = await request(app)
      .get('/api/health')
      .expect(200);
    
    expect(response.body).toHaveProperty('status', 'OK');
    expect(response.body).toHaveProperty('timestamp');
  });

  test('GET /api/data should return application data', async () => {
    const response = await request(app)
      .get('/api/data')
      .expect(200);
    
    expect(response.body).toHaveProperty('message');
    expect(response.body).toHaveProperty('server');
  });
});