const serviceName = 'Service 2';

console.log(`${serviceName} started. Performing another continuous task...`);

let value = 100;
setInterval(() => {
  console.log(`${serviceName}: Current value - ${value--}`);
  if (value < 0) value = 100;
}, 3000); 