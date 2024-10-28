resource "aws_iot_policy" "esp32_policy" {
  name = "ESP32Policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "iot:Connect",
          "iot:Publish",
          "iot:Subscribe",
          "iot:Receive"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iot_thing" "esp32_1" { name = "esp32-1" }
resource "aws_iot_thing" "esp32_2" { name = "esp32-2" }
resource "aws_iot_thing" "esp32_3" { name = "esp32-3" }
resource "aws_iot_thing" "esp32_4" { name = "esp32-4" }

resource "aws_iot_topic_rule" "StoreVibrationDataRule" {
  name        = "StoreVibrationData"
  description = "Store Vibration Data in DynamoDB"
  enabled     = true
  sql         = "SELECT * FROM 'laundry/vibration'"
  sql_version = "2016-03-23"

  dynamodbv2 {
    role_arn = "arn:aws:iam::149536472280:role/service-role/StoreVibrationDataRole"

    put_item {
      table_name = "VibrationData"
    }
  }
}