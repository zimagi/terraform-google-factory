variable "project_id" {
  description = "The project for the resource."
  type        = string
}

variable "network_name" {
  description = "Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035."
  type        = string
}

variable "global_address_name" {
  description = "Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035."
  type        = string
}

variable "global_address_prefix_length" {
  description = "The prefix length of the IP range. If not present, it means the address field is a single IP address."
  type        = number
  default     = 20
}

variable "global_address" {
  description = "The IP address or beginning of the address range represented by this resource. "
  type        = string
  default     = "192.168.0.0"
}

variable "pool_name" {
  description = "User-defined name of the WorkerPool."
  type        = string
}

variable "pool_location" {
  description = "The location for the resource."
  type        = string
}

variable "disk_size_gb" {
  description = "Size of the disk attached to the worker, in GB."
  type        = number
  default     = 100
}

variable "machine_type" {
  description = "Machine type of a worker."
  type        = string
  default     = "e2-medium"
}

variable "no_external_ip" {
  description = "If true, workers are created without any public address, which prevents network egress to public IPs."
  type        = bool
  default     = false
}