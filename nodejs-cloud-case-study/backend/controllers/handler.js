const healthCheck = (req, res) => {
    const healthData = {
        status: 'OK',
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        version: process.env.npm_package_version || '1.0.0',
        environment: process.env.NODE_ENV || 'development'
    };
    res.json(healthData);
};

const getData = (req, res) => {
    res.json({ 
        message: 'Hello from Node.js Cloud App', 
        data: [],
        server: {
            hostname: require('os').hostname(),
            platform: process.platform,
            nodeVersion: process.version
        }
    });
};

const metrics = (req, res) => {
    res.json({
        requests_total: global.requestCount || 0,
        uptime_seconds: process.uptime(),
        memory_usage: process.memoryUsage(),
        cpu_usage: process.cpuUsage()
    });
};

module.exports = {
    healthCheck,
    getData,
    metrics
};