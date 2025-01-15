import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, PutCommand, UpdateCommand } from "@aws-sdk/lib-dynamodb";

// Initialize DynamoDB client
const client = new DynamoDBClient({});
const ddbDocClient = DynamoDBDocumentClient.from(client);

// Lambda handler to store vibration data in DynamoDB
export const handler = async (event) => {
  const tableName = process.env.DYNAMODB_TABLE; // Table for storing vibration data
  const machineStatusTable = process.env.MACHINE_STATUS_TABLE; // Table to update machine status

  // Structure the event data to fit the DynamoDB table's schema
  const params = {
    TableName: tableName,
    Item: {
      ...event
    },
  };

  try {
    // Insert vibration data into DynamoDB
    await ddbDocClient.send(new PutCommand(params));
    console.log("Vibration data stored successfully:", event);

    // Check if vibration is 1 and update machine status if needed
    if (event.vibration === 1 && event.machine_id) {
      const updateParams = {
        TableName: machineStatusTable,
        Key: { machineID: event.machine_id },
        UpdateExpression: "SET #status = :status",
        ExpressionAttributeNames: {
          "#status": "status",
        },
        ExpressionAttributeValues: {
          ":status": "in-use",
        },
      };

      await ddbDocClient.send(new UpdateCommand(updateParams));
      console.log(`Machine status updated to 'in-use' for machine_id: ${event.machine_id}`);
    }

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Data processed successfully" }),
    };
  } catch (error) {
    console.error("Error processing data:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Failed to process data", error: error.message }),
    };
  }
};
