const serviceName = 'Service 1';

console.log(`${serviceName} started. Performing continuous task...`);

let counter = 0;
setInterval(() => {
  console.log(`${serviceName}: Task running - ${counter++}`);
}, 5000); 