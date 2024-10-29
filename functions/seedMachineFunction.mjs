import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, BatchWriteCommand, PutCommand } from "@aws-sdk/lib-dynamodb";

// Initialize DynamoDB client
const client = new DynamoDBClient({});
const ddbDocClient = DynamoDBDocumentClient.from(client);

// Function to generate machines
const generateMachines = () => {
  const washers = Array.from({ length: 8 }, (_, i) => {
    const washerNumber = 8 - i;
    const machineID = `RVREB-W${washerNumber}`;
    const shortName = `W${washerNumber}`;
    const isFunctional = washerNumber <= 2;
    const status = isFunctional ? (i % 2 === 0 ? "available" : "in-use") : "disabled";
    return {
      machineID: machineID,
      shortName: shortName,
      type: "washer",
      status,
      timeRemaining: isFunctional ? (i % 2 === 0 ? 0 : Math.floor(Math.random() * 60)) : 0,
      position: { x: 20, y: 20 + i * 15 }
    };
  });

  const dryers = Array.from({ length: 6 }, (_, i) => {
    const dryerNumber = i + 1;
    const machineID = `RVREB-D${dryerNumber}`;
    const shortName = `D${dryerNumber}`;
    const isFunctional = dryerNumber >= 5;
    const status = isFunctional ? (i % 2 === 0 ? "available" : "in-use") : "disabled";
    return {
      machineID: machineID,
      shortName: shortName,
      type: "dryer",
      status,
      timeRemaining: isFunctional ? (i % 2 === 0 ? 0 : Math.floor(Math.random() * 60)) : 0,
      position: { x: 80, y: 20 + i * 20 }
    };
  });

  return [...washers, ...dryers];
};

const batchWriteMachines = async (machines) => {
  const batches = [];
  const batchSize = 25;

  for (let i = 0; i < machines.length; i += batchSize) {
    const batch = machines.slice(i, i + batchSize).map(machine => ({
      PutRequest: { Item: machine }
    }));
    batches.push(batch);
  }

  for (const batch of batches) {
    const tableName = process.env.MACHINE_STATUS_TABLE;  // Retrieve table name from environment variable
    const batchWriteCommand = new BatchWriteCommand({
      RequestItems: {
        [tableName]: batch  // Use the table name from the environment variable
      }
    });
    await ddbDocClient.send(batchWriteCommand);
  }
};

// Lambda handler to insert the machines into DynamoDB
export const handler = async () => {
  const machines = generateMachines();
  
  try {
    // Use batch write for inserting machines
    await batchWriteMachines(machines);
    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Machines inserted successfully" }),
    };
  } catch (error) {
    console.error("Error inserting machines:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Failed to insert machines", error }),
    };
  }
};