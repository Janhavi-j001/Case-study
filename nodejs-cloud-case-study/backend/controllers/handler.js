const healthCheck = (req, res) => {
    res.json({ status: 'OK', timestamp: new Date().toISOString() });
};

const getData = (req, res) => {
    res.json({ message: 'Hello from Node.js Cloud App', data: [] });
};

module.exports = {
    healthCheck,
    getData
};