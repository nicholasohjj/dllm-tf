variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "ap-southeast-1"
}

variable "MachineStatusTable" {
  description = "The name of the MachineStatusTable"
  type        = string
  default     = "MachineStatusTable"
}

variable "VibrationData" {
  description = "The name of the VibrationData table"
  type        = string
  default     = "VibrationData"
}

variable "thing_names" {
  default = ["esp32-1", "esp32-2", "esp32-3", "esp32-4"]
}

variable "CameraImageJSON" {
  description = "The name of the CameraImageJSON table"
  type        = string
  default     = "CameraImageJSON"
}